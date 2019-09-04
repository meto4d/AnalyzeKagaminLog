#!/usr/bin/env ruby
# coding: utf-8

module Anakag
    module_function
    @encoding = 'cp932'
    @csv_file = {}
    attr_reader :encoding, :csv_file
    def main
        if ARGV.size >= 3
            STDERR.puts "usage: Anakag ARGV"
            exit 1
        elsif ARGV.size == 2
            @encoding = ARGV[1]
        end
        # Encoding.default_internal = 'utf-8'
        # Encoding.default_external = @encoding

        pcsv = "port_count.csv"
        ncsv = "nsplayer_count.csv"
        @csv_file[:port] = File.open(pcsv, mode='w+')
        @csv_file[:nsplayer] = File.open(ncsv, mode='w+')

        argv = ARGV[0]
        if FileTest.directory? argv
            analyze_dir(argv)
        elsif FileTest.file? argv
            analyze_file(argv)
        else
            raise "its neither directry nor file"
        end
    end # main

    # directory
    def analyze_dir(path)
        Dir.chdir(path)
        Dir.foreach(path){|file|
            print file
            analyze_file(file)
            puts ' done.'
        }
    end

    # file
    def analyze_file(path)

        if path =~ /kagami_(\d+).txt$/
            @csv_file.each{|_, f| f.puts $1}
            File.open(path, mode='r', encoding: @encoding){|f|
                port_count = {}
                nsplayer = {}
                wmp = {}

                # Each Line
                f.each_line{|line|
                    eline = line.encode(Encoding::UTF_8)

                    # ポート番号使用頻度カウント
                    if eline =~ /\[(\d+)\]\s+外部から接続要求を受信しました/
                        numhash = $1.to_sym
                        # sp = line.split(/\s/)
                        # sp.delete('/')
                        # num = sp[2][1..-2].to_i
                        # numhash = sp[2][1..-2].to_sym
                        port_count[numhash] = 0 unless port_count.has_key?(numhash)
                        port_count[numhash] += 1
                    end

                    # UA:NSPlayer カウント
                    if eline =~ %r"\[\d+\]\s*User-Agent:\sNSPlayer/([0-9a-zA-Z\.]+)"
                        nshash = $1.to_sym
                        nsplayer[nshash] = 0 unless nsplayer.has_key?(nshash)
                        nsplayer[nshash] += 1
                    end

                    if eline =~ %r"ヘッダを取得するための接続 UA: Windows-Media-Player/([0-9\.]+)"
                        wmphash = $1.to_sym
                        wmp[wmphash] = 0 unless wmp.has_key?(wmphash)
                        wmp[wmphash] += 1
                    end
                }

                # port_count
                # port_count.delete_if{|k, v| v == 0}
                port_count = Hash[port_count.sort]
                port_count.each{|k, v| @csv_file[:port].puts k.to_s + "," + v.to_s}

                nsplayer = Hash[nsplayer.sort]
                nsplayer.each{|k, v| @csv_file[:nsplayer].puts k.to_s + "," + v.to_s}
                wmp.each{|k, v| @csv_file[:nsplayer].puts k.to_s + "," + v.to_s + ",1"}
            }
        end

    end

end # module Anakag

if __FILE__ == $0
    Anakag.main
end
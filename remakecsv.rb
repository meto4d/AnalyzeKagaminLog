#!/usr/bin/env ruby
# coding: utf-8

## グラフ化しやすいように整形する用

module Remakecsv
    module_function
    @csv_file = {}
    attr_reader :csv_file

    def main
        if ARGV.size > 1
            STDERR.puts "usage: ARGV"
            exit 1
        end

        recsv(ARGV[0])

    end #main

    def recsv(path)

        nsplayer = {}
        # nsplayer = {20000101: {1.0.0: 2, 2.1.3: 5}}
        arr = []

        File.open(path, mode='r'){|f|
            f.each_line{|line|
                if line.gsub(/\r/, "") =~ /^([\d\.]*),(\d)$/
                    v = $1.to_i.floor
                    arr.append(v) unless arr.include? v
                end
            }
            d = {}
            # d = {1.0.0: 2, 2.1.3: 5}
            arr = arr.sort
            arr.each{|v| d[v] = 0}
            
            day = 0
            f.seek(0, IO::SEEK_SET)
            f.each_line{|line|

                if line.gsub(/\r/, "") =~ /^(\d+)$/

                    nsplayer[day] = d.dup unless day == 0
                    day = $1.to_i
                    d.each_key{|k| d[k]=0}
                    next
                end
                
                if line.gsub(/\r/, "") =~ /^([\d\.]*),(\d)$/
                    d[$1.to_i.floor] += $2.to_i
                end

            }
        }

        puts nsplayer[20160124]
        puts nsplayer[20160125]

        recsv = File.open("recsv.csv", mode='w+')
        recsv.puts "," + arr.join(",")
        nsplayer.each{|k, v|
            tx = k.to_s

            arr.each{|av|
                tx += ("," + v[av].to_s)
            }
            recsv.puts tx
        }
    end

end #end module

if __FILE__ == $0
    Remakecsv.main
end
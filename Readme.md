# AnalyzeKagaminLog

通称かがみんによって生成されたLogファイルを分析し、csvへ出力するスクリプト

ちょっとしたきっかけでUAから、ユーザのプレイヤー分布を調べてみたいと思ったため、作成したプログラムです。

## How to use

引数にkagamin_**[日付]**.txtか、フォルダパスを指定します。

テストログファイルとしてkagamin_20990099.txtを用意しました。

例:

> $ ruby anakag.rb ./kagamin_20990099.txt

or

> $ ruby anakag.rb ./

基本的にかがみんがWindows環境で動作するプログラムなため、Windows環境でのみ動作を確認しています。

また、ver2の2.1.15が現行の基準バージョンなため、文字コードもShift-JISを基準にした __CP932__ にて解析を行います。

ただし、解析スクリプトのanakag.rbはUTF-8で書かれています。

出力ファイルは
* port_count.csv

ポート番号の使用頻度

| 日付 |
|----|
|20990099|

| ポート番号 | 使用回数 |
|----|----|
|8001|5|
|8002|2|


* nsplayer_count.csv

NSPlayerを持つUAへストリームを開始したカウント

|日付|
|----|
|20990099|

|NSPlayerVer|接続開始回数|WMPの場合1|
|----|----|----|
|1.00.0000|20||
|2.00.0000|5||
|3.00.0000|10|1|


の2ファイルが作成されるようになっています。


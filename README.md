<br>
    <h2>
        <p align="center"><img src="https://user-images.githubusercontent.com/17927874/197396354-af0a675c-9f8c-4bf3-8bb8-c32cbbf4db59.png"></p>
        <p align="center"> NovelAI Manager </p>
    </h2>
<p align="center">~ NovelAIでプロンプトのメモを良い感じに出来るソフトウェア ~</p>
<p align="center">
    <a href="https://github.com/riku1227/NovelAIManager/releases/">
        <img src="https://img.shields.io/badge/DOWNLOAD-Windows&macOS-green?style=for-the-badge">
    </a>
</p>

* * *
<br>

![GitHub](https://img.shields.io/github/license/riku1227/NovelAIManager?style=flat-square)
![GitHub](https://img.shields.io/github/downloads/riku1227/NovelAIManager/total?style=flat-square)  
NovelAIのプロンプトなどを良い感じに保存しておけるソフトウェアです (Windows / macOS 対応)  
とりあえず最低限使えるように速度重視で開発したので現状だと不親切 / 挙動が悪い などのことがあります  
完全個人用にメモしておきたいプロンプトや、何処かしらで見つけたプロンプトをとりあえずメモしておきたい時など  
**飽き性なのでメンテナンスには期待しないでください**  
**データ消える可能性だって使えなくなる可能性だってあるんで使うのは自己責任で！**

<br>

## ダウンロード方法
[https://github.com/riku1227/NovelAIManager/releases/latest](https://github.com/riku1227/NovelAIManager/releases/latest)  
ここから「Assets」にある「NovelAIManager_{使ってるOS}\_{アーキテクチャ}\_{バージョン}.zip
」をダウンロード  
わかりやすい場所に解凍して中にある実行ファイルを起動

## アップデート方法
### Windowsの場合
新しいバージョンのファイル全てを現在のバージョンのフォルダにコピー、上書きするもしくは  
新しいバージョンのフォルダに「gallery_db」フォルダをコピーするでアップデートすることができます
### macOSの場合
.appを入れ替えるだけで更新されます

## 🖼️ スクリーンショット
* * *
<h3>メイン機能</h3>
<img src="https://user-images.githubusercontent.com/17927874/200830751-1f81d8c6-9818-4933-9c51-6ee6a80f4890.png" width="45%">
<img src="https://user-images.githubusercontent.com/17927874/200839915-308a1d9a-5751-4fbe-baca-406416c7114e.png" width="45%">
<p></p>
<img src="https://user-images.githubusercontent.com/17927874/200832356-305a8297-c823-4b95-b016-3fe356272788.png" width="45%">
<img src="https://user-images.githubusercontent.com/17927874/200832273-ab08c0b7-b893-49a0-b32c-ddb07a13f66e.png" width="45%">
<h3>PNGメタデータ表示機能</h3>
<img src="https://user-images.githubusercontent.com/17927874/200832672-3994df48-fbbe-443d-ae24-435b03030e48.png" width="45%">

## 📄 詳細な情報
* * *
* 保存したプロンプトの画像はどこに保存される？
  * Windowsの場合「実行ファイルがあるフォルダ/gallery_db/images/」 の中に保存されます
  * macOSの場合「アプリケーションサポートフォルダ/com.riku1227.novelaiManager/gallery_db/images/」 の中に保存されます
  * そのため、元の画像を削除/移動したとしても問題無く閲覧することが可能です
  * 逆に言えば元の画像を削除してもDBから削除されません
* データベースに保存されている画像を削除する方法はある？
  * プロンプトのデータを削除すれば消えます
    * プロンプトの編集で画像を消したとしても現状はデータベースから画像は削除されません
    * 完璧に削除したい場合は画像保存が保存されているフォルダをチェックすることをおすすめします
* データを他デバイスに移したい
* データをバックアップしたい
  * 実行ファイルがあるフォルダ/gallery_db/ がソフトのデータになります
  * このデータを別の場所に保存することでバックアップが可能です
  * 他デバイスに移したい場合は移行先デバイスの実行ファイルがあるフォルダに「gallery_db」フォルダを移してください
* 起動しなくなり、メンテナンスもされていない場合データを救うとこはできますか？
  * 画像データは「gallery_db」の中にそのまま保存されているため簡単に救出可能です
  * プロンプトなどのデータは「Realm Studio」というソフトを使用し、データベースを開くことで一応可能です
    * [Realm Studio](https://github.com/realm/realm-studio/releases/)
* ここが使いにくい！
* こんな機能が欲しい！
* ここバグがある！
  * 現状の技術力で実装可能でやる気があればするかもしれない
    * TwitterとかGithubのIssueとかで言ってくれたら多分気がつきはする
* このソフトは何らかのデータをどっかに送信してたりする？
  * 保存されたデータは何処にも送信していません
    * アップデート確認機能実装したからGitHubにバージョンデータ取得用にアクセスはしてます (データは送信してない)
  * もしものもしで使用してるライブラリとかがとってる可能性はあります
* データが消えた！
* データが使えなくなった！
  * このソフトは自己責任で使ってください
  * データの保証なんてできません

## 🚀今後について
* * *
Projectページに書いていたりいなかったり  
https://github.com/users/riku1227/projects/1/views/1  

## 📄サードパーティーライセンス
* * *
プロンプト変換機能  
(開発に関わった全てのニキ達に感謝🙏)  
[naisd5ch/novel-ai-5ch-wiki-js](https://github.com/naisd5ch/novel-ai-5ch-wiki-js)

## 👥 Contributors
* * *
<a href="https://github.com/riku1227/NovelAIManager/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=riku1227/NovelAIManager" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
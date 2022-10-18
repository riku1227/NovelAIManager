<br>
    <h2>
        <p align="center"> NovelAI Manager </p>
    </h2>
<p align="center">~ NovelAIでプロンプトのメモを良い感じに出来るソフトウェア ~</p>
<p align="center">
    <a href="https://github.com/riku1227/NovelAIManager/releases/">
        <img src="https://img.shields.io/badge/DOWNLOAD-Windows-blue?style=for-the-badge&logo=windows11">
    </a>
</p>

* * *
<br>

![GitHub](https://img.shields.io/github/license/riku1227/NovelAIManager?style=flat-square)  
NovelAIのプロンプトなどを良い感じに保存しておけるソフトウェアです (現状Windwosのみ)  
とりあえず最低限使えるように速度重視で開発したので現状だと不親切 / 挙動が悪い などのことがあります  
完全個人用にメモしておきたいプロンプトや、何処かしらで見つけたプロンプトをとりあえずメモしておきたい時など  
**飽き性なのでメンテナンスには期待しないでください**  
**データ消える可能性だって使えなくなる可能性だってあるんで使うのは自己責任で！**

<br>

## ダウンロード方法
[https://github.com/riku1227/NovelAIManager/releases/latest](https://github.com/riku1227/NovelAIManager/releases/latest)  
ここから「Assets」にある「NovelAIManager_Windows_x64_{バージョン}.zip
」をダウンロード  
わかりやすい場所に解凍して中にある「novelai_manager.exe」を起動

## アップデート方法
新しいバージョンのファイル全てを現在のバージョンのフォルダにコピー、上書きするもしくは  
新しいバージョンのフォルダに「gallery_db」フォルダをコピーするでアップデートすることができます

## 🖼️ 画像
* * *
![novelai_image](https://user-images.githubusercontent.com/17927874/195606048-d290e3c8-5bd9-494c-a263-36ae98bf423d.png)
![novelai_manager_03](https://user-images.githubusercontent.com/17927874/195606701-e327b0e3-cb4b-4bef-919c-b75eda9d6764.png)

## 📄 詳細な情報
* * *
* 保存したプロンプトの画像はどこに保存される？
  * 実行ファイルがあるフォルダ/gallery_db/images/ の中に保存されます
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
* UIをもうちょっと良い感じにしたい
  * プロンプトの情報を見る画面とかかなり見にくい感じがする
* データベースに保存されてる画像のクリーニング機能が欲しくはある
* ギャラリーの順番を入れ替えれるようにしたい
* プロンプト情報の画像の順番を入れ替えれるようにしたい
* MacOS向けにリリースしたい気持ちはある
* あわよくばAndroidも... (iOSは無理)
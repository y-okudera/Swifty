![swifty_logo](https://user-images.githubusercontent.com/25205138/77408715-7bd50b80-6dfb-11ea-8ee9-49f1d6cc5cc8.png)

## 開発環境
|Tool|Version|
|:--:|:--:|
|Xcode|11.3.1 (11C505)|

## OSS
|Name|Version|Description|
|:--:|:--:|:--:|
|Alamofire|5.0.4|HTTP networking library|
|PromiseKit|6.13.1|Promise library|
|Nuke|8.4.1|Image loading and caching library|
|NVActivityIndicatorView|4.8.0|Loading animations library|

## アーキテクチャ
MVP (Passive View)

## Xcode グループ構成
|Group|Sub group|Sub sub group|Description|
|:--:|:--:|:--:|:--:|
|Application|||AppDelegate.swift, Info.plistなど<br>アプリ起動に関わるファイルを格納|
|Extensions|||Extensionファイルを格納|
||UIKit||UIKitのExtensionを格納|
||Foundation||FoundationのExtensionを格納|
|Models|||API, DBモデルを格納|
||API||APIRequest, レスポンスのDecodableモデルを格納|
||DB||DAOを格納|
|Modules|||Contract, Model, Presenter, Router, Viewで構成される<br>モジュールを格納|
||画面名||画面ごとにサブグループを構成|
|||Contract|レイヤー間のプロトコル群を格納|
|||Model|業務処理群を格納|
|||Presenter|View-Presenter間の処理群を格納|
|||Router|画面遷移処理群を格納|
|||View|画面処理群を格納|
|Resources|||Assets, Localizable.stringsなどのリソースファイルを格納|
|Utils|||汎用処理に関するファイルを格納|

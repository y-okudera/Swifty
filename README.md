# Swifty
iOS Swift samples.

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

## アーキテクチャ
MVP (Passive View)

## Xcode グループ構成
|Name|Description|
|:--:|:--:|
|Application|AppDelegate.swift, Info.plistなど<br>アプリ起動に関わるファイルを格納|
|Extensions|UIKit, Foundationでサブグループを構成<br>それぞれのExtensionファイルを格納|
|Models|API, DBでサブグループを構成<br>APIRequest, レスポンスのDecodableモデル, DAOなどのファイルを格納|
|Modules|画面ごとにサブグループを構成<br>Contract, Model, Presenter, Router, Viewの役割ごとに<br>サブサブグループを構成|
|Resources|Assets, Localizable.stringsなどのリソースファイルを格納|
|Utils|汎用処理に関するファイルを格納|


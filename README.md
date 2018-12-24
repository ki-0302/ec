# EC
ECサイトシステム

## Description
小規模のECサイトに適用できるシステムの作成を目指します。

Ruby version: 2.5.3  
Node.js version: v10.14.2

## Features
TODOが落ち着いたらまとめます。
画面プロトタイプ  
https://xd.adobe.com/view/d687c39a-22be-4ea5-602e-b42616449c4c-a0b6/?hints=off

## TODO
以下の機能を予定しています。*は優先度が高いもの。

- [ ] グローバルナビゲーション
  - [ ] ヘッダーコンテンツ
    - [ ] ニュース
    - [ ] カテゴリメニュー
    - [ ] 商品検索ボックス*
    - [ ] アカウントメニューへのリンク*
    - [ ] カートへのリンク*
    - [ ] ヘルプへのリンク
  - [ ] フッッターコンテンツ
    - [ ] サイトマップ
---
- [ ] トップページコンテンツ
  - [ ] スライドショー*
  - [ ] おすすめ商品*
  - [ ] 人気商品*
  - [ ] 閲覧した商品*
  - [ ] 購入した商品*

- [ ] アカウントメニュー
  - [ ] アカウントの作成*
  - [ ] サインイン
    - [ ] メールアドレス認証*
    - [ ] OAuth認証（Twitter・GitHub）
    - [ ] 二段階認証
  - [ ] アカウントの変更*
  - [ ] サインアウト*
  - [ ] 注文履歴*
    - [ ] 注文履歴の表示*
    - [ ] 注文内容の変更・キャンセル
  
- [ ] カート*
  - [ ] カート内容の表示・編集
  - [ ] 注文ページへのリンク
- [ ] 注文
  - [ ] 注文の変更*
    - [ ] 届け先変更
    - [ ] 支払い方法変更
    - [ ] ポイント使用
    - [ ] 分割配送
  - [ ] 注文確定*
---
- [ ] 管理コンソール
  - [ ] ユーザー管理
  - [ ] 注文管理*
  - [ ] 商品管理*
    - [ ] 商品検索
    - [ ] 商品情報登録
    - [ ] 商品管理
    - [ ] カテゴリ管理
  - [ ] コンテンツ管理*
    - [ ] スライドショー登録
    - [ ] おすすめ商品登録
  - [ ] 税率管理*
  - [ ] 会社情報管理*


、商品検索、カート、新・旧税率の切り替え（10%・8%）、軽減税率をおおまかな

modelの作成
- [ ] admin_user：管理コンソールログインユーザー
- [ ] user：エンドユーザー
- [ ] item：商品
- [ ] item_img：商品画像（複数登録するため）
- [ ] category：カテゴリー
- [ ] order：注文






- [ ] 商品データをDBから取得する
  - [ ] SQLインジェクションを検証する
    - [ ] 商品データを取得する

  - [ ] 商品データを取得する
    - [ ] 商品データを全件取得する
    - [ ] 商品データを商品名を指定して取得する

- [ ] 商品データを一覧形式で表示する
  - [ ] 商品データを一覧形式で表示する
- [ ] 商品データを一覧形式で表示する
  - [ ] 商品データを取得する
  　　- [ ] 商品データを全件取得する
  　　- [ ] 商品データを全件取得する
  - [ ] 商品データを一覧形式で表示する

```plantuml
@startuml
skinparam classAttributeIconSize 0

class User {
id
user_name
user_kana
email
password
phone_number
is_deleted
}

class UsersPoint {
id
user_id
holding_Point
}

class Address {
id
user_id
postal_code_1
postal_code_2
region
address_1
address_2
address_3
phone_number
}

class Cart {
id
user_id
item_id
item_quantity
}

class AdminUser {
id
user_name
email
password
}

class Item {
id
item_name
category_id
manufacture_name
item_code
tax_item_id
sales_price
regular_price
units_in_stock
units_in_stock_is_unlimited
display_start_date
display_end_date
item_description
search_term
jan_code
status
}

class ItemImage {
id
item_id
image_file_path
display_priority
}

class Category {
id
parent_category_id
category_name
display_start_date
display_end_date
}

class Order {
id
user_id
address_id
shipping_option_id
payment_method_id
usage_point
get_point
order_status
}

class OrderLineItem {
id
order_id
item_id
item_quantity
tax_included_price
tax_excluded_price
tax_included_item_total
tax_excluded_item_total
sales_tax
tax_rate
shipment_status
is_canceled
}

class ShippingOption {
id
shipping_option_name
shipping_cost
}




class GeneralSetting {
id
site_name
postal_code_1
postal_code_2
region
address_1
address_2
address_3
phone_number
tax_category
}

class TaxItem {
id
tax_item_name
tax_class
}

class TaxRate {
id
tax_rate_name
apply_start_date
standard_tax_rate
reduced_tax_rate
}

class Slideshow {
id
slideshow_name
description
image_file_path
url
}

class WhatsNew {
id
whats_new_name
description
posting_date
}

User -{ Cart
User -{ Address
User - UsersPoint
Cart -- Item
Item - Category
Item --{ ItemImage
Item -- TaxItem
User -- Order
Order -{ OrderLineItem
Order -- ShippingOption



@enduml
```

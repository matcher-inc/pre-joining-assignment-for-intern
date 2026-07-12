# Step 2: 🚪 サインイン機能

## 要件

サインインページを作成し、サインインセッションを作成すること

## サンプルビデオ

- 完成系

https://github.com/user-attachments/assets/767b1e86-74dd-4613-b9a2-25ae0aeda712

- 異常系

https://github.com/user-attachments/assets/d128dc93-3f92-4a60-b3ff-675dc1deee00

## 詳細

### Rails

- 次のエンドポイントを作成する

| HTTP メソッド | パス | アクション名 | 用途 |
| --- | --- | --- | --- |
| `GET` | `/api/sessions/new` | `new` | 現在のセッションが認証済みか確認する |
| `POST` | `/api/sessions` | `create` | サインインセッションを作成する |

- コントローラー名は `SessionsController` とする
- `new` では Rails session に保存されているユーザー識別子を確認する
  - 認証済みの場合は `{ status: "authenticated" }` を返す
  - 未認証の場合は `{ status: "unauthenticated" }` を返す
- `identifier` と `password` を受け取り、一致する `user_authentications` があれば Rails session に `user_authentications.identifier` を保存する
  - `session[:identifier] = xxx`
- `create` は、すでに認証済みのセッションではエラーを返す

### Vue

- `frontend/app/src/pages` に `sign_in` ディレクトリを追加し、`index.vue` を作成する
- `/sign_in` ルーティングの追加
- ユーザー識別子、パスワード、フォーム送信ボタンを用意する
  - パスワード入力欄はマスキングすること
- `mounted` を使ってページ読み込み時に `GET /api/sessions/new` を呼び出す
  - すでに認証済みの場合は `window.alert` 関数で通知し、`/` に遷移する
- エラーが発生した場合は `window.alert` 関数を使ってエラー内容をユーザーに知らせること
- 成功時は `/` に遷移すること

### エラーハンドリング

- 入力したユーザー識別子とパスワードに一致する `user_authentications` レコードがない場合は 401 を返す
  - この時、「ユーザー識別子またはパスワードが誤っています」というエラーを返す & ユーザーに通知する

### データベース

本要件では操作なし 💆🏻‍♂️

**📚 参考資料**

- [🔗 【Rails】Sessionの使い方について - Qiita](https://qiita.com/ozackiee/items/4ee774c81b2a0c571c05)
- [🔗 Rails セキュリティガイド - Rails ガイド](https://railsguides.jp/security.html)

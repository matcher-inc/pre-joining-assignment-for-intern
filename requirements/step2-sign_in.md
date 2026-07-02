# Step 2: 🚪 サインイン機能

## 要件

サインインページを作成し、サインインセッションを作成すること

## サンプルビデオ

- 完成系

- 異常系

## 詳細

### Rails

- `POST /api/sessions` エンドポイントを作成
- コントローラー名は `SessionsController` とする
- アクション名は `create` とする
- `identifier` と `password` を受け取り、一致する `user_authentications` があれば Rails session に `user_authentications.identifier` を保存する
  - `session[:identifier] = xxx`

### Vue

- `/sign_in` ルーティングの追加
- ユーザー識別子、パスワード、フォーム送信ボタンを用意する
  - パスワード入力欄はマスキングすること
- エラーが発生した場合は `window.alert` 関数を使ってエラー内容をユーザーに知らせること
- 成功時は `/sign_in` に遷移すること

### エラーハンドリング

- 入力したユーザー識別子とパスワードに一致する `user_authentications` レコードがない場合は 401 を返す

### データベース

本要件では操作なし 💆🏻‍♂️

**📚 参考資料**

- [🔗 【Rails】Sessionの使い方について - Qiita](https://qiita.com/ozackiee/items/4ee774c81b2a0c571c05)

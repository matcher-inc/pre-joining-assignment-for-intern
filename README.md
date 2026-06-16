# インターン生入社前課題

本課題に取り組み、社員チェックが通れば実務に入ることができます。

## 🌀 課題
タスク管理&共有アプリケーションを作成する。

目標期間：２ヶ月以内

## 🌱 必須要件

### ログイン機能

1. サインイン/サインアップすることができる。
    1. パスワードは、ハッシュ化してDBに保存（bcryptというgemを用いて）

1. 画面をリロードしてもログインを維持する
2. ログイン時は新規登録・ログインページに遷移できない
3. 未ログイン時はトップページ・新規登録・ログインページ以外に遷移できない

### タスク機能

1. 新しい自分のタスクを作成することができる。
2. 自分のタスクを一覧表示することができる。
3. 自分のタスクを完了することができる。(他人のタスクは完了できない)
4. みんなのタスクを一覧表示することができる。

### フォロー機能

1. 他ユーザーをフォロー/フォロー解除することができる。
    1. フォローしたユーザーのタスクを一覧表示することができる。

### ファイト（いいね）機能

1. タスクに対してファイト/ファイト解除することができる
    1. 自分がファイトしたタスクを一覧表示することができる
2. タスクごとにそのタスクのファイト数が表示される

## 🐇 細かい仕様

### ユーザー情報

- 名前 (文字列)、メールアドレス (文字列)、パスワード (文字列) の要素がある。
- サインアップは [名前 + メールアドレス + パスワード + パスワード再入力] が必要。
- サインインは [ (名前 or メールアドレス) + パスワード] が必要。

### タスク情報

- 作成主ユーザー、内容 (文字列)、完了したか（真偽値） の要素がある。
- 内容の入力で投稿作成。

## 各機能完了時点での進捗率（参考値）

- ログイン機能：20%
- タスク機能：60%
- フォロー機能：80%
- ファイト機能：100%

## 完成イメージ

※ この通りのUIにする必要はないです！

https://github.com/user-attachments/assets/ba56b2ec-2df2-44a3-aef0-b856956b6d90

## 技術スタック

- Vue
- Rails
- MySQL

## セットアップ

> [!IMPORTANT]
> 必ず Fork をしてください。Fork のやり方がわからなければ下記記事を参考にしてください。
> - [リポジトリをフォークする](https://docs.github.com/ja/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)
>
> Git SSH 環境を整えてください。Git SSH 環境がなければ下記記事を参考にしてください。
> - [新しい SSH キーを生成する](https://docs.github.com/ja/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
> - [新しい SSH キーを追加する](https://docs.github.com/ja/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

```sh
git clone git@github.com:<owner-name>/pre-joining-assignment-for-intern.git ~/pre-joining-assignment-for-intern
cd ~/pre-joining-assignment-for-intern
/bin/bash setup.sh
```

- ページ URL: [http://localhost:5173/](http://localhost:5173/)

## コマンド一覧

```sh
# コンテナ起動（デーモン起動）
docker compose up -d

# ログ確認
docker compose logs

# コンテナ停止
docker compose stop

# コンテナ削除
docker compose down

---

# Rails コマンド各種

## DB Migration
docker compose run --rm backend sh -lc 'bundle exec rails db:migrate'

## DB Migration Status
docker compose run --rm backend sh -lc 'bundle exec rails db:migrate:status'
```

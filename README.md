# インターン生入社前課題

本課題に取り組み、社員チェックが通れば実務に入ることができます。

## 技術スタック

- Vue
- Rails
- MySQL

## セットアップ

```sh
git clone https://github.com/matcher-inc/pre-joining-assignment-for-intern.git ~
cd ~/pre-joining-assignment-for-intern
/bin/bash setup.sh
```

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

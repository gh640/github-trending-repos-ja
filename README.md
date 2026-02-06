# GitHub トレンドリポジトリ一覧

GitHub で注目を集めているリポジトリについてリリース機能を使ってまとめています。

## ピックアップ基準

- **注目を集めている**: スター数が 10,000 以上
- **最近作成された**: リポジトリの作成日が 2022 年 1 月 1 日以降
- **英語**: README が中国語などで記述されているものは除外

## リリース作成の自動化

タグと GitHub Release は `vYYYY.MM.DD` 形式で作成します。

```bash
chmod +x scripts/release_summary.sh
scripts/release_summary.sh 2026.02.01
```

- 引数省略時は当日 (`YYYY.MM.DD`) を使います。
- サマリー本文は `summaries/YYYY.MM.DD.md` をそのまま Release Notes に使います。

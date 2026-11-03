# my-app

Next.js 16 + React 19 + TypeScript + Tailwind CSS v4 で作る Web アプリです。

## 使い方

```bash
npm install
npm run dev
```

ブラウザで http://localhost:3000 を開きます。

## コマンド

| コマンド               | 内容                                  |
| ---------------------- | ------------------------------------- |
| `npm run dev`          | 開発サーバー起動                      |
| `npm run build`        | 本番ビルド                            |
| `npm start`            | ビルド結果を起動                      |
| `npm run lint`         | ESLint                                |
| `npm run format`       | Prettier で整形                       |
| `npm run format:check` | 整形されているか確認                  |
| `npm run typecheck`    | 型チェック                            |
| `npm test`             | 単体テスト（Vitest）                  |
| `npm run test:watch`   | 単体テストをウォッチモードで実行      |
| `npm run test:e2e`     | E2E テスト（Playwright、ポート 3100） |

初めて E2E テストを手元で動かすときは、`npx playwright install chromium` でブラウザを入れてください。

## GitHub 上の Claude

Issue やプルリクエストのコメントに `@claude` と書くと、Claude Code が返信や修正をします（`.github/workflows/claude.yml`）。リポジトリの Secrets に `ANTHROPIC_API_KEY` を登録すると動きます。

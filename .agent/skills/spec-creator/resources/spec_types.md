# ドキュメントタイプ

## 1. 機能仕様 (`feature`)
- 機能要件、ユーザーストーリー、受入基準
- 対象: コンポーネント、ページ、フック

## 2. API仕様 (`api`)
- エンドポイント、リクエスト/レスポンススキーマ、認証
- 対象: route.ts, actions.ts, services/

## 3. アーキテクチャ仕様 (`architecture`)
- システム設計、コンポーネント関係、データフロー
- 対象: 全体構造、設計パターン

## 4. データベーススキーマ (`database`)
- データベース構造、関係、マイグレーション
- 対象: schema.ts, models/

## 5. 統合仕様 (`integration`)
- サードパーティ統合、Webhook、データ同期
- 対象: integrations/, webhooks/

## ドキュメント構造
```
docs/
├── features/
├── api/
├── architecture/
├── database/
└── integrations/
```

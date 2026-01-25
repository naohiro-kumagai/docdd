# ディレクトリ構造ガイド

## 命名規則
- ディレクトリ: `kebab-case`
- コンポーネントファイル: `PascalCase`
- 例: `read-only-editor/ReadOnlyEditor.tsx`

## 親子コンポーネント階層

```
parent-component/
├── ParentComponent.tsx
└── child-component/
    ├── ChildComponent.tsx
    └── grandchild-component/
        └── GrandchildComponent.tsx
```

## 実例

```
blocked-users/
├── BlockedUsersPage.tsx
└── blocked-users-content/
    ├── BlockedUsersContent.tsx
    └── blocked-users-list/
        ├── BlockedUsersList.tsx
        └── blocked-user-card/
            └── BlockedUserCard.tsx
```

## ルール
- 子コンポーネントは親コンポーネントのディレクトリ配下に配置
- エントリポイント以外のファイルを外部公開する場合はルートから再エクスポート
- サブディレクトリ配下への直接インポートは内部使用のみ

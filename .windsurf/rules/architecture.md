# アーキテクチャ原則

## ディレクトリ構造

### プロジェクトルート
```
docdd-kumagai/
├── .github/              # GitHub Actions、指示ファイル、プロンプト
│   ├── agents/          # Claude/Cursor/Gemini用設定
│   ├── instructions/    # 11フェーズワークフロー指示
│   └── prompts/         # AI用プロンプトテンプレート
├── .vscode/             # VS Code設定（MCP統合含む）
├── .windsurf/           # Windsurf IDE設定
│   ├── rules/          # AI用ルールファイル
│   └── workflows/      # 自動化ワークフロー定義
├── docs/                # プロジェクトドキュメント
│   └── adr/            # Architecture Decision Records
├── scripts/             # ユーティリティスクリプト
├── src/                 # ソースコード（将来的に追加）
└── [ルートドキュメント群]
```

## コンポーネント設計原則

### SOLID原則の遵守

#### 単一責任の原則（SRP）
```typescript
// ✅ 良い例: 責務が明確
class UserValidator {
  validate(user: User): ValidationResult {
    // バリデーションのみに集中
  }
}

class UserRepository {
  async save(user: User): Promise<void> {
    // データ永続化のみに集中
  }
}

// ❌ 悪い例: 複数の責任
class UserManager {
  validate(user: User) { /* ... */ }
  save(user: User) { /* ... */ }
  sendEmail(user: User) { /* ... */ }
  generateReport(user: User) { /* ... */ }
}
```

#### 継承よりコンポジション
```typescript
// ✅ 良い例: コンポジション
interface Logger {
  log(message: string): void
}

class UserService {
  constructor(private logger: Logger) {}
  
  createUser(data: UserData) {
    this.logger.log('Creating user...')
    // 実装
  }
}

// ❌ 悪い例: 継承
class UserService extends BaseService {
  // BaseServiceの変更に影響を受けやすい
}
```

### React/Next.js パターン

#### Server Components優先
```typescript
// ✅ 良い例: デフォルトはServer Component
export default async function UserProfile({ userId }: Props) {
  const user = await fetchUser(userId) // サーバーサイドで実行
  
  return (
    <div>
      <h1>{user.name}</h1>
      <ClientInteractiveButton userId={userId} />
    </div>
  )
}

// 'use client'は必要な場合のみ
'use client'
export function ClientInteractiveButton({ userId }: Props) {
  const [liked, setLiked] = useState(false)
  // クライアント側の状態管理
}
```

#### Presenterパターンでロジック分離
```typescript
// ✅ ビジネスロジックをhooksに抽出
function useUserProfile(userId: string) {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)
  
  useEffect(() => {
    loadUser(userId)
      .then(setUser)
      .finally(() => setLoading(false))
  }, [userId])
  
  return { user, loading }
}

// Presenter: 表示のみに集中
export function UserProfilePresenter({ userId }: Props) {
  const { user, loading } = useUserProfile(userId)
  
  if (loading) return <Spinner />
  if (!user) return <NotFound />
  
  return <UserCard user={user} />
}
```

## 状態管理戦略

### 選択基準
1. **Props Drilling**: 2-3レベルまでの親子関係
2. **React Context**: アプリ全体で共有する状態（テーマ、認証状態等）
3. **外部ライブラリ**: 複雑なグローバル状態（検討時はADR記録必須）

### Context使用例
```typescript
// ✅ グローバルな認証状態
const AuthContext = createContext<AuthState | null>(null)

export function AuthProvider({ children }: Props) {
  const [user, setUser] = useState<User | null>(null)
  
  return (
    <AuthContext.Provider value={{ user, setUser }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider')
  }
  return context
}
```

## データフロー原則

### 単方向データフロー
- 親から子へのデータ渡しはprops経由
- 子から親への通信はコールバック経由
- グローバル状態は必要最小限に

### 条件レンダリングの制御
```typescript
// ✅ propsで制御可能
interface ButtonProps {
  variant: 'primary' | 'secondary'
  disabled?: boolean
  loading?: boolean
}

function Button({ variant, disabled, loading, children }: ButtonProps) {
  if (loading) return <Spinner />
  
  return (
    <button
      className={cn(baseStyles, variantStyles[variant])}
      disabled={disabled}
    >
      {children}
    </button>
  )
}
```

## ADR（Architecture Decision Records）管理

### 重要な決定は必ず記録
- 新しい技術スタックの採用
- アーキテクチャパターンの変更
- 大きなリファクタリングの方針

### ADRの配置
- 場所: `docs/adr/decisions/*.json`
- インデックス: `docs/adr/index.json`
- 実装前に既存ADRを確認必須

### 記録すべき内容
```json
{
  "id": "ADR-0001",
  "title": "Next.js App RouterをPages Routerより優先",
  "status": "accepted",
  "context": {
    "problem": "新規ページ追加時のルーティング方式選定",
    "constraints": ["React 19対応", "Server Components利用"]
  },
  "decision": {
    "summary": "App Routerを標準とする",
    "rationale": "Server Components, Streaming, コロケーション等の利点",
    "consequences": ["学習コスト", "移行作業"]
  }
}
```

## セキュリティ原則

### 機密情報の扱い
- 環境変数で管理（`.env`）
- コードへのハードコード厳禁
- ログ出力時の機密情報マスキング

### 入力検証
- すべてのユーザー入力を検証
- XSS対策（Reactのデフォルトエスケープを活用）
- CSRF対策（Next.js標準機能を活用）

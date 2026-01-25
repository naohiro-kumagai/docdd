// ===================================
// 型定義の例
// ===================================

// ✅ 基本型定義
interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
}

// ✅ 部分型
type UserUpdateInput = Partial<Pick<User, 'name' | 'email'>>;

// ✅ Union型
type Status = 'pending' | 'active' | 'inactive';

// ✅ Discriminated Union
type ApiResult<T> =
  | { success: true; data: T }
  | { success: false; error: string };

// ✅ 型ガード
function isSuccess<T>(result: ApiResult<T>): result is { success: true; data: T } {
  return result.success;
}

// ✅ ジェネリクス
function fetchData<T>(url: string): Promise<ApiResult<T>> {
  return fetch(url)
    .then(res => res.json())
    .then(data => ({ success: true as const, data }))
    .catch(error => ({ success: false as const, error: error.message }));
}

// ✅ Readonly
interface Config {
  readonly apiUrl: string;
  readonly maxRetries: number;
}

// ✅ 定数のas const
const ROLES = ['admin', 'user', 'guest'] as const;
type Role = (typeof ROLES)[number]; // 'admin' | 'user' | 'guest'

// ✅ Server Component（デフォルト）
async function UserList(): Promise<JSX.Element> {
  // サーバーで直接データフェッチ
  const users = await fetchUsers();

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>
          <UserCard user={user} />
        </li>
      ))}
    </ul>
  );
}

// ✅ Suspenseと組み合わせ
async function Page(): Promise<JSX.Element> {
  return (
    <Suspense fallback={<Loading />}>
      <UserList />
    </Suspense>
  );
}

// ✅ エラーハンドリング
async function SafeUserList(): Promise<JSX.Element> {
  const result = await fetchUsers()
    .then(users => ({ success: true as const, users }))
    .catch(error => ({ success: false as const, error }));

  if (!result.success) {
    return <ErrorMessage message="ユーザーの取得に失敗しました" />;
  }

  return <UserList users={result.users} />;
}

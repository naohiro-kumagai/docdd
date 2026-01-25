// ✅ 良い例: 非同期操作
fetchUser(userId)
  .then(user => {
    if (user) {
      console.log('ユーザー取得成功:', user.name);
    }
  })
  .catch(error => {
    console.error('ユーザー取得失敗:', error);
    showErrorToast('ユーザー情報の取得に失敗しました');
  });

// ✅ 良い例: 同期エラー
function parseJson(jsonString: string): unknown | null {
  try {
    const result = JSON.parse(jsonString);
    return result;
  } catch (error) {
    console.error('JSON解析失敗:', error);
    return null;
  }
}

// ✅ 良い例: Server Component
async function UserList(): Promise<JSX.Element> {
  const users = await fetchUsers(); // サーバーで実行

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}

// ✅ ロジック層（Server Component）
export async function UserPage({ userId }: Props) {
  const user = await fetchUser(userId);
  const permissions = await checkPermissions(userId);

  return <UserPagePresenter user={user} canEdit={permissions.canEdit} />;
}

// ✅ 表示層（すべてprops経由で制御）
interface UserPagePresenterProps {
  user: User;
  canEdit: boolean;
}

function UserPagePresenter({ user, canEdit }: UserPagePresenterProps) {
  return (
    <div>
      <h1>{user.name}</h1>
      {canEdit && <EditButton />}
    </div>
  );
}

// ✅ Presenter関数（純粋関数）
// presenter.ts
export function formatUserStatus(user: User): string {
  if (user.isActive) return "アクティブ";
  if (user.isPending) return "承認待ち";
  return "非アクティブ";
}

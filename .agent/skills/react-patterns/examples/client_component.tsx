'use client';

import { useState, useCallback } from 'react';

// ✅ Client Component（インタラクティブ）
function Counter(): JSX.Element {
  const [count, setCount] = useState(0);

  const increment = useCallback(() => {
    setCount(c => c + 1);
  }, []);

  return (
    <button onClick={increment} type="button">
      カウント: {count}
    </button>
  );
}

// ✅ フォーム入力
function SearchInput({ onSearch }: { onSearch: (query: string) => void }): JSX.Element {
  const [query, setQuery] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSearch(query);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={query}
        onChange={e => setQuery(e.target.value)}
        placeholder="検索..."
      />
      <button type="submit">検索</button>
    </form>
  );
}

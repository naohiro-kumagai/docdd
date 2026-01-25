import { Button } from "@/components/ui/button";

export function ExampleCard() {
  return (
    <section aria-labelledby="example-title">
      <h2 id="example-title">サンプルカード</h2>
      <p>アクセシビリティを意識したUIの例です。</p>
      <Button type="button" aria-label="詳細を表示">
        詳細を見る
      </Button>
    </section>
  );
}

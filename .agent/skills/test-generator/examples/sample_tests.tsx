import { describe, expect, test } from "vitest";
import { calculateTotal } from "@/lib/utils/calculate-total";

describe("calculateTotal", () => {
  test("商品が空の場合、0を返すこと", () => {
    // Arrange
    const items: Array<{ price: number }> = [];
    const expected = 0;

    // Act
    const actual = calculateTotal(items);

    // Assert
    expect(actual).toBe(expected);
  });

  test("商品が複数の場合、合計金額を返すこと", () => {
    // Arrange
    const items = [{ price: 100 }, { price: 200 }, { price: 300 }];
    const expected = 600;

    // Act
    const actual = calculateTotal(items);

    // Assert
    expect(actual).toBe(expected);
  });
});

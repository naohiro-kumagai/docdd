import type { Meta, StoryObj } from "@storybook/react";
import { fn } from "@storybook/test";
import { FormField } from "@/components/ui/form-field/FormField";

const meta = {
  component: FormField,
} satisfies Meta<typeof FormField>;

export default meta;
type Story = StoryObj<typeof meta>;

// 通常状態
export const Default: Story = {
  args: {
    label: "ユーザー名",
    value: "",
    onChange: fn(),
  },
};

// エラーが存在する場合にエラーメッセージが表示される（条件分岐）
export const エラー状態: Story = {
  args: {
    label: "ユーザー名",
    value: "a",
    error: "ユーザー名は3文字以上である必要があります",
    onChange: fn(),
  },
};

// ローディング中に異なるUIを表示する場合
export const 読み込み中: Story = {
  args: {
    isLoading: true,
    label: "ユーザー名",
    value: "",
    onChange: fn(),
  },
};

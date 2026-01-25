import type { Meta, StoryObj } from "@storybook/react";
import { fn } from "@storybook/test";
import { Button } from "@/components/ui/button/Button";

const meta = {
  component: Button,
} satisfies Meta<typeof Button>;

export default meta;
type Story = StoryObj<typeof meta>;

// variant、sizeなどの単純なprop違いにはストーリーを作成しない
export const Default: Story = {
  args: {
    onClick: fn(),
    children: "ボタン",
  },
};

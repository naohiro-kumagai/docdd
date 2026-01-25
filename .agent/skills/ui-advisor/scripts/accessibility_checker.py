#!/usr/bin/env python3
"""
簡易的なアクセシビリティチェックを行うスクリプト。
"""
from __future__ import annotations

import argparse
import json
import re
from typing import List, Dict

IMG_TAG_PATTERN = re.compile(r"<img\b(?![^>]*\balt=)[^>]*>", re.IGNORECASE)
CLICKABLE_DIV_PATTERN = re.compile(
    r"<(div|span)\b[^>]*onClick=\{[^}]+\}[^>]*>", re.IGNORECASE
)
ROLE_PATTERN = re.compile(r"\brole=", re.IGNORECASE)


def scan_content(content: str, path: str) -> List[Dict[str, str]]:
    issues: List[Dict[str, str]] = []

    for match in IMG_TAG_PATTERN.finditer(content):
        issues.append(
            {
                "path": path,
                "type": "IMG_ALT",
                "message": "alt属性がないimgタグが検出されました",
                "snippet": match.group(0),
            }
        )

    for match in CLICKABLE_DIV_PATTERN.finditer(content):
        snippet = match.group(0)
        if not ROLE_PATTERN.search(snippet):
            issues.append(
                {
                    "path": path,
                    "type": "CLICKABLE_NON_SEMANTIC",
                    "message": "role属性のないクリック可能要素が検出されました",
                    "snippet": snippet,
                }
            )

    return issues


def main() -> int:
    parser = argparse.ArgumentParser(description="アクセシビリティ簡易チェック")
    parser.add_argument("paths", nargs="+", help="対象ファイル")
    args = parser.parse_args()

    all_issues: List[Dict[str, str]] = []
    for path in args.paths:
        try:
            with open(path, "r", encoding="utf-8") as handle:
                content = handle.read()
            all_issues.extend(scan_content(content, path))
        except OSError as exc:
            all_issues.append({"path": path, "error": str(exc)})

    print(json.dumps({"issues": all_issues}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

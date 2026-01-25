#!/usr/bin/env python3
"""
ADR JSONの最低限の妥当性を検証するスクリプト。
"""
from __future__ import annotations

import argparse
import json
from typing import List, Dict

REQUIRED_FIELDS = [
    "id",
    "title",
    "status",
    "date",
    "context",
    "decision",
    "consequences",
]
ALLOWED_STATUS = {"proposed", "accepted", "deprecated", "superseded"}


def validate_adr(path: str) -> List[Dict[str, str]]:
    errors: List[Dict[str, str]] = []
    try:
        with open(path, "r", encoding="utf-8") as handle:
            data = json.load(handle)
    except (OSError, json.JSONDecodeError) as exc:
        return [{"path": path, "error": f"読み取り失敗: {exc}"}]

    for field in REQUIRED_FIELDS:
        if field not in data:
            errors.append({"path": path, "error": f"必須項目不足: {field}"})

    status = data.get("status")
    if status and status not in ALLOWED_STATUS:
        errors.append({"path": path, "error": f"ステータス不正: {status}"})

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="ADR JSON Validator")
    parser.add_argument("paths", nargs="+", help="ADR JSONのパス")
    args = parser.parse_args()

    all_errors: List[Dict[str, str]] = []
    for path in args.paths:
        all_errors.extend(validate_adr(path))

    print(json.dumps({"errors": all_errors}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

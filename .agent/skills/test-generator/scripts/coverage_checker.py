#!/usr/bin/env python3
"""
ソースファイルに対応するテストファイルの有無を確認するスクリプト。
"""
from __future__ import annotations

import argparse
import json
import os
from typing import Dict, List

TEST_SUFFIXES = [".test.ts", ".test.tsx", ".spec.ts", ".spec.tsx"]


def expected_test_paths(source_path: str) -> List[str]:
    base, _ = os.path.splitext(source_path)
    candidates = [f"{base}{suffix}" for suffix in TEST_SUFFIXES]

    directory, filename = os.path.split(source_path)
    name, _ = os.path.splitext(filename)
    candidates.extend(
        [
            os.path.join(directory, "__tests__", f"{name}{suffix}")
            for suffix in TEST_SUFFIXES
        ]
    )
    return candidates


def main() -> int:
    parser = argparse.ArgumentParser(description="Test coverage checker")
    parser.add_argument("paths", nargs="+", help="ソースファイルのパス")
    args = parser.parse_args()

    report: List[Dict[str, object]] = []
    for source in args.paths:
        candidates = expected_test_paths(source)
        found = [path for path in candidates if os.path.exists(path)]
        report.append(
            {
                "source": source,
                "candidates": candidates,
                "has_test": len(found) > 0,
                "found": found,
            }
        )

    print(json.dumps({"results": report}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

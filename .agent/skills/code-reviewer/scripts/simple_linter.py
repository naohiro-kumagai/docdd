#!/usr/bin/env python3
"""
簡易的な機械チェックを行うスクリプト。
"""
from __future__ import annotations

import argparse
import json
import os
import re
from typing import Iterable, List, Dict

EXCLUDE_DIRS = {".git", "node_modules", "dist", "build", ".next", ".agent"}
TARGET_EXTENSIONS = {
    ".ts",
    ".tsx",
    ".js",
    ".jsx",
    ".py",
    ".md",
    ".json",
    ".yml",
    ".yaml",
    ".css",
    ".scss",
}
PATTERNS = {
    "TODO": re.compile(r"\bTODO\b"),
    "FIXME": re.compile(r"\bFIXME\b"),
    "HACK": re.compile(r"\bHACK\b"),
    "CONSOLE_LOG": re.compile(r"\bconsole\.log\b"),
    "DEBUGGER": re.compile(r"\bdebugger\b"),
    "PRINT": re.compile(r"\bprint\("),
}


def iter_files(paths: Iterable[str]) -> Iterable[str]:
    for base in paths:
        if os.path.isfile(base):
            yield base
            continue
        for root, dirs, files in os.walk(base):
            dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS]
            for name in files:
                _, ext = os.path.splitext(name)
                if ext.lower() in TARGET_EXTENSIONS:
                    yield os.path.join(root, name)


def scan_file(path: str) -> List[Dict[str, str]]:
    issues: List[Dict[str, str]] = []
    try:
        with open(path, "r", encoding="utf-8") as handle:
            for index, line in enumerate(handle, start=1):
                for label, pattern in PATTERNS.items():
                    if pattern.search(line):
                        issues.append(
                            {
                                "path": path,
                                "line": str(index),
                                "type": label,
                                "message": "機械的に検出された注意点",
                                "snippet": line.rstrip(),
                            }
                        )
    except UnicodeDecodeError:
        pass
    return issues


def main() -> int:
    parser = argparse.ArgumentParser(description="簡易リントスクリプト")
    parser.add_argument("paths", nargs="+", help="対象ファイルまたはディレクトリ")
    args = parser.parse_args()

    all_issues: List[Dict[str, str]] = []
    for file_path in iter_files(args.paths):
        all_issues.extend(scan_file(file_path))

    print(json.dumps({"issues": all_issues}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

"""
Builds the database from the SQL files, runs every analysis query and
exports each result to reports/<name>.csv (ready for Excel or Power BI).

Run from the project root:
    python scripts/run_reports.py
"""

import csv
import os
import re
import sqlite3

DB_PATH = "clinic.db"
SQL_FILES = ["sql/01_schema.sql", "sql/02_seed_data.sql", "sql/03_views.sql"]
ANALYSIS_FILE = "sql/04_analysis.sql"
REPORT_DIR = "reports"


def build_database(conn):
    for path in SQL_FILES:
        with open(path, encoding="utf-8") as f:
            conn.executescript(f.read())


def load_queries(path):
    """Split the analysis file into {name: sql} using the '-- name:' markers."""
    with open(path, encoding="utf-8") as f:
        text = f.read()
    parts = re.split(r"^-- name:\s*(\w+)\s*$", text, flags=re.MULTILINE)
    # parts = [header, name1, sql1, name2, sql2, ...]
    return {parts[i]: parts[i + 1].strip() for i in range(1, len(parts), 2)}


def export(conn, name, sql):
    cursor = conn.execute(sql)
    headers = [col[0] for col in cursor.description]
    rows = cursor.fetchall()

    with open(os.path.join(REPORT_DIR, f"{name}.csv"), "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(headers)
        writer.writerows(rows)
    return headers, rows


def main():
    os.makedirs(REPORT_DIR, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    build_database(conn)

    for name, sql in load_queries(ANALYSIS_FILE).items():
        headers, rows = export(conn, name, sql)
        print(f"\n== {name} ({len(rows)} rows) ==")
        print(" | ".join(headers))
        for row in rows[:6]:
            print(" | ".join(str(v) for v in row))

    conn.close()
    print(f"\nCSV files written to {REPORT_DIR}/")


if __name__ == "__main__":
    main()

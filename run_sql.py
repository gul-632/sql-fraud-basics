import os
import duckdb

# always work from the folder this script is in
script_folder = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_folder)

con = duckdb.connect()
os.makedirs("results", exist_ok=True)


def run_sql_file(file_path, title, first_query_no):
    """Run every query in a SQL file, print it and save it as results/qNN.csv."""
    with open(file_path, "r") as file:
        text = file.read()

    print(f"\n{title}")
    query_no = first_query_no

    for statement in text.split(";"):
        # skip chunks that contain only comments or blank lines
        code_lines = [
            line for line in statement.splitlines()
            if line.strip() and not line.strip().startswith("--")
        ]
        if not code_lines:
            continue

        result = con.execute(statement).df()
        result.to_csv(f"results/q{query_no:02d}.csv", index=False)
        print(f"\nQuery {query_no} ({len(result)} rows) saved to results/q{query_no:02d}.csv")
        print(result)
        query_no += 1


# Step 1: Load tables
with open("sql/00_load.sql", "r") as file:
    load_sql = file.read()

con.execute(load_sql)
print("Tables loaded successfully!")

# Step 2: Run analysis files (the number is the first question in each file)
run_sql_file("sql/01_basics.sql", "Basic Analysis Results", 1)
run_sql_file("sql/02_joins.sql", "Joins Query Results", 9)
run_sql_file("sql/03_windows.sql", "Window Functions Results", 13)

con.close()
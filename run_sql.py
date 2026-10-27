
import duckdb

con = duckdb.connect()

def run_sql_file(file_path, title):
    with open(file_path, "r") as file:
        sql = file.read()

    result = con.execute(sql).df()

    print(f"\n{title}")
    print(result)

# Step 1: Load tables
with open("sql/00_load.sql", "r") as file:
    load_sql = file.read()

con.execute(load_sql)
print("Tables loaded successfully!")

# Step 2: Run analysis files
run_sql_file("sql/01_basics.sql", "Basic Analysis Results")
run_sql_file("sql/02_joins.sql", "Joins Query Results")

con.close()

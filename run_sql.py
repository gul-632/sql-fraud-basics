
import duckdb

con = duckdb.connect()

with open("sql/00_load.sql", "r") as file:
    con.execute(file.read())

print(con.sql("SHOW TABLES").df())

con.close()


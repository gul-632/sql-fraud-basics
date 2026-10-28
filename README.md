# Fraud Transaction Explorer

I answered 15 questions about 590,540 credit card transactions using only SQL (DuckDB). The goal: find out where fraud happens most, by product, card type, amount, email domain, device and time.

## Dataset

IEEE-CIS Fraud Detection (Kaggle). Two files are used:

- `train_transaction.csv`: one row per card transaction
- `train_identity.csv`: device and identity data for some transactions

The data is not included in this repository. Download it from Kaggle and put both files in the `data/` folder.

Sanity check: 590,540 transactions, of which 20,663 are fraud (3.5%). Query 1 reproduces these numbers.

Fraud rate = fraud cases / transactions x 100, calculated for each group in the question.

## Tools

- DuckDB (SQL engine, runs locally, no server needed)
- Python (only to run the SQL files through the `duckdb` package)
- Git and GitHub

## Folder structure

```
data/        raw CSV files (not committed)
sql/         SQL files (load script + queries 1 to 15)
results/     one CSV per query (q01.csv to q15.csv)
docs/        findings.md (five findings, one page)
run_sql.py   loads the data and runs all SQL files
```

## How to rerun everything

1. Install the packages (pandas is only needed so DuckDB can print results as tables):
   ```
   pip install duckdb pandas
   ```
2. Download the two CSV files from Kaggle into `data/`.
3. From the project folder, run:
   ```
   python run_sql.py
   ```

The script loads both tables (`sql/00_load.sql`), then runs the query files in order, prints each result and saves it as a CSV in `results/`.

## What each SQL file covers

| File | Questions | Techniques |
|---|---|---|
| `00_load.sql` | Load data | `read_csv_auto`, keep only needed columns |
| `01_basics.sql` | 1 to 8 | COUNT, SUM, AVG, GROUP BY, CASE WHEN, HAVING, LIMIT |
| `02_joins.sql` | 9 to 12 | LEFT JOIN, JOIN, CTE with a window average |
| `03_windows.sql` | 13 to 15 | CTE, window frame, RANK, PARTITION BY, NTILE |

## Top 5 results

| # | Question | Result |
|---|---|---|
| 1 | Q15: What share of fraud falls in each amount decile? | The cheapest 10% of transactions hold 16.08% of all fraud, more than the most expensive 10% (14.54%) |
| 2 | Q9: Does identity data change the fraud rate? | 7.85% with identity data vs 2.09% without |
| 3 | Q3: Fraud rate by card network and debit or credit | Visa credit 6.81% vs Visa debit 2.55% |
| 4 | Q10: Fraud rate by device type | Mobile 10.17% vs desktop 6.52% |
| 5 | Q13: 7-day moving fraud rate | Rose from 2.19% (day 1) to 4.21% (day 182) |

Full write-up with numbers: [docs/findings.md](docs/findings.md)

## Note on time

`TransactionDT` is a time offset in seconds from an unknown start date, not a real timestamp. I divide it by 86,400 to get a **day number**. All time results use day numbers, never calendar dates.

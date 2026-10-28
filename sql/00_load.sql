
CREATE OR REPLACE TABLE transactions AS
SELECT TransactionID,isFraud,TransactionDT, TransactionAmt, ProductCD,
       card1, card4, card6, addr1, P_emaildomain, R_emaildomain
FROM read_csv_auto('data/train_transaction.csv');


CREATE OR REPLACE TABLE identity AS
SELECT TransactionID, DeviceType, DeviceInfo
FROM  read_csv_auto('data/train_identity.csv');




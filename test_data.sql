USE pf_test;

DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS balances;

CREATE TABLE accounts (
	acct_id INTEGER AUTO_INCREMENT PRIMARY KEY,
  acct_name VARCHAR(50),
  carry_balance BOOLEAN,
  balance FLOAT(14),
  rate FLOAT(14),
  min_floor FLOAT(14),
  min_rate FLOAT(14),
  amount DECIMAL,
  weekly BOOLEAN,
  week_period INTEGER,
  week_offset INTEGER,
  day INTEGER
);

LOAD DATA LOCAL INFILE 'test_data.csv'
  REPLACE
  INTO TABLE accounts
  COLUMNS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

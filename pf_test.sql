DROP SCHEMA IF EXISTS pf_test;

CREATE SCHEMA pf_test;
USE pf_test;

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


CREATE TABLE payers (
	payer_id INTEGER,
    payer_name VARCHAR(50),
    balance FLOAT(14),
    today DATE,
    burn FLOAT(14)
);

CREATE TABLE results (
	result_id INTEGER
);

INSERT INTO payers VALUES (
	0, 
    "Payer1",
    2000,
    "2016-1-1",
    60
);

INSERT INTO payers VALUES (
	1, 
    "Payer2",
    2000,
    "2016-1-1",
    60
);

INSERT INTO payers VALUES (
	2, 
    "Payer3",
    2000,
    "2016-1-1",
    60
);
INSERT INTO accounts VALUES (
	1,
    "Paycheck1",
    FALSE,
    0,
    0,
    0,
    0,
    -2800,
    TRUE,
    2,
    0,
    5);
INSERT INTO accounts VALUES (
    2,
    "CC",
    TRUE,
    -1200.0,
    0.28,
    0,
    -0.02,
    0,
    FALSE,
    0,
    0,
    16);
INSERT INTO accounts VALUES (
    3,
    "Car",
    TRUE,
    -5500,
    0.06,
    300,
    0,
    0,
    FALSE,
    0,
    0,
    4);
-- Copyright 2004-2020 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (https://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

CREATE TABLE TEST(A INT, B INT);
> ok

INSERT INTO TEST VALUES ROW (1, 2), (3, 4), ROW (5, 6);
> update count: 3

INSERT INTO TEST(a) VALUES 7;
> update count: 1

INSERT INTO TEST(a) VALUES 8, 9;
> update count: 2

TABLE TEST;
> A B
> - ----
> 1 2
> 3 4
> 5 6
> 7 null
> 8 null
> 9 null
> rows: 6

DROP TABLE TEST;
> ok

CREATE TABLE TEST(ID INT);
> ok

-- TODO Do we need ROWID support here?
INSERT INTO TEST(ROWID, ID) VALUES (2, 3);
> update count: 1

SELECT ROWID, ID FROM TEST;
> ROWID ID
> ------- --
> 2       3
> rows: 1

DROP TABLE TEST;
> ok

CREATE TABLE TEST(A INT, B INT DEFAULT 5);
> ok

INSERT INTO TEST VALUES (1, DEFAULT);
> update count: 1

INSERT INTO TEST SET A = 2, B = DEFAULT;
> update count: 1

TABLE TEST;
> A B
> - -
> 1 5
> 2 5
> rows: 2

DROP TABLE TEST;
> ok

CREATE TABLE TEST(A INT, B INT GENERATED ALWAYS AS (A + 1));
> ok

INSERT INTO TEST VALUES (1, 1);
> exception GENERATED_COLUMN_CANNOT_BE_ASSIGNED_1

INSERT INTO TEST(B) VALUES 1;
> exception GENERATED_COLUMN_CANNOT_BE_ASSIGNED_1

INSERT INTO TEST VALUES (1, DEFAULT);
> update count: 1

INSERT INTO TEST DEFAULT VALUES;
> update count: 1

TABLE TEST;
> A    B
> ---- ----
> 1    2
> null null
> rows: 2

DROP TABLE TEST;
> ok

CREATE TABLE TEST(ID NUMERIC(20) GENERATED BY DEFAULT AS IDENTITY, V INT);
> ok

INSERT INTO TEST VALUES (12345678901234567890, 1);
> update count: 1

TABLE TEST;
> ID                   V
> -------------------- -
> 12345678901234567890 1
> rows: 1

DROP TABLE TEST;
> ok

CREATE TABLE TEST(ID BIGINT GENERATED BY DEFAULT AS IDENTITY, V INT);
> ok

INSERT INTO TEST VALUES (10, 20);
> update count: 1

INSERT INTO TEST OVERRIDING USER VALUE VALUES (20, 30);
> update count: 1

INSERT INTO TEST OVERRIDING SYSTEM VALUE VALUES (30, 40);
> update count: 1

TABLE TEST;
> ID V
> -- --
> 1  30
> 10 20
> 30 40
> rows: 3

DROP TABLE TEST;
> ok

CREATE TABLE TEST(ID BIGINT GENERATED ALWAYS AS IDENTITY, V INT);
> ok

INSERT INTO TEST VALUES (10, 20);
> exception GENERATED_COLUMN_CANNOT_BE_ASSIGNED_1

INSERT INTO TEST OVERRIDING USER VALUE VALUES (20, 30);
> update count: 1

INSERT INTO TEST OVERRIDING SYSTEM VALUE VALUES (30, 40);
> update count: 1

TABLE TEST;
> ID V
> -- --
> 1  30
> 30 40
> rows: 2

DROP TABLE TEST;
> ok

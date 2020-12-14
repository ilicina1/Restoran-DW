USE MASTER;
IF DB_ID('restoranDWH') IS NOT NULL 
	DROP DATABASE restoranDWH;
GO
CREATE DATABASE restoranDWH
	ON PRIMARY 
	(NAME = N'restoranDWH', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\restoranDWH.mdf', 
	SIZE = 307200KB , FILEGROWTH = 10240KB)
	LOG ON
	(NAME = N'restoranDWH_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\restoranDWH_log.ldf',
	SIZE = 51200KB, FILEGROWTH = 10%);
GO
ALTER DATABASE restoranDWH SET RECOVERY SIMPLE WITH NO_WAIT;
GO
USE restoranDWH;
GO
CREATE TABLE DimEmployee (
  dw_employee_id INT CHECK (dw_employee_id > 0) NOT NULL PRIMARY KEY IDENTITY(1,1),
  employee_id INT CHECK (employee_id > 0) NOT NULL,
  first_name VARCHAR(45) DEFAULT NULL,
  last_name VARCHAR(45) DEFAULT NULL,
  hire_date DATETIME DEFAULT GETDATE() NOT NULL,
  address_e VARCHAR(45) DEFAULT NULL,
  manager_id INT  DEFAULT NULL,
  job_title VARCHAR(45) DEFAULT NULL
  )
;

GO

CREATE TABLE DimReservations (
  dw_reservation_id INT CHECK (dw_reservation_id > 0) NOT NULL PRIMARY KEY IDENTITY(1,1),
  date_r DATE DEFAULT NULL
  )
;

GO

CREATE TABLE FactUsage (
  dw_fact_id INT CHECK (dw_fact_id > 0) NOT NULL PRIMARY KEY IDENTITY(1,1),
  dw_employee_id INT CHECK (dw_employee_id > 0) NULL REFERENCES DimEmployee(dw_employee_id),
  dw_customer_id INT CHECK (dw_customer_id > 0) NULL REFERENCES DimCustomer(dw_customer_id),
  dw_table_id INT CHECK (dw_table_id > 0) NULL REFERENCES DimTable(dw_table_id),
  dw_reservation_id INT CHECK (dw_reservation_id > 0) NULL REFERENCES DimReservations(dw_reservation_id),
  total_used INT CHECK(total_employees >= 0) DEFAULT 0,
  )
;

GO

CREATE TABLE DimTable (
  dw_table_id INT CHECK (dw_table_id > 0) NOT NULL PRIMARY KEY IDENTITY(1,1),
  availability_r VARCHAR(45) DEFAULT NULL,
  number_of_seats INT CHECK(number_of_seats >= 0) DEFAULT 0
  )
;

GO

CREATE TABLE DimCustomer (
  dw_customer_id INT CHECK (dw_customer_id > 0) NOT NULL PRIMARY KEY IDENTITY(1,1)
  )
;

GO

CREATE TABLE DimMenu(
  dw_menu_id INT CHECK (dw_menu_id > 0) NOT NULL PRIMARY KEY IDENTITY(1,1),
  item_name VARCHAR(25) NOT NULL,
  price DECIMAL(8,2) DEFAULT NULL,
  menu_col VARCHAR(45) DEFAULT NULL,
  )
;

GO

CREATE TABLE FactMaintenance(
  dw_factmaintenance_id INT CHECK (dw_factmaintenance_id > 0) NOT NULL PRIMARY KEY IDENTITY(1,1),
  costs DECIMAL CHECK (costs > 0) NOT NULL IDENTITY(1,1),
  maintenance INT DEFAULT NULL,
  dw_employee_id INT CHECK (dw_employee_id > 0) NULL REFERENCES DimEmployee(dw_employee_id),
  dw_menu_id INT CHECK (dw_menu_id > 0) NULL REFERENCES DimMenu(dw_menu_id),
  dw_reservation_id INT CHECK (dw_reservation_id > 0) NULL REFERENCES DimReservations(dw_reservation_id),
  dw_table_id INT CHECK (dw_table_id > 0) NULL REFERENCES DimTable(dw_table_id)
  )
;

GO

CREATE TABLE DimOrders(
  dw_order_id INT NOT NULL CHECK (dw_order_id > 0) PRIMARY KEY,
  quantity INT DEFAULT NULL,
  total_prices DECIMAL DEFAULT NULL
  )
;

CREATE TABLE DimTime(
  dw_time_id INT NOT NULL CHECK (dw_time_id > 0) PRIMARY KEY,
  full_date Date DEFAULT NULL,
  timeD DATETIME DEFAULT NULL
  )
;


GO

CREATE TABLE FactSales(
  dw_fact_id INT CHECK (dw_fact_id > 0) NOT NULL PRIMARY KEY IDENTITY(1,1),
  total_earnings DECIMAL DEFAULT NULL
  dw_order_id INT CHECK (dw_order_id > 0) NOT NULL REFERENCES DimOrders (dw_order_id),
  dw_customer_id INT CHECK (dw_customer_id > 0) NOT NULL REFERENCES DimCustomer (dw_customer_id),
  dw_table_id INT CHECK (dw_table_id > 0) NOT NULL REFERENCES DimTable (dw_table_id),
  dw_time_id INT CHECK (dw_time_id > 0) NOT NULL REFERENCES DimTime (dw_time_id),
  )
;

GO
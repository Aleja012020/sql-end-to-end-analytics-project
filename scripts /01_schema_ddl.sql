/*
===========================================================
DATABASE SETUP & SCHEMA DEFINITION (DDL)
===========================================================

PURPOSE:
This script initializes the project database and defines the 
core schema structure using Data Definition Language (DDL).

It represents the foundational layer of the project, where 
all tables are created based on the raw input data structure.

-----------------------------------------------------------
WHAT THIS SCRIPT DOES:
1. Drops the database if it already exists (to ensure a clean setup).
2. Creates the 'logistics_operations' database
3. Defines all tables corresponding to the raw CSV datasets
4. Prepares the schema for downstream processes such as:
   - Data Cleaning
   - Data Transformation
   - Exploratory Data Analysis (EDA)
   
-----------------------------------------------------------
⚠️ WARNING:
- This script will permanently DELETE the database 
  'logistics_operations' if it already exists.
- All stored data will be lost.
		
Make sure to have proper backups before executing this script.

===========================================================
*/

-- =========================================================
-- DATABASE CREATION
-- =========================================================
DROP DATABASE IF EXISTS logistics_operations;

CREATE DATABASE logistics_operations;

USE logistics_operations;

-- NOTE:
-- Tables are designed to mirror the structure of the raw CSV files.
-- Any necessary data type corrections (e.g., date conversions) will be handled in the data cleaning stage.

/* =========================================================
-- TABLE: customers
-- DESCRIPTION:
-- Stores core customer information, including segmentation,
   contract details, and revenue potential.
========================================================= */
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_type VARCHAR(50),
    credit_terms_days INT,
    primary_freight_type VARCHAR(50),
    account_status VARCHAR(30),
    contract_start_date DATE,
    annual_revenue_potential DECIMAL(15,2)
    );
    
 /* =========================================================
-- TABLE: delivery_events
-- DESCRIPTION:
-- Captures operational events related to pickups and deliveries,
   including scheduled vs actual timestamps and service performance.
========================================================= */   
DROP TABLE IF EXISTS delivery_events;

CREATE TABLE delivery_events (
    event_id VARCHAR(20) PRIMARY KEY,
    load_id VARCHAR(20),
    trip_id VARCHAR(20),
    event_type VARCHAR(20),
    facility_id VARCHAR(20),
    scheduled_datetime DATETIME,
    actual_datetime DATETIME,
    detention_minutes INT,
    on_time_flag VARCHAR(10),
    location_city VARCHAR(50),
    location_state CHAR(2)
);

 /* =========================================================
-- TABLE: driver_monthly_metrics
-- DESCRIPTION:
-- Aggregated monthly performance metrics for drivers,
   including productivity, fuel efficiency, and service quality.
========================================================= */  
DROP TABLE IF EXISTS driver_monthly_metrics;

CREATE TABLE driver_monthly_metrics (
    driver_id VARCHAR(20),
    month DATE,
    trips_completed INT,
    total_miles INT,
    total_revenue DECIMAL(12,2),
    average_mpg DECIMAL(5,2),
    total_fuel_gallons DECIMAL(10,1),
    on_time_delivery_rate DECIMAL(5,3),
    average_idle_hours DECIMAL(5,1)
);

 /* =========================================================
-- TABLE: drivers
-- DESCRIPTION:
-- Contains driver-level demographic and employment information.
-- Note: Some date fields are initially stored as strings and
   will be standardized during the data cleaning phase.
========================================================= */  
DROP TABLE IF EXISTS drivers;

CREATE TABLE drivers(
    driver_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    hire_date VARCHAR(20),
    termination_date VARCHAR(20),
    license_number VARCHAR(30),
    license_state CHAR(2),
    date_of_birth VARCHAR(20),
    home_terminal VARCHAR(50),
    employment_status VARCHAR(20),
    cdl_class CHAR(5),
    years_experience INT
);

 /* =========================================================
-- TABLE: facilities
-- DESCRIPTION:
-- Stores information about logistics facilities such as terminals,
   warehouses, and distribution centers.
========================================================= */  
DROP TABLE IF EXISTS facilities;

CREATE TABLE facilities (
    facility_id VARCHAR(20) PRIMARY KEY,
    facility_name VARCHAR(100),
    facility_type VARCHAR(50),
    city VARCHAR(50),
    state CHAR(2),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    dock_doors INT,
    operating_hours VARCHAR(20)
);

 /* =========================================================
-- TABLE: fuel_purchases
-- DESCRIPTION:
-- Records fuel transactions associated with trips, trucks, and drivers,
   enabling fuel cost and efficiency analysis.
========================================================= */  
DROP TABLE IF EXISTS fuel_purchases;

CREATE TABLE fuel_purchases (
    fuel_purchase_id VARCHAR(20) PRIMARY KEY,
    trip_id VARCHAR(20),
    truck_id VARCHAR(20),
    driver_id VARCHAR(20),
    purchase_date VARCHAR(20),
    location_city VARCHAR(50),
    location_state CHAR(2),
    gallons DECIMAL(10,1),
    price_per_gallon DECIMAL(6,3),
    total_cost DECIMAL(10,2),
    fuel_card_number VARCHAR(20)
);

 /* =========================================================
-- TABLE: loads
-- DESCRIPTION:
-- Represents shipment-level data, including revenue components,
   shipment characteristics, and booking details.
========================================================= */ 
DROP TABLE IF EXISTS loads;

CREATE TABLE loads (
    load_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    route_id VARCHAR(20),
    load_date VARCHAR(20),
    load_type VARCHAR(30),
    weight_lbs INT,
    pieces INT,
    revenue DECIMAL(10,2),
    fuel_surcharge DECIMAL(10,2),
    accessorial_charges DECIMAL(10,2),
    load_status VARCHAR(20),
    booking_type VARCHAR(20)
);

 /* =========================================================
-- TABLE: maintenance_records
-- DESCRIPTION:
-- Tracks maintenance activities for trucks, including costs,
   labor, downtime, and service details.
========================================================= */ 
DROP TABLE IF EXISTS maintenance_records;

CREATE TABLE maintenance_records(
    maintenance_id VARCHAR(20) PRIMARY KEY,
    truck_id VARCHAR(20),
    maintenance_date DATE,
    maintenance_type VARCHAR(30),
    odometer_reading INT,
    labor_hours DECIMAL(5,1),
    labor_cost DECIMAL(10,2),
    parts_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    facility_location VARCHAR(50),
    downtime_hours DECIMAL(5,1),
    service_description VARCHAR(100)
);

 /* =========================================================
-- TABLE: routes
-- DESCRIPTION:
-- Defines standard routes between origin and destination locations,
   including distance, pricing, and expected transit time.
========================================================= */ 
DROP TABLE IF EXISTS routes;

CREATE TABLE routes (
    route_id VARCHAR(20) PRIMARY KEY,
    origin_city VARCHAR(50),
    origin_state CHAR(2),
    destination_city VARCHAR(50),
    destination_state CHAR(2),
    typical_distance_miles INT,
    base_rate_per_mile DECIMAL(6,2),
    fuel_surcharge_rate DECIMAL(5,2),
    typical_transit_days INT
);

 /* =========================================================
-- TABLE: safety_incidents
-- DESCRIPTION:
-- Stores records of operational and safety incidents,
   including financial impact and responsibility indicators.
========================================================= */ 
DROP TABLE IF EXISTS safety_incidents;

CREATE TABLE safety_incidents (
    incident_id VARCHAR(20) PRIMARY KEY,
    trip_id VARCHAR(20),
    truck_id VARCHAR(20),
    driver_id VARCHAR(20),
    incident_date VARCHAR(20),
    incident_type VARCHAR(50),
    location_city VARCHAR(50),
    location_state CHAR(5),
    at_fault_flag VARCHAR(10),
    injury_flag VARCHAR(10),
    vehicle_damage_cost DECIMAL(12,2),
    cargo_damage_cost DECIMAL(12,2),
    claim_amount DECIMAL(12,2),
    preventable_flag VARCHAR(10),
    incident_description VARCHAR(300)
);

 /* =========================================================
-- TABLE: trailers
-- DESCRIPTION:
-- Contains information about trailers, including specifications,
   status, and current location.
========================================================= */ 
DROP TABLE IF EXISTS trailers;

CREATE TABLE trailers (
    trailer_id VARCHAR(20) PRIMARY KEY,
    trailer_number INT,
    trailer_type VARCHAR(30),
    length_feet INT,
    model_year INT,
    vin VARCHAR(30),
    acquisition_date DATE,
    trailer_status VARCHAR(20),
    current_location VARCHAR(50)
);

 /* =========================================================
-- TABLE: trips
-- DESCRIPTION:
-- Central fact table capturing trip execution data,
   linking loads, drivers, trucks, and trailers with
   operational performance metrics.
========================================================= */ 
DROP TABLE IF EXISTS trips;

CREATE TABLE trips (
    trip_id VARCHAR(20) PRIMARY KEY,
    load_id VARCHAR(20),
    driver_id VARCHAR(20),
    truck_id VARCHAR(20),
    trailer_id VARCHAR(20),
    dispatch_date DATE,
    actual_distance_miles INT,
    actual_duration_hours DECIMAL(6,1),
    fuel_gallons_used DECIMAL(8,1),
    average_mpg DECIMAL(5,2),
    idle_time_hours DECIMAL(5,1),
    trip_status VARCHAR(20)
);

 /* =========================================================
-- TABLE: truck_utilization_metrics
-- DESCRIPTION:
-- Monthly aggregated performance metrics for trucks,
   including utilization, revenue, and maintenance impact.
========================================================= */ 
DROP TABLE IF EXISTS truck_utilization_metrics;

CREATE TABLE truck_utilization_metrics(
    truck_id VARCHAR(20),
    month DATE,
    trips_completed INT,
    total_miles INT,
    total_revenue DECIMAL(12,2),
    average_mpg DECIMAL(5,2),
    maintenance_events INT,
    maintenance_cost DECIMAL(12,2),
    downtime_hours DECIMAL(6,1),
    utilization_rate DECIMAL(5,3)
);

 /* =========================================================
-- TABLE: trucks
-- DESCRIPTION:
-- Stores core information about trucks, including specifications,
   fuel capacity, and operational status.
========================================================= */ 
DROP TABLE IF EXISTS trucks;

CREATE TABLE trucks (
    truck_id VARCHAR(20) PRIMARY KEY,
    unit_number INT,
    make VARCHAR(50),
    model_year INT,
    vin VARCHAR(30),
    acquisition_date DATE,
    acquisition_mileage INT,
    fuel_type VARCHAR(20),
    tank_capacity_gallons INT,
    status VARCHAR(20),
    home_terminal VARCHAR(50)
);

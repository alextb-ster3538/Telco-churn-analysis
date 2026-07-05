-- Database: telco_practice

-- DROP DATABASE IF EXISTS telco_practice;

CREATE DATABASE telco_practice
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

--Double-check white spaces
SELECT customerid, totalcharges
FROM telco_raw
WHERE TRIM(totalcharges) = '';

--Create a clean table
CREATE TABLE clean_telco AS
SELECT
    customerid,
    gender,
    seniorcitizen,
    partner,
    dependents,
    tenure,
    phoneservice,
    multiplelines,
    internetservice,
    onlinesecurity,
    onlinebackup,
    deviceprotection,
    techsupport,
    streamingtv,
    streamingmovies,
    contract,
    paperlessbilling,
    paymentmethod,
    monthlycharges::numeric AS monthlycharges,
    NULLIF(TRIM(totalcharges), '')::numeric AS totalcharges,
    churn
FROM telco_raw;

--Count rows in newly created table
SELECT COUNT(*) FROM clean_telco;

-- Check if there are still whitepaces in new table
SELECT COUNT(*) 
FROM clean_telco
WHERE totalcharges IS NULL;

--Profiling the 11 rows

SELECT
    totalcharges,
    LENGTH(totalcharges) AS len,
    ENCODE(totalcharges::bytea, 'escape') AS byte_view
FROM telco_raw
WHERE LENGTH(TRIM(totalcharges)) = 0;

--
CREATE TABLE clean_telco AS
SELECT
    customerid,
    gender,
    seniorcitizen,
    partner,
    dependents,
    tenure,
    phoneservice,
    multiplelines,
    internetservice,
    onlinesecurity,
    onlinebackup,
    deviceprotection,
    techsupport,
    streamingtv,
    streamingmovies,
    contract,
    paperlessbilling,
    paymentmethod,
    monthlycharges::numeric AS monthlycharges,
    NULLIF(TRIM(totalcharges), '')::numeric AS totalcharges,
    churn
FROM telco_raw;

--
SELECT *
FROM clean_telco
WHERE totalcharges IS NULL;

--Double checking the null values 
SELECT customerid, tenure, monthlycharges, totalcharges
FROM clean_telco
WHERE totalcharges IS NULL;

-- Calculate Overall Churn Rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM clean_telco;

-- Calculate Churn by Contract Type
SELECT 
    contract,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM clean_telco
GROUP BY contract
ORDER BY churn_rate DESC;

-- 
SELECT 
    CASE 
        WHEN tenure BETWEEN 0 AND 6 THEN '0-6 months'
        WHEN tenure BETWEEN 7 AND 12 THEN '7-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        ELSE '49+ months'
    END AS tenure_group,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM clean_telco
GROUP BY tenure_group
ORDER BY churn_rate DESC;

-- Calculate Churn by Internet Service
SELECT 
    internetservice,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM clean_telco
GROUP BY internetservice
ORDER BY churn_rate DESC;


-- Calculate churn by Monthly Charges (binned)
SELECT 
    CASE 
        WHEN monthlycharges < 30 THEN '<30'
        WHEN monthlycharges BETWEEN 30 AND 60 THEN '30-60'
        WHEN monthlycharges BETWEEN 60 AND 90 THEN '60-90'
        ELSE '>90'
    END AS charge_group,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM clean_telco
GROUP BY charge_group
ORDER BY charge_group;

-- Calculate churn by Payment Method
SELECT 
    paymentmethod,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM clean_telco
GROUP BY paymentmethod
ORDER BY churn_rate DESC;


-- Calculate churn by Senior Citizen
SELECT 
    seniorcitizen,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM clean_telco
GROUP BY seniorcitizen;


-- Calculate churn by tech support 
SELECT 
    techsupport,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM clean_telco
GROUP BY techsupport
ORDER BY churn_rate DESC;


--Create the gold table
CREATE TABLE telco_gold AS
SELECT
    -- Core identifiers
    customerid,
    gender,
    seniorcitizen,
    partner,
    dependents,
    tenure,
    phoneservice,
    multiplelines,
    internetservice,
    onlinesecurity,
    onlinebackup,
    deviceprotection,
    techsupport,
    streamingtv,
    streamingmovies,
    contract,
    paperlessbilling,
    paymentmethod,
    monthlycharges,
    totalcharges,
    churn,

    /* ---------------------------
       FEATURE ENGINEERING
       --------------------------- */

    -- 1. Tenure buckets
    CASE 
        WHEN tenure BETWEEN 0 AND 6 THEN '0-6 months'
        WHEN tenure BETWEEN 7 AND 12 THEN '7-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        ELSE '49+ months'
    END AS tenure_group,

    -- 2. Monthly charge buckets
    CASE 
        WHEN monthlycharges < 30 THEN '<30'
        WHEN monthlycharges BETWEEN 30 AND 60 THEN '30-60'
        WHEN monthlycharges BETWEEN 60 AND 90 THEN '60-90'
        ELSE '>90'
    END AS charge_group,

    -- 3. Boolean flags
    (seniorcitizen = 1) AS is_senior,
    (multiplelines = 'Yes') AS has_multiple_lines,
    (contract IN ('One year', 'Two year')) AS is_long_term_contract,
    (paymentmethod ILIKE '%automatic%') AS is_autopay,

    -- 4. Revenue metrics
    monthlycharges * tenure AS lifetime_revenue_estimate,
    CASE 
        WHEN tenure = 0 THEN monthlycharges
        ELSE totalcharges / NULLIF(tenure, 0)
    END AS avg_monthly_revenue,

    -- 5. Churn flag as boolean
    (churn = 'Yes') AS churn_flag

FROM clean_telco;

--Validate the telco_gold table
SELECT 
    COUNT(*) AS rows,
    COUNT(*) FILTER (WHERE churn_flag) AS churned,
    ROUND(100.0 * COUNT(*) FILTER (WHERE churn_flag) / COUNT(*), 2) AS churn_rate
FROM telco_gold;

-- 

SELECT tenure_group, COUNT(*) FROM telco_gold GROUP BY tenure_group ORDER BY 1;
SELECT charge_group, COUNT(*) FROM telco_gold GROUP BY charge_group ORDER BY 1;
SELECT is_autopay, COUNT(*) FROM telco_gold GROUP BY is_autopay;

-- Advanced EDA 
--Calculate churn rate by contract and tenure 
SELECT 
    contract,
    tenure_group,
    ROUND(100.0 * AVG(churn_flag::int), 2) AS churn_rate
FROM telco_gold
GROUP BY contract, tenure_group
ORDER BY contract, tenure_group;

-- Price sensitivity (monthly churn rate x churn)
SELECT 
    charge_group,
    ROUND(100.0 * AVG(churn_flag::int), 2) AS churn_rate,
    COUNT(*) AS customers
FROM telco_gold
GROUP BY charge_group
ORDER BY charge_group;

-- Churn rate by autopay/non-autopay
SELECT 
    is_autopay,
    ROUND(100.0 * AVG(churn_flag::int), 2) AS churn_rate,
    COUNT(*) AS customers
FROM telco_gold
GROUP BY is_autopay
ORDER BY is_autopay;

-- Calculate churn rate by internet service type and whether tech support was received or not

SELECT 
    internetservice,
    techsupport,
    ROUND(100.0 * AVG(churn_flag::int), 2) AS churn_rate,
    COUNT(*) AS customers
FROM telco_gold
GROUP BY internetservice, techsupport
ORDER BY internetservice, techsupport;

-- Calculate the churn rate based on internet service type and whether the customer is a senior or not

SELECT 
    is_senior,
    internetservice,
    ROUND(100.0 * AVG(churn_flag::int), 2) AS churn_rate,
    COUNT(*) AS customers
FROM telco_gold
GROUP BY is_senior, internetservice
ORDER BY is_senior, internetservice;

-- Lifetime Revenue at Risk (Business‑Critical Insight)
SELECT 
    tenure_group,
    ROUND(AVG(lifetime_revenue_estimate), 2) AS avg_lifetime_revenue,
    ROUND(100.0 * AVG(churn_flag::int), 2) AS churn_rate,
    ROUND(AVG(lifetime_revenue_estimate) * AVG(churn_flag::int), 2) AS revenue_at_risk
FROM telco_gold
GROUP BY tenure_group
ORDER BY revenue_at_risk DESC;

-- Pull modelling data from telco_gold excluding the NULL values from totalcharges column
--Resulted in 4032 rows(11 rows contain NULL values)
SELECT
    customerid,
    gender,
    seniorcitizen,
    partner,
    dependents,
    tenure,
    phoneservice,
    multiplelines,
    internetservice,
    onlinesecurity,
    onlinebackup,
    deviceprotection,
    techsupport,
    streamingtv,
    streamingmovies,
    contract,
    paperlessbilling,
    paymentmethod,
    monthlycharges,
    totalcharges,
    is_senior,
    has_multiple_lines,
    is_long_term_contract,
    is_autopay,
    lifetime_revenue_estimate,
    avg_monthly_revenue,
    churn_flag
FROM telco_gold
WHERE totalcharges IS NOT NULL;

--

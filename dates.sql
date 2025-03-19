SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS posted_date
FROM job_postings_fact

-- converting time zone
SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM job_postings_fact


-- extracting month out from date
SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS post_date,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact

-- DATE_TRUNC() round off 
-- return value is likewise of type timestamp, 
-- it has all fields that are less significant than the selected one set to zero (or one, for day and month).
SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS post_date,
    DATE_TRUNC('MONTH', job_posted_date) AS month
FROM job_postings_fact

-- DATE_PART() and EXTRACT() both retrieve specific parts of a date or interval.
-- DATE_PART() is more dynamic because it works well with interval-based functions like AGE().
-- AGE() is use to find the difference between 2 timeframe, can work only with timestamp.
-- EXTRACT() is more rigid and is primarily used to extract date parts from date/timestamp values.
-- EXTRACT() is more commonly used for simple date extractions, while DATE_PART() is better for numeric comparisons and calculations.
SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS post_date,
    -- Extracting the difference in months between the job posted date and the current date
    DATE_PART('month', AGE(NOW(), job_posted_date)) AS time_duration_months,

    -- Extracting the difference in years
    DATE_PART('year', AGE(NOW(), job_posted_date)) AS time_duration_years,

    -- Calculating the total difference in months, including converted years
    (DATE_PART('year', AGE(NOW(), job_posted_date)) * 12) + DATE_PART('month', AGE(NOW(), job_posted_date)) AS total_months
FROM job_postings_fact;


-- AGE() is used to calculate the difference between two timestamps or dates.
-- It returns the result as an INTERVAL type (e.g., '1 year 2 months 10 days').
-- AGE() can work with both TIMESTAMP and DATE types, not just TIMESTAMP.
-- It automatically handles leap years, month lengths, and day differences correctly.
SELECT AGE(NOW(), '2000-05-20'::TIMESTAMP) AS person_age;

-- TO_CHAR() converts datetime to timestamp and can be change to custom formatting.
SELECT TO_CHAR('2025-03-15'::DATE, 'Month DD, YYYY') AS formatted_date;




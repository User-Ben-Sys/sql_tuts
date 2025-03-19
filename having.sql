/* 
1. Must be used with GROUP BY when filtering aggregate results.
2. Cannot be used without GROUP BY unless an aggregate function is present.
3. Works only with aggregate functions (SUM, COUNT, AVG, MAX, MIN).
4. Filters grouped results after they are calculated, unlike WHERE which filters rows before aggregation.
*/
-------------------------------------------
SELECT job_title_short, COUNT(*) AS job_count
FROM job_postings_fact
GROUP BY job_title_short
HAVING COUNT(*) > 1000;  -- ✅ Filters only job titles that have more than 100 job postings

-- Explanation of HAVING:
-- ✅ HAVING is used to filter results AFTER aggregation (SUM, COUNT, AVG, etc.).
-- ✅ It is similar to WHERE, but WHERE cannot be used with aggregate functions.
-- ✅ HAVING must be used after GROUP BY when filtering grouped results.
-- ✅ COUNT(*) > 100 means only job titles with more than 100 postings are shown.


-------------------------------------------
SELECT company_id, AVG(salary_year_avg) AS average_salary
FROM job_postings_fact
GROUP BY company_id
HAVING AVG(salary_year_avg) > 100000;  -- ✅ Only includes companies with avg salary > 100K

-- ✅ HAVING filters out companies where avg salary is below 100,000.
-- ✅ This would not be possible with WHERE because SUM() is an aggregate function.


-------------------------------------------
SELECT job_location, ROUND(AVG(salary_year_avg),2) AS avg_salary
FROM job_postings_fact
WHERE salary_year_avg > 50000  -- ✅ Filters jobs with salaries above 50K BEFORE aggregation
GROUP BY job_location
HAVING AVG(salary_year_avg) > 80000;  -- ✅ Only show locations where the avg salary is above 80K

-- ✅ WHERE filters individual rows before aggregation.
-- ✅ HAVING filters grouped results after aggregation.


-------------------------------------------
SELECT SUM(salary_year_avg) AS total_salary
FROM job_postings_fact
HAVING SUM(salary_year_avg) > 1000000;  -- ✅ Works because HAVING applies to an aggregate function

-- ✅ HAVING can be used without GROUP BY if there is only one row in the result.
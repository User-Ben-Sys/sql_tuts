-- ✅ This query checks whether (salary_year_avg, salary_hour_avg) is greater than (100000, 50) using row comparison.
-- ✅ It returns a TRUE or FALSE value for each row.
SELECT
    job_location,
    ROW (salary_year_avg,salary_hour_avg) > ROW (100000, 50)
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL;

/* 🔹 How This Works
1. ROW (salary_year_avg, salary_hour_avg) creates a tuple (row).
2. ROW (100000, 50) is another tuple used for comparison.
3. The > operator compares tuples element-wise:
4. First, salary_year_avg is compared to 100000.
5. If equal, salary_hour_avg is compared to 50.
----------------------------------------
✔ ROW() is used for tuple (multi-column) comparisons.
✔ SQL compares tuple values element-by-element (like sorting logic).
✔ Can simplify WHERE conditions that compare multiple values.
*/
----------------------------------------

/* 🔹 Moving Average with FOLLOWING
✅ Groups by job_location.
✅ Orders by salary_year_avg within each location.
✅ Takes the average of:
The current row.
The next 2 rows. */

SELECT 
    job_location,
    job_title_short,
    salary_year_avg,
    AVG(salary_year_avg) OVER (
        PARTITION BY job_location 
        ORDER BY salary_year_avg 
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
    ) AS moving_avg
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL;

/* 🔹 Centered Moving Average (PRECEDING + FOLLOWING)
Orders by salary_year_avg.
✅ Averages over:
1 row before (1 PRECEDING).
The current row.
1 row after (1 FOLLOWING). */

SELECT 
    job_title_short,
    salary_year_avg,
    AVG(salary_year_avg) OVER (
        ORDER BY salary_year_avg 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS centered_moving_avg
FROM job_postings_fact;


----------------------------------------
SELECT 
    company_id,
    job_title_short AS job_title,
    EXTRACT(YEAR FROM job_posted_date) AS year,
    EXTRACT(MONTH FROM job_posted_date) AS month,
    salary_year_avg,

    -- Moving average: Includes 1 month before, current month, and 1 month after
    AVG(salary_year_avg) OVER (
        PARTITION BY EXTRACT(YEAR FROM job_posted_date), EXTRACT(MONTH FROM job_posted_date) 
        ORDER BY job_posted_date DESC
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
    ) AS moving_avg_salary

FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY year, month;




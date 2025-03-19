/* Rules for Using OVER (PARTITION BY ...)
1. PARTITION BY creates separate "groups" within the dataset, similar to GROUP BY.
2. It does NOT collapse rows like GROUP BY, keeping all original data visible.
3. Can be used with aggregate functions (SUM, COUNT, AVG) and ranking functions (ROW_NUMBER, RANK, DENSE_RANK).
4. Must be used with an OVER() clause.
5. Can include ORDER BY inside OVER() to control ranking order.

----------------------------------------
Rules for Using OVER (PARTITION BY ...)

🔹 GROUP BY - Aggregates Data into Fewer Rows
✅ Used to group rows and apply aggregate functions like SUM(), COUNT(), AVG(), etc.
✅ Collapses multiple rows into a single row per group.
✅ Every column in SELECT must be either:
- Part of GROUP BY
- Used in an aggregate function.
----------------------------------------

🔹 PARTITION BY - Groups Data Without Collapsing Rows
✅ Used inside OVER() in window functions (SUM(), COUNT(), RANK(), etc.).
✅ Does NOT collapse rows—instead, it groups data but keeps all rows visible.
✅ Applies aggregate functions across partitions but preserves individual row details.
*/


SELECT 
    job_title_short,
    job_location,
    COUNT(*) OVER (PARTITION BY job_location) AS job_count_per_location
FROM job_postings_fact
GROUP BY 1,2;


-- ✅ SUM(salary_year_avg) calculates the total salary per company.
-- ✅ PARTITION BY company_id ensures that the sum is calculated separately for each company.
-- ✅ Unlike GROUP BY, each row retains its original data but includes the total salary for its company.
SELECT 
    co.name AS company_name,
    pos.job_title_short,
    pos.salary_year_avg,
    SUM(pos.salary_year_avg) OVER (PARTITION BY pos.company_id) AS total_salary_per_company
FROM job_postings_fact AS pos
    JOIN company_dim AS co
    USING(company_id)
WHERE pos.salary_year_avg IS NOT NULL;


-- ✅ ROW_NUMBER() assigns a unique ranking number to each row within each job location.
-- ✅ PARTITION BY job_location ensures ranking is done separately for each location.
-- ✅ ORDER BY salary_year_avg DESC ranks jobs within each location by highest salary first.
-- ✅ If two jobs have the same salary, they receive different ranks (1, 2, 3...).
SELECT 
    job_title_short,
    job_location,
    salary_year_avg,
    ROW_NUMBER() OVER (PARTITION BY job_location ORDER BY salary_year_avg DESC) AS salary_rank
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL;


-- ✅ RANK() assigns a ranking number but skips numbers if there are ties.
-- ✅ DENSE_RANK() assigns rankings without skipping numbers for ties.
-- ✅ PARTITION BY job_location ranks salaries separately for each location.
-- ✅ ORDER BY salary_year_avg DESC ensures highest salaries get the top rank.
SELECT 
    job_title_short,
    job_location,
    salary_year_avg,
    RANK() OVER (PARTITION BY job_location ORDER BY salary_year_avg DESC) AS salary_rank,
    DENSE_RANK() OVER (PARTITION BY job_location ORDER BY salary_year_avg DESC) AS dense_salary_rank
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL;


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
-- A subquery is a nested SQL query used inside another SQL query.
-- It can be placed in SELECT, FROM, WHERE, or HAVING clauses.
-- Subqueries allow retrieving data from another table without using a JOIN.
-- The inner query executes first, passing results to the outer query.
-- In this example, the subquery retrieves company IDs where job postings do not require a degree.

-- Subquery in WHERE
-- Use WHERE when filtering based on another table.
SELECT
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN(
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = TRUE
);

-- Subquery in SELECT
-- Use SELECT to compute derived values dynamically.
SELECT 
    company_id,
    name AS company_name,(
        SELECT COUNT(*) 
        FROM job_postings_fact AS po
        WHERE po.company_id = co.company_id) AS job_count
FROM company_dim AS co;


-- Subquery in FROM
-- Use FROM to create temporary tables.
SELECT company_id, total_jobs
FROM (
    -- Subquery creates a temporary table with company job counts
    SELECT company_id, COUNT(*) AS total_jobs
    FROM job_postings_fact
    GROUP BY company_id
) AS job_summary
WHERE total_jobs > 10;

-- Subquery in HAVING
-- Use HAVING to filter aggregated results dynamically.
SELECT company_id, COUNT(*) AS job_count
FROM job_postings_fact
GROUP BY company_id
HAVING COUNT(*) > (
    -- Subquery finds the average number of job postings per company
    SELECT AVG(job_count)
    FROM (
        SELECT company_id, COUNT(*) AS job_count
        FROM job_postings_fact
        GROUP BY company_id
    ) AS avg_jobs
);



SELECT 100000 > 
    ANY (
        -- Subquery: Retrieves all salary averages for 'Data Analyst' roles
        SELECT salary_year_avg
        FROM job_postings_fact
        WHERE job_title_short = 'Data Analyst'
    );

-- Explanation:
-- ✅ This is a subquery because it contains a nested SELECT statement.
-- ✅ The subquery retrieves a list of salary averages for 'Data Analyst' jobs.
-- ✅ The ANY operator checks if 100000 is greater than AT LEAST ONE salary from the subquery.
-- ✅ If ANY salary in the subquery result is lower than 100000, the whole condition returns TRUE.
-- ✅ If ALL salaries are greater than 100000, the condition returns FALSE.
-- ✅ This query is mainly used as a CHECKING mechanism (returns TRUE or FALSE).



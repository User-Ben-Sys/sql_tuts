-- ✅ UNION vs UNION ALL: Understanding the Difference
-- ---------------------------------------------------

-- ✅ UNION: Combines results from two queries and removes duplicates.
-- ✅ UNION ALL: Combines results from two queries and keeps duplicates.

SELECT
    job_title_short,
    company_id,
    job_location
FROM jan_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM feb_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM mar_jobs

---------------------------------------------------
SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
    SELECT *
    FROM jan_jobs   
    UNION All
    SELECT *
    FROM feb_jobs
    UNION ALL
    SELECT *
    FROM mar_jobs
) AS quarterly_job_postings
WHERE salary_year_avg > 70000 
    AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC
WITH company_job_count AS (
    SELECT company_id,
    COUNT(*) AS total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
    JOIN company_job_count
    USING (company_id)
ORDER BY total_jobs DESC

/* 
Subquery (skill_count):
Counts how many times each skill_id appears in skills_job_dim (i.e., how often the skill is required in job postings).
Groups by skill_id to get total occurrences.
Orders by total_skills_count (most mentioned skills first).
Limits the result to the top 5 skills.

Main Query:
Joins skills_dim (which contains skill names) with the subquery results.
Uses ON sd.skill_id = skill_count.skill_id to match skill IDs from both tables.
Orders the final output by total_skills_count DESC (most frequently mentioned skills first).
*/

SELECT 
    sd.skill_id,
    sd.skills,
    skill_count.total_skills_count
FROM skills_dim AS sd
JOIN (
    -- Subquery: Get the top 5 most mentioned skill IDs
    SELECT skill_id, COUNT(*) AS total_skills_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY total_skills_count DESC
    LIMIT 5
) AS skill_count
ON sd.skill_id = skill_count.skill_id
ORDER BY skill_count.total_skills_count DESC;
---------------------------------------------

-- Using CTE as alternative solution
WITH remote_skills AS (
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings
    USING(job_id)
WHERE job_postings.job_work_from_home = True
GROUP BY skill_id
)

SELECT
    skill_id,
    skills,
    skill_count
FROM remote_skills
INNER JOIN skills_dim
    USING (skill_id)
LIMIT 5;


---------------------------------------------
WITH company_job_count AS (
    SELECT company_id,
    COUNT(*) AS total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs,
    CASE
        WHEN total_jobs < 10 THEN 'small'
        WHEN total_jobs BETWEEN 10 AND 50 THEN 'medium'
        ELSE 'large'
    END AS job_size_category
FROM company_dim
JOIN company_job_count 
    ON company_dim.company_id = company_job_count.company_id 
ORDER BY total_jobs DESC;
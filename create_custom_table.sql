CREATE TABLE jan_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE feb_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE mar_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;
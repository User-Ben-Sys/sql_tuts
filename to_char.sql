SELECT 
    -- Formatting a date to "Month DD, YYYY" format (e.g., "March 15, 2024")
    TO_CHAR('2024-03-15'::date, 'Month DD, YYYY') AS formatted_date,

    -- Formatting a date to "YYYY-MM-DD" format (e.g., "2024-03-15")
    TO_CHAR('2024-03-15'::date, 'YYYY-MM-DD') AS iso_date,

    -- Formatting a timestamp to include time (e.g., "2024-03-15 14:30:00")
    TO_CHAR(NOW(), 'YYYY-MM-DD HH24:MI:SS') AS timestamp_format,

    -- Formatting time in 12-hour format with AM/PM (e.g., "02:30 PM")
    TO_CHAR(NOW(), 'HH12:MI AM') AS time_12hr_format,

    -- Formatting numbers with commas and decimal places (e.g., "1,234,567.89")
    TO_CHAR(1234567.89, '999,999,999.99') AS formatted_number,

    -- Formatting numbers with currency symbol (e.g., "$1,234,567.89")
    TO_CHAR(1234567.89, 'FM$999,999,999.00') AS formatted_currency,

    -- Formatting a percentage (e.g., "75.00%")
    TO_CHAR(0.75, 'FM999.00%') AS formatted_percentage;

CREATE TABLE credit_risk (
    person_age INTEGER,
    person_income INTEGER,
    person_home_ownership TEXT,
    person_emp_length NUMERIC,
    loan_intent TEXT,
    loan_grade TEXT,
    loan_amnt INTEGER,
    loan_int_rate NUMERIC,
    loan_status INTEGER,
    loan_percent_income NUMERIC,
    cb_person_default_on_file TEXT,
    cb_person_cred_hist_length INTEGER
);

SELECT *
FROM credit_risk 
LIMIT 10

SELECT COUNT(*)
FROM credit_risk
WHERE loan_status = 1;

SELECT
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS defaulted_loans,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_pct
SELECT
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS defaulted_loans,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_pct
FROM credit_risk;

SELECT
    loan_grade,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS defaults,
    ROUND(100.0 * AVG(loan_status), 2) AS default_rate_pct
FROM credit_risk
GROUP BY loan_grade
ORDER BY loan_grade;

-- 3. Default según grado crediticio
SELECT
    loan_grade,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_status) * 100, 2) AS default_rate_pct
FROM credit_risk
GROUP BY loan_grade
ORDER BY loan_grade;


-- 4. Default según antecedentes de default
SELECT
    cb_person_default_on_file,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_status) * 100, 2) AS default_rate_pct
FROM credit_risk
GROUP BY cb_person_default_on_file;


-- 5. Default según finalidad del préstamo
SELECT
    loan_intent,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_status) * 100, 2) AS default_rate_pct
FROM credit_risk
GROUP BY loan_intent
ORDER BY default_rate_pct DESC;


-- 6. Default según situación de vivienda
SELECT
    person_home_ownership,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_status) * 100, 2) AS default_rate_pct
FROM credit_risk
GROUP BY person_home_ownership
ORDER BY default_rate_pct DESC;


-- 7. Perfil financiero según default
SELECT
    loan_status,
    ROUND(AVG(person_income), 2) AS avg_income,
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate,
    ROUND(AVG(loan_percent_income), 3) AS avg_loan_income_ratio
FROM credit_risk
GROUP BY loan_status
ORDER BY loan_status;

WITH risk_segments AS (
    SELECT
        *,
        CASE
            WHEN loan_percent_income < 0.20 THEN 'Low exposure'
            WHEN loan_percent_income < 0.40 THEN 'Medium exposure'
            ELSE 'High exposure'
        END AS exposure_segment
    FROM credit_risk
)

SELECT
    exposure_segment,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_status) * 100, 2) AS default_rate_pct,
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate
FROM risk_segments
GROUP BY exposure_segment
ORDER BY default_rate_pct DESC;
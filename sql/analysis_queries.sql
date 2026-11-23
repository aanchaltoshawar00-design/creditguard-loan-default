-- CreditGuard: default-rate queries (SQLite)

-- 1. KPIs
SELECT COUNT(*) AS total_loans,
       ROUND(AVG(loan_amnt), 0) AS avg_loan_amount,
       ROUND(100.0 * SUM(is_default) / COUNT(*), 2) AS default_rate_pct
FROM loan_info;

-- 2. Default rate by income bracket (JOIN)
SELECT a.income_bracket, COUNT(*) AS total_loans,
       ROUND(100.0 * SUM(l.is_default) / COUNT(*), 2) AS default_rate_pct
FROM loan_info l
JOIN applicant_info a ON l.applicant_id = a.applicant_id
GROUP BY a.income_bracket
ORDER BY default_rate_pct DESC;

-- 3. Default rate by loan purpose
SELECT purpose, COUNT(*) AS total_loans,
       ROUND(100.0 * SUM(is_default) / COUNT(*), 2) AS default_rate_pct
FROM loan_info
GROUP BY purpose
ORDER BY default_rate_pct DESC;

-- 4. Default rate by credit score band (JOIN)
SELECT CASE WHEN a.fico_avg < 680 THEN '1. Below 680'
            WHEN a.fico_avg < 700 THEN '2. 680-699'
            WHEN a.fico_avg < 720 THEN '3. 700-719'
            WHEN a.fico_avg < 740 THEN '4. 720-739'
            ELSE '5. 740+' END AS fico_band,
       COUNT(*) AS total_loans,
       ROUND(100.0 * SUM(l.is_default) / COUNT(*), 2) AS default_rate_pct
FROM loan_info l
JOIN applicant_info a ON l.applicant_id = a.applicant_id
GROUP BY fico_band
ORDER BY fico_band;

-- 5. Default rate by state (JOIN, states with 1000+ loans)
SELECT a.addr_state AS state, COUNT(*) AS total_loans,
       ROUND(100.0 * SUM(l.is_default) / COUNT(*), 2) AS default_rate_pct
FROM loan_info l
JOIN applicant_info a ON l.applicant_id = a.applicant_id
GROUP BY a.addr_state
HAVING COUNT(*) >= 1000
ORDER BY default_rate_pct DESC;
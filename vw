CREATE OR REPLACE VIEW reporting.mv_factgprdetails_paydate AS
SELECT
    -- Existing columns from fact and header
    fact.pay_year,
    fact.pay_period,
    hdr.p3306_ims_fund_1,
    hdr.p3306_ims_fund_2,
    hdr.p3306_station,
    hdr.p3306_visn,
    hdr.p3306_cost_center,
    detail.p3306_gross_recon_cd,
    detail.p3306_pay_period_end_dt,
    fact.p3306_hours_paid,
    fact.p3306_earn_emp_cont_coll_amt,
    fact.hashvalue,
    fact.gpracctgsid,
    -- New columns from test_rule_periods (enhancements)
    TO_DATE(rp.PD_START_DT, 'YYYY-MM-DD') AS "Paid Start Date",
    TO_DATE(rp.PD_END_DT, 'YYYY-MM-DD') AS "Paid End Date",
    -- Casting to avoid the error
    CAST(TO_CHAR(TO_DATE(rp.PD_START_DT, 'YYYY-MM-DD'), 'YYYYMMDD') AS INTEGER) AS "PayCalendarDateKey"
FROM
    "hed-dev-db".datawarehouse.test_factgprdetails fact
JOIN
    "hcd-dev-db".datawarehouse.test_dimgpracctg hdr
    ON hdr.gpracctgsid = fact.gpracctgsid
JOIN
    "hcd-dev-db".datawarehouse.test_dimgprdetails detail
    ON detail.gprdetailssid = fact.gprdetailssid
-- New Join with datawarehouse.test_rule_periods
JOIN
    datawarehouse.test_rule_periods rp
    ON fact.pay_year = rp.PD_YEAR
    AND fact.pay_period = rp.PD_PERIOD;


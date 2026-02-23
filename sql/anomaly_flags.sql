-- 02_anomaly_flags.sql
-- Add fraud-specific anomaly rules

CREATE TABLE flagged_transactions AS
SELECT
    *,
    
    -- Outgoing balance mismatch
    CASE 
        WHEN oldbalanceOrg - amount != newbalanceOrg
        THEN 1 ELSE 0
    END AS is_balance_mismatch_org,

    -- Incoming balance mismatch
    CASE 
        WHEN oldbalanceDest + amount != newbalanceDest
        THEN 1 ELSE 0
    END AS is_balance_mismatch_dest,

    -- Zero-change behavior (synthetic or failed accounting)
    CASE WHEN oldbalanceOrg = newbalanceOrg THEN 1 ELSE 0 END AS is_zero_change_sender,
    CASE WHEN oldbalanceDest = newbalanceDest THEN 1 ELSE 0 END AS is_zero_change_receiver,

    -- Overdraft anomaly
    CASE 
        WHEN amount > oldbalanceOrg THEN 1 ELSE 0
    END AS is_overdraft_anomaly

FROM cleaned_transactions;
-- 03_feature_engineering.sql
-- Generate SQL-side engineered features

CREATE TABLE engineered_transactions AS
SELECT
    step, 
    type, 
    amount, 
    nameOrig,
    oldbalanceOrg, 
    newbalanceOrg,
    nameDest, 
    oldbalanceDest, 
    newbalanceDest,
    isFraud, 
    isFlaggedFraud,

    is_missing_value,
    is_invalid_amount,
    is_negative_balance,

    is_balance_mismatch_org,
    is_balance_mismatch_dest,
    is_zero_change_sender,
    is_zero_change_receiver,
    is_overdraft_anomaly,

    -- Log-transformed amount
    CASE WHEN amount > 0 THEN LOG(amount) ELSE NULL END AS log_amount,

    -- High-risk transaction types
    CASE WHEN type IN ('CASH_OUT', 'TRANSFER') THEN 1 ELSE 0 END AS is_high_risk_type,

    -- Round amounts (common in fraud structuring)
    CASE WHEN amount % 1000 = 0 THEN 1 ELSE 0 END AS is_round_amount

FROM flagged_transactions;
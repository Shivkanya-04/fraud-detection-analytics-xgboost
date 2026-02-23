CREATE TABLE cleaned_transactions AS
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

    -- Missing value check
    CASE
        WHEN amount IS NULL 
          OR type IS NULL
          OR oldbalanceOrg IS NULL
          OR newbalanceOrg IS NULL
          OR oldbalanceDest IS NULL
          OR newbalanceDest IS NULL
        THEN 1 ELSE 0
    END AS is_missing_value,


    CASE WHEN amount <= 0 THEN 1 ELSE 0 END AS is_invalid_amount,

  
    CASE 
        WHEN oldbalanceOrg < 0 OR newbalanceOrg < 0
          OR oldbalanceDest < 0 OR newbalanceDest < 0
        THEN 1 ELSE 0
    END AS is_negative_balance

FROM raw_transactions;
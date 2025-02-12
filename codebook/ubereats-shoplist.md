# Codebook for `ubereats-shoplist-demo.csv`

## Path

<https://drive.google.com/drive/folders/13tbKAuPidoB0ilxeYTdacNQZ5BBl7VXP>

## Columns

1. **storeUuid**
   - **Type**: String
   - **Meaning**: Unique identifier for the store.

2. **name**
   - **Type**: String
   - **Meaning**: Name of the store.

3. **latitude**
   - **Type**: Numeric
   - **Meaning**: Latitude coordinate of the store's location.

4. **longitude**
   - **Type**: Numeric
   - **Meaning**: Longitude coordinate of the store's location.

5. **anchor_latitude**
   - **Type**: Numeric
   - **Meaning**: Latitude coordinate of the anchor point for the store.

6. **anchor_longitude**
   - **Type**: Numeric
   - **Meaning**: Longitude coordinate of the anchor point for the store.

7. **score_breakdown**
   - **Type**: String (Base64 encoded JSON)
   - **Meaning**: Encoded JSON string containing detailed scores for various aspects of the store's performance.

8. **score_total**
   - **Type**: Numeric
   - **Meaning**: Total score for the store.

9. **rating**
   - **Type**: Numeric
   - **Meaning**: Overall rating of the store.

10. **orderable**
    - **Type**: Boolean
    - **Meaning**: Indicates whether the store is currently orderable (TRUE or FALSE).

11. **date**
    - **Type**: Date
    - **Meaning**: Date of the record.

## Example of `score_breakdown` JSON Structure

The `score_breakdown` field contains a Base64 encoded JSON string. After decoding, it might look like this:

```json
{
  "ConversionRatePredictionScore": 0.0073532164096832275,
  "ConversionRateScoreCoefficient": 0.856,
  "FinalScore": 0.009473917812108993,
  "NetInflowPredictionScore": 13.220384330672758,
  "NetInflowScoreCoefficient": 0,
  "PredictionScore": 0.009473917812108993,
  "ServiceQualityPredictionScore": 0.9680878520011902,
  "ServiceQualityScoreCoefficient": 0,
  "UCBanditPredictionScore": 0.049009521143766686,
  "UCBanditScoreCoefficient": 0,
  "conversion_rate_boosting_factor": 0.856,
  "conversion_rate_partial_score": 0.0073532164096832275,
  "ctr_boosting_factor": 0.089,
  "ctr_partial_score": 0.03572544455528259,
  "net_inflow_boosting_factor": 0,
  "net_inflow_partial_score": 13.220384330672758,
  "service_quality_boosting_factor": 0,
  "service_quality_partial_score": 0.9680878520011902,
  "t120d_eyeball_count": 43934,
  "t120d_request_count": 3133,
  "ucb_bandit_boosting_factor": 0,
  "ucb_bandit_partial_score": 0.049009521143766686
}
```
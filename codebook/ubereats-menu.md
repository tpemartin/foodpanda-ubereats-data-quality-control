
## path

<https://drive.google.com/drive/folders/1o6_OQTgfe3746PW7StHhc-OIQDrVXzD0>

# Codebook for `ubereats-menu-demo.csv`

## Columns

1. **shopCode**
   - **Type**: String
   - **Meaning**: Unique identifier for the shop.

2. **localtion**
   - **Type**: String (JSON array)
   - **Meaning**: Latitude and longitude coordinates of the shop's location.

3. **updateDate**
   - **Type**: Date
   - **Meaning**: Date when the menu was last updated.

4. **shopName**
   - **Type**: String
   - **Meaning**: Name of the shop.

5. **address**
   - **Type**: String
   - **Meaning**: Address of the shop.

6. **postalCode**
   - **Type**: Numeric
   - **Meaning**: Postal code of the shop's location.

7. **shopLat**
   - **Type**: Numeric
   - **Meaning**: Latitude coordinate of the shop's location.

8. **shopLng**
   - **Type**: Numeric
   - **Meaning**: Longitude coordinate of the shop's location.

9. **city**
   - **Type**: String
   - **Meaning**: City where the shop is located.

10. **pickupTime**
    - **Type**: String
    - **Meaning**: Estimated pickup time for orders.

11. **deliverFee**
    - **Type**: Numeric
    - **Meaning**: Delivery fee for orders.

12. **rate**
    - **Type**: Numeric
    - **Meaning**: Overall rating of the shop.

13. **rateCt**
    - **Type**: Numeric
    - **Meaning**: Number of ratings received by the shop.

14. **storeAvailabilityStatus**
    - **Type**: Numeric
    - **Meaning**: Availability status of the shop.

15. **catLst**
    - **Type**: String (Base64 encoded JSON)
    - **Meaning**: Encoded JSON string containing categories of items available in the shop.

16. **chain**
    - **Type**: String (Base64 encoded JSON)
    - **Meaning**: Encoded JSON string containing information about the chain to which the shop belongs.

17. **menu**
    - **Type**: String (Base64 encoded JSON)
    - **Meaning**: Encoded JSON string containing the menu items available in the shop.

## Example of `catLst`, `chain`, and `menu` JSON Structure

The `catLst`, `chain`, and `menu` fields contain Base64 encoded JSON strings. After decoding, they might look like this:

### `catLst` Example

```json
["$", "漢堡"]
```

### `chain` Example

```json
{
  "uuid": "d3e1175b-f55e-42de-a0ba-0d39e50735dc",
  "name": "parent-漢堡"
}
```

### `menu` Example

```json
{
  "uuid": [
    "a9935294-70e8-4043-8d0e-668c5dde34ad",
    "acaf0a25-9ba0-4a59-b02e-52d59753051c",
    "b730c11c-ab05-43aa-bcd6-3b564fc8aacd",
    "81e7845c-37f0-4e9d-aeab-c958c4ca7cc6"
  ],
  "product": [
    "漢堡",
    "漢堡",
    "漢堡",
    "漢堡"
  ],
  "description": [
    null, null, null, null
  ],
  "price": [
    180, 180, 180, 180
  ],
  "preDiscountPrice": [
    180, 180, 180, 180
  ],
  "isSoldOut": [
    false, false, false, false
  ],
  "accessibilityText": [
    "$180.00", "$180.00", "$180.00", "$180.00"
  ]
}
```

### Explanation of JSON Fields

  - catLst

    Type: Array of Strings
    Meaning: List of categories of items available in the shop.

  - chain

    Type: Object
    Fields:
    chainName: String - Name of the chain.

  - chainId: String - Unique identifier for the chain.
menu

    Type: Object
    Fields:
    uuid: Array of Strings - List of unique identifiers for menu items.
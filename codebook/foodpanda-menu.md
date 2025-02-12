Codebook for foodpanda-menu-demo.csv

1. shopCode
   - Description: A unique code for the shop.
   - Example: ztkn

2. location
   - Description: The geographical coordinates of the shop.
   - Format: JSON array with latitude and longitude
   - Example: "[24.7838864630001,121.800643992]"

3. updateDate
   - Description: The date when the shop information was last updated.
   - Format: Date (MM/DD/YYYY)
   - Example: 10/15/2024

4. shopName
   - Description: The name of the shop.
   - Example: 三媽臭臭鍋 (礁溪龍潭店)

5. address
   - Description: The address of the shop.
   - Example: (△)宜蘭縣礁溪鄉龍潭路550號

6. postalCode
   - Description: The postal code of the shop's location.
   - Example: 262006

7. shopLat
   - Description: The latitude of the shop's location.
   - Format: Float
   - Example: 24.7820473

8. shopLng
   - Description: The longitude of the shop's location.
   - Format: Float
   - Example: 121.7452427

9. city
   - Description: The city where the shop is located.
   - Example: NaN (Not a Number, indicating missing data)

10. pickupTime
    - Description: The pickup time for orders.
    - Format: String (can be "null" indicating missing data)
    - Example: "null"

11. deliverFee
    - Description: The delivery fee.
    - Format: String
    - Example: "19"

12. rate
    - Description: The rating of the shop.
    - Format: Float
    - Example: 4.8

13. rateCt
    - Description: The rating count of the shop.
    - Format: Float
    - Example: 4.8

14. storeAvailabilityStatus
    - Description: The availability status of the store.
    - Example: NaN (Not a Number, indicating missing data)

15. catLst
    - Description: The list of categories for the shop.
    - Format: JSON array of objects, each containing 'id', 'name', 'url_key', and 'main' fields.
    - Example: "[{\"id\":248,\"name\":\"火鍋\",\"url_key\":\"tai-shi\",\"main\":true},{\"id\":1214,\"name\":\"臭臭鍋\",\"url_key\":\"huo-guo\",\"main\":false}]"

16. chain
    - Description: Information about the chain the shop belongs to.
    - Format: JSON object containing 'id', 'main_vendor_code', 'main_vendor_id', and 'is_shop_price'.
    - Example: "{\"id\":684,\"main_vendor_code\":\"a5sk\",\"main_vendor_id\":24466,\"is_shop_price\":true}"

17. menu
    - Description: The menu of the shop.
    - Format: JSON object (truncated in the example)
    - Example: "{\"id\":684,\"main_vendor_code\":\"a5sk\",\"main_vendor_id\":24466,\"is_shop_price\":true}"

Example of `menu` JSON Structure:  

```json
 [ {
    "id": 38102945,
    "productCode": "5b6c2f64-37a1-4c68-bbf2-a14d35756c56",
    "variationCode": "5000f8e0-cda8-4fd5-a666-ca3810b9a1fe",
    "product": "漢堡",
    "description": "漢堡描述",
    "price": 200,
    "isSoldOut": false
  },
  {
    "id": 38102948,
    "productCode": "5010ff9f-ccc6-4e9c-97e9-da6d568407c2",
    "variationCode": "76a11610-cfbc-46fc-9811-a5ac652ca9fd",
    "product": "飲料",
    "description": "飲料描述",
    "price": 200,
    "isSoldOut": false,
    "tags": ["popular"]
  }
  ]
  ```


18. is_shop_price
    - Description: Indicates if the shop price is available.
    - Format: Boolean
    - Example: true

19. is_delivery_enabled
    - Description: Indicates if delivery is enabled for the shop.
    - Format: Boolean
    - Example: true
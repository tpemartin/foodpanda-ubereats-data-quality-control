# Codebook for foodpanda-shoplist-demo.csv

1. shopName
   - Description: The name of the shop.
   - Example: 老先覺功夫窯燒鍋 (礁溪溫泉MiNi店)

2. shopCode
   - Description: A unique code for the shop.
   - Example: a8ql

3. budget
   - Description: The budget level of the shop.
   - Example: 3

4. category
   - Description: The categories of food offered by the shop.
   - Format: JSON array of strings
   - Example: "['火鍋', '台式']"

5. pandaOnly
   - Description: Indicates if the shop is exclusive to Panda.
   - Format: Boolean
   - Example: False

6. minFee
   - Description: The minimum delivery fee.
   - Format: Float
   - Example: 19.0

7. minOrder
   - Description: The minimum order amount.
   - Format: Float
   - Example: 79.0

8. minDelTime
   - Description: The minimum delivery time in minutes.
   - Format: Float
   - Example: 40.0

9. minPickTime
   - Description: The minimum pick-up time in minutes.
   - Format: Float
   - Example: 10.0

10. distance
    - Description: The distance to the shop in kilometers.
    - Format: Float
    - Example: 2.639

11. rateNum
    - Description: The number of ratings the shop has received.
    - Format: Integer
    - Example: 1528

12. address
    - Description: The address of the shop.
    - Example: (△) 宜蘭縣礁溪鄉溫泉路15號

13. chainCode
    - Description: The code for the chain the shop belongs to.
    - Example: apu3

14. city
    - Description: The city where the shop is located.
    - Example: Yilan County

15. latitude
    - Description: The latitude of the shop's location.
    - Format: Float
    - Example: 24.82733295

16. longitude
    - Description: The longitude of the shop's location.
    - Format: Float
    - Example: 121.77476675

17. anchor_latitude
    - Description: The anchor latitude for the shop.
    - Format: Float
    - Example: 24.8239212930001

18. anchor_longitude
    - Description: The anchor longitude for the shop.
    - Format: Float
    - Example: 121.800643992

19. hasServiceFee
    - Description: Indicates if the shop has a service fee.
    - Format: Boolean
    - Example: False

20. serviceFeeAmount(%)
    - Description: The service fee amount as a percentage.
    - Format: Integer
    - Example: 0

21. updateDate
    - Description: The date when the shop information was last updated.
    - Format: DateTime
    - Example: 2024-11-20 08:18:33

22. tags
    - Description: Tags associated with the shop.
    - Format: JSON array of objects, each containing 'code' and 'text' fields.
    - Example: "[{\"code\": \"FEAT\", \"text\": \"NEXTGEN_FEATURED_TAG\"}, {\"code\": \"DEAL\", \"text\": \"滿 $150 折 $30\"}]"
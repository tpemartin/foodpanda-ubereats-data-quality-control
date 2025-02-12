
# Codebook for popularItem

## Path

<https://drive.google.com/drive/folders/1H3sB8twBzofkCiwM1qzoHuH-utaDzaMC>

## Columns

1. title
   - Description: The name of the restaurant.
   - Example: 八方雲集 新店碧潭店

2. uuid
   - Description: A unique identifier for the restaurant.
   - Format: UUID
   - Example: af8efba1-63dc-42b8-a18d-121250edfd76

3. disclaimerBadge
   - Description: A disclaimer or badge information related to the restaurant.
   - Format: JSON string containing HTML content.
   - Example: {'text': '<span>[本店開立紙本發票] 本商家肉品原產地資訊標示於餐點描述中 (上開肉品資訊是由我們所合作之商家合作夥伴所提供。如對上開資訊有任何疑問，請直接與商家合作夥伴聯繫) (食品業者登錄字號：F-170472679-00454-8 / 公司名稱：碧潭八方雲集小吃店 / 統一編號：49936126)</span>'}

4. popular_uuid
   - Description: A list of popular item UUIDs for the restaurant.
   - Format: JSON array of UUIDs
   - Example: "['bf22015a-e04b-53fd-88d4-f702e8377cfe', '6c748e96-4e5d-5fef-9ce8-96a8a5392efa', '07d23f30-51c8-5422-88f2-6d17c85c4e68', 'b178eee7-4bd0-55b7-a9a6-0117764db1b2', '20156941-382a-47f7-9cf8-808327338f2b']"

5. opening_hours
   - Description: The opening hours of the restaurant.
   - Format: JSON array of objects, each containing '@type', 'dayOfWeek', and other relevant fields.
   - Example: "[{'@type': 'OpeningHoursSpecification', 'dayOfWeek': ['Monday', 'Tuesday', ...]}"##
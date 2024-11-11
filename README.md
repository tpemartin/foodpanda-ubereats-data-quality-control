# foodpanda-ubereats-data-quality-control
 
```
df_menu={"uuid":["5dbaa4bd-1ee1-472f-bb23-8a2a8d89834f","82398cf0-34a7-4af0-a173-1d6eccf5c3e5","8e7422b9-9228-40e3-a26d-b985143ea6c0","fda56806-5ee4-469d-8439-4c7055917ccc","79918080-2af8-488c-8952-cf32cc1f7a30","cfdf1549-5c3c-4b53-9830-91355d07079a","5efea84b-067e-4e86-9d76-a07982c205a2","9b93ff16-933a-4339-a772-eed76dc7b102","5561e4d3-a4d5-4604-9240-38341e670bbf","b08a1ff3-0f87-41fb-ba54-d1e98a3d1f56","7bd0b37b-333f-45b4-8084-2b6b001ccb39","174b0edf-be4c-4441-adb9-4f82d0c3d1a9","39ab33ea-1569-4f8a-9500-bc20e62de786","1205865a-6d8f-4dc1-a107-c9392d7fa6f3","5d648156-9834-4d88-be04-6fb0610f1170","a235a4ae-3986-4184-af15-8a38e149585e","36dae353-a22e-4cd2-bc84-dabe8194cdb3","84d1e4af-ccfb-46b0-b0fb-8e6ac5e7d499","2a05f72c-da0b-40df-9ecd-706910543df5","fd556f7c-d126-49de-ac8a-61dad9af5614","ff0a7337-eb46-46a9-92e3-a8d23ed0cb68","830951c4-9afa-4ec9-8b56-23ff0c07d354","5a237e2c-bf33-440d-9014-33c19670c63e","8663cc8b-493f-49a2-b320-297cfe7a0d85","a9461efe-4cb6-413b-8511-bc02af36e197","5ef61622-68fa-4d9e-9cc7-bb3f6c6c1109","e39cbbd9-d2bd-45a8-ba97-1a4e04909020","1a80edd9-2542-4a4b-9449-fe421550fb2d","1048b4a7-e50d-4777-b569-eeeb9d3066be","dcaa7ccc-f961-4866-9bcd-6c259b316937"],"product":["綜合海鮮義大利麵","煙燻培根義大利麵","香蒜中卷義大利麵","鮮蝦干貝義大利麵","嫩雞腿肉義大利麵","鮑魚干貝義大利麵","三陸總匯義大利麵","海陸總匯義大利麵","白酒蛤蜊義大利麵","德國香腸義大利麵","田園野菇義大利麵","雪花牛肉義大利麵","雪花豬肉義大利麵","鯛魚海鮮義大利麵","奶油玉米濃湯","南瓜玉米湯","番茄蔬菜湯","蛤蠣鮮湯","泡菜蔬菜湯","冬瓜茶","綠茶","紅茶","鮮奶綠茶","青茶","鮮奶烏龍","紅茶(小杯)","烏龍茶","鮮奶紅茶","鮮奶青茶","鮮奶冬瓜"],"description":[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,"700cc","700cc","700cc","700cc","700cc","700cc","390cc","700cc","700cc","700cc","700cc"],"price":[100,90,120,120,90,120,130,130,100,90,90,120,120,130,60,60,60,60,60,30,30,30,60,30,60,15,30,60,60,60],"preDiscountPirce":[100,90,120,120,90,120,130,130,100,90,90,120,120,130,60,60,60,60,60,30,30,30,60,30,60,15,30,60,60,60],"isSoldOut":[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false],"accessibilityText":["$100.00","$90.00","$120.00","$120.00","$90.00","$120.00","$130.00","$130.00","$100.00","$90.00","$90.00","$120.00","$120.00","$130.00","$60.00","$60.00","$60.00","$60.00","$60.00","$30.00","$30.00","$30.00","$60.00","$30.00","$60.00","$15.00","$30.00","$60.00","$60.00","$60.00"]}
```

create a function that can separate the object `df_menu` into to objects one with keys `uuid`, `product`, `price`, `preDiscountPirce`. The other is `uuid` and the remaining keys. The function should return an array of the two objects.


## prepare menu data

`ubereatsMenu` is an array of the following content (imported from a csv file):
```
[[shopCode, localtion, updateDate, shopName, address, postalCode, shopLat, shopLng, city, pickupTime, deliverFee, rate, rateCt, storeAvailabilityStatus, catLst, chain, menu], [4a338c1c-9789-5aa3-96de-e4cbc3342116, [25.2242695930001,121.480585432], 9/9/2024, 淡水美食街X義料工坊, 新北市淡水區興仁路131號 New Taipei, 淡水區 251 Taiwan, , NaN, 25.21871, 121.45153, , 20 到 35 分鐘, NaN, NaN, NaN, NaN, WyIkIiwi576p5aSn5Yip576O6aOfIl0=, ...], [...],[...]]
```
`ubereatsMenu[0]` is the header of the csv file. The header is as follows:
```
['shopCode', 'localtion', 'updateDate', 'shopName', 'address', 'postalCode', 'shopLat', 'shopLng', 'city', 'pickupTime', 'deliverFee', 'rate', 'rateCt', 'storeAvailabilityStatus', 'catLst', 'chain', 'menu']
```
We will augment two columns `menu1` and `menu2` from `menu` column, whose values in each one row should be obtained by the following steps:

  - feed the value of `menu` column of the row to `parseEncodedString` function, 
  - then feed the returned value to `separateMenu` function that will return an array of two strings. The two strings should be assigned to `menu1` and `menu2` columns respectively.



the returned value from feeding the `menu` column to the function created in the first task. The function should return an array of the two objects.\


For `separateMenu` function the output should be array of two objects. Each object should have all values as an array.


```
function testPrepareMenuSheetData() {
  var fileId = "12cDROEqMMN9T-VHG2jkC5zIPpEFXRg1F";
  var file = DriveApp.getFileById(fileId);
  file.setTrashed(false); // Ensure the file is not in trash

  var content = file.getBlob().getDataAsString();
  var ubereatsMenu = Utilities.parseCsv(content);
  Logger.log(ubereatsMenu)
  var augUbereatsMenu = augmentUbereatsMenu(ubereatsMenu)
  Logger.log(augUbereatsMenu[1]);
}
```

Modify the content so that `augUbereatsMenu` can be written to a sheet named "data" in the active spreadsheet.


`csvData` has headers row with a header named "menu". define augmentedUbereatsMenu function so that:
1. header "menu" will be removed and add "menu1" and "menu2" headers. 
2. For each observation's menu value (say `menuValue`), get its `parseEncodedString(menuValue)` as `parsedMenuValue`.
2.1. decode it to obtain 
function decomposeMenuListIntoTibble(oneListDfMenu) {
  var menu12 = separateMenu(oneListDfMenu);
  var menu12Json = menu12.map(function (x) {
    return JSON.stringify(x);
  });
  return {
    menu1: menu12Json[0],
    menu2: menu12Json[1]
  };
}


function prepareMenuSheetData(ubereatsMenu) {

  // Logger.log(ubereatsMenu)
  var menuColumn = getMenuColumn(ubereatsMenu);
  var listDfMenu = menuColumn.map(parseEncodedString);
  Logger.log(listDfMenu)
  var dfMenu12 = decomposeMenuListIntoTibble(listDfMenu[0]);

  Logger.log(dfMenu12)
  var dfMenu12List = listDfMenu.map(function (menu) {
    return decomposeMenuListIntoTibble(menu);
  });

  ubereatsMenu = Object.assign({}, ubereatsMenu, dfMenu12);
  delete ubereatsMenu.menu;
  return ubereatsMenu;
}

function testPrepareMenuSheetData() {
  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  var sheetName = "data";
  
  // Get or create the "data" sheet
  var sheet = spreadsheet.getSheetByName(sheetName);
  if (!sheet) {
    sheet = spreadsheet.insertSheet(sheetName); // Create the sheet if it doesn't exist
  } else {
    sheet.clear(); // Clear existing content
  }

  var fileId = "12cDROEqMMN9T-VHG2jkC5zIPpEFXRg1F";
  var file = DriveApp.getFileById(fileId);
  file.setTrashed(false); // Ensure the file is not in trash

  var content = file.getBlob().getDataAsString();
  var ubereatsMenu = Utilities.parseCsv(content);
  Logger.log(ubereatsMenu[1]);
  
  // var augUbereatsMenu = augmentUbereatsMenu(ubereatsMenu);
  // Logger.log(augUbereatsMenu);
  // Logger.log(augUbereatsMenu[0])
  // Logger.log(augUbereatsMenu[0].length)
  // Logger.log(augUbereatsMenu[1].length)
  // Write the augmented menu to the sheet
  // sheet.getRange(1, 1, augUbereatsMenu.length, augUbereatsMenu[0].length).setValues(augUbereatsMenu);
}

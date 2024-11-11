function importCsvParseMenu(fileId='12cDROEqMMN9T-VHG2jkC5zIPpEFXRg1F') {
  var csvData = importCsv(fileId);
  
  if (csvData.length === 0) {
    return csvData;
  }

  var headers = csvData[0];
  var menuIndex = headers.indexOf("menu");

  if (menuIndex !== -1) {
    headers.splice(menuIndex, 1);
  }

  headers.push("menu1", "menu2");

  var newCsvData = [headers];

  for (var i = 1; i < csvData.length; i++) {
    var row = csvData[i];
    var menu = row[menuIndex];
    row.splice(menuIndex, 1);
    // Logger.log(row)
    var parsedMenu = parseEncodedString(menu);
    // Logger.log(parsedMenu)
    try {
      var [menu1, menu2] = separateMenu(parsedMenu);
    } catch (error) {
      var menu1 = null;
      var menu2 = null;
    }
    row.push(menu1, menu2);
    newCsvData.push(row);
  }
  Logger.log(newCsvData)
  return newCsvData;
}
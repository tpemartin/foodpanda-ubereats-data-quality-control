function importCsv(fileId='12cDROEqMMN9T-VHG2jkC5zIPpEFXRg1F') {
  try {
    // Download the file
    var file = DriveApp.getFileById(fileId);
    var fileName = file.getName();
    var csvData = Utilities.parseCsv(file.getBlob().getDataAsString());

    // Check if csvData is an array and not empty
    if (!Array.isArray(csvData) || csvData.length === 0) {
      throw new Error("CSV data is not an array or it is empty.");
    }

    // var ubereats = augmentUbereatsMenu(csvData);

    // Logger.log(ubereats);
    Logger.log(csvData)

    // Logger.log(Object.keys(ubereats[0]))
    return csvData;
  } catch (error) {
    Logger.log(error.message);
    return [];
  }
}
function importCsvParseMenu(fileId='12cDROEqMMN9T-VHG2jkC5zIPpEFXRg1F') {
  var csvData = importCsv(fileId);
  
  if (csvData.length === 0) {
    return csvData;
  }

  var headers = csvData[0];
  headers.push("menu1", "menu2");

  var newCsvData = [headers];

  for (var i = 1; i < csvData.length; i++) {
    var row = csvData[i];
    var menu = row[headers.indexOf("menu")];
    var parsedMenu = parseEncodedString(menu);
    var [menu1, menu2] = separateMenu(parsedMenu);
    row.push(menu1, menu2);
    newCsvData.push(row);
  }

  return newCsvData;
}
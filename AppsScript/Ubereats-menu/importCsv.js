function importCsv(fileId='12cDROEqMMN9T-VHG2jkC5zIPpEFXRg1F') {
  try {
    // Download the file
    var file = DriveApp.getFileById(fileId);
    // var fileName = file.getName();
    var csvData = Utilities.parseCsv(file.getBlob().getDataAsString());

    // Check if csvData is an array and not empty
    if (!Array.isArray(csvData) || csvData.length === 0) {
      throw new Error("CSV data is not an array or it is empty.");
    }

    // var ubereats = augmentUbereatsMenu(csvData);

    // Logger.log(ubereats);
    // Logger.log(csvData)

    // Logger.log(Object.keys(ubereats[0]))
    return csvData;
  } catch (error) {
    Logger.log(error.message);
    return [];
  }
}

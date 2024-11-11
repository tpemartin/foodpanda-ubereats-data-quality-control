function getPropertyValue(propertyName="folderUrl") {
  // Get the active spreadsheet
  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  
  // Get the "meta" sheet
  var metaSheet = spreadsheet.getSheetByName("meta");
  
  // Get all the values in the "meta" sheet
  var data = metaSheet.getDataRange().getValues();
  
  // Loop through the rows to find the matching propertyName
  for (var i = 0; i < data.length; i++) {
    // Check if the value in column A matches the propertyName
    if (data[i][0] === propertyName) {
      // Return the value from column B if a match is found
      var returnValue = data[i][1];
      Logger.log(returnValue)
      return returnValue
    }
  }
  

  // If no match is found, return null or a message
  return null; // or you can return "Property not found"
}

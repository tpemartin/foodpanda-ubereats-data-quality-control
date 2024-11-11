
function concatenateDataFromIds(foldername="2024-9-8") {

  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var fileListSheet = ss.getSheetByName("files: "+foldername);
  // if(!fileListSheet) listFilesOfFolderName(foldername);
  var dataSheet = ss.getSheetByName(foldername);
  
  if (!dataSheet) {
    dataSheet = ss.insertSheet(foldername);
  } else {
    dataSheet.clear();
  }
  
  var idColumn = fileListSheet.getRange("B2:B" + fileListSheet.getLastRow()).getValues();
  var allData = [];
  var headersWritten = false;
  var headers;
  idColumn.forEach(function(row) {
    var id = row[0];
    
    // Logger.log(id)
    if (id) {
      var data = importCsv(id);
      
      if (data.length > 0) {
        if (!headersWritten) {
          headers = Object.keys(data[0]);
          // Logger.log(headers)
          allData.push(headers);
          headersWritten = true;
        }
        // Logger.log(JSON.stringify(data))
        // Logger.log(headers)
        data.forEach(function(record) {
          // Logger.log(headers)
          var rowData = headers.map(function(header) {
            return record[header];
          });
          allData.push(rowData);
        });
      }
    }
  });

  if (allData.length > 0) {
    dataSheet.getRange(1, 1, allData.length, allData[0].length).setValues(allData);
  }
}


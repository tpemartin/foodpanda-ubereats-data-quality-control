function importCsv(fileId="1c73oL3RT5uJSdFmAjIeagcrqJazzXi4b") {
  
  // Download the file
  var file = DriveApp.getFileById(fileId);
  var fileName = file.getName();
  var csvData = Utilities.parseCsv(file.getBlob().getDataAsString());

  // Convert CSV data to JSON
  var headers = csvData.shift();
  var ubereats = csvData.map(function(row) {
    var obj = {};
    headers.forEach(function(header, index) {
      obj[header] = row[index];
    });
    return obj;
  });

  // Decode base64 from $score_breakdown
  ubereats.forEach(function(record) {
    var scoreBreakdown = Utilities.base64Decode(record.score_breakdown);
    var scoreBreakdownJson = JSON.parse(Utilities.newBlob(scoreBreakdown).getDataAsString());
    record.t120d_eyeball_count = scoreBreakdownJson.t120d_eyeball_count;
    record.t120d_request_count = scoreBreakdownJson.t120d_request_count;
    delete record.score_breakdown; // Remove score_breakdown
  });

  Logger.log(ubereats)
  return ubereats;
}
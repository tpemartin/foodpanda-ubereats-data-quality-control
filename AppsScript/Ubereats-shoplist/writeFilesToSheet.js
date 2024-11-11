function writeFilesToSheet(folderId) {
  var files = listAllFiles(folderId);
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("file list");

  // If the sheet does not exist, create it
  if (!sheet) {
    sheet = SpreadsheetApp.getActiveSpreadsheet().insertSheet("file list");
  } else {
    sheet.clear();  // Clear the sheet if it already exists
  }

  // Write the header
  sheet.appendRow(["Name", "ID"]);

  // Write all file data at once
  if (files.length > 0) {
    sheet.getRange(2, 1, files.length, files[0].length).setValues(files);
  }
}
// To call the function and write files to the sheet
function main() {
  var folderId = "1fGuCYiAnf9tjWvhRhwekHdqc0lhlzXDA"
  writeFilesToSheet(folderId);
}
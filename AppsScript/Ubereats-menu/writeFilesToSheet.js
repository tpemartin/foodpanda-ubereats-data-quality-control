function writeFilesToSheet(folderId) {
  var files = listAllFiles(folderId);
  var foldername = getFolderNameById(folderId)
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("files: "+foldername);

  // If the sheet does not exist, create it
  if (!sheet) {
    sheet = SpreadsheetApp.getActiveSpreadsheet().insertSheet("files: "+foldername);
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
function getFolderNameById(folderId) {
  try {
    // Get the folder using the DriveApp service with the provided folder ID
    var folder = DriveApp.getFolderById(folderId);
    
    // Return the name of the folder
    return folder.getName();
  } catch (e) {
    // Handle any errors (e.g., folder not found)
    throw new Error("Error retrieving folder name: " + e.message);
  }
}

// Example usage
function testGetFolderName() {
  var folderId = "1fIjs2KI8H6rS40FgnlJwBfZkMJa1C8Ey"; // Replace with your actual folder ID
  var folderName = getFolderNameById(folderId);
  Logger.log("Folder Name: " + folderName);
}

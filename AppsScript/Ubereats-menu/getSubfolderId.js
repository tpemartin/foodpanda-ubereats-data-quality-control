function getSubfolderId(foldername, folderId) {
  // Get the parent folder by ID
  var parentFolder = DriveApp.getFolderById(folderId);
  
  // Get the subfolders in the parent folder
  var subfolders = parentFolder.getFolders();
  
  // Iterate through the subfolders to find the one with the matching name
  while (subfolders.hasNext()) {
    var subfolder = subfolders.next();
    if (subfolder.getName() === foldername) {
      return subfolder.getId();
    }
  }
  
  // If no matching subfolder is found, return null or an appropriate message
  return null;
}

function getFolderIdFromUrl(folderUrl) {
  // Regular expression to extract the folder ID
  var regex = /[-\w]{25,}/; // Matches a typical folder ID pattern
  var match = folderUrl.match(regex);

  // If a match is found, return the folder ID
  if (match) {
    return match[0];
  } else {
    throw new Error("Invalid folder URL provided.");
  }
}

// Example usage
function testGetFolderId() {
  var folderUrl = "https://drive.google.com/drive/folders/1Gqr7U9hN5v3fjFzKH4xyz123ABCDEF";
  var folderId = getFolderIdFromUrl(folderUrl);
  Logger.log(folderId); // Logs: 1Gqr7U9hN5v3fjFzKH4xyz123ABCDEF
}

// Example usage

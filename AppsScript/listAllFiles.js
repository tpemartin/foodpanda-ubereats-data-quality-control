function listAllFiles(folderId) {
  // Get the folder ID from the URL
  // var folderId = driveFolderUrl.split('/').pop();
  var folder = DriveApp.getFolderById(folderId);

  // List all files in the folder
  var files = folder.getFiles();
  var fileList = [];
  
  while (files.hasNext()) {
    var file = files.next();
    fileList.push([file.getName(), file.getId()]);
  }
  
  return fileList;
}
function listFilesOfFolderName(foldername = '2024-9-30') {
  // var foldername = '2024-9-30';
  // var folderId = '13tbKAuPidoB0ilxeYTdacNQZ5BBl7VXP';
  var folderUrl = getPropertyValue("folderUrl");
  var folderId = getFolderIdFromUrl(folderUrl)
  var subfolderId = getSubfolderId(foldername, folderId);
  writeFilesToSheet(subfolderId)
  if (subfolderId) {
    Logger.log('Subfolder ID: ' + subfolderId);
  } else {
    Logger.log('Subfolder not found.');
  }
}
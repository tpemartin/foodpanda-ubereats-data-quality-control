// Function to create the custom menu
function onOpen() {
  var ui = SpreadsheetApp.getUi();
  ui.createMenu('Ubereats menu')
      .addItem('List Files of Date', 'promptForFolderName2listFiles')
      .addItem('Import CSVs of Date', 'promptForFolderName2importCSV')
      .addToUi();
}

// Function to prompt the user for a folder name
function promptForFolderName2listFiles() {
  var ui = SpreadsheetApp.getUi();
  var response = ui.prompt('Input the folder name');

  // Check if user pressed "OK" or entered a value
  if (response.getSelectedButton() === ui.Button.OK) {
    var folderName = response.getResponseText();
    listFilesOfFolderName(folderName);  // Call the function with the folder name
  } else {
    ui.alert('No folder name entered. Please try again.');
  }
}
function promptForFolderName2importCSV() {
  var ui = SpreadsheetApp.getUi();
  var response = ui.prompt('Input the folder name');

  // Check if user pressed "OK" or entered a value
  if (response.getSelectedButton() === ui.Button.OK) {
    var folderName = response.getResponseText();
    concatenateDataFromIds(folderName);  // Call the function with the folder name
  } else {
    ui.alert('No folder name entered. Please try again.');
  }
}
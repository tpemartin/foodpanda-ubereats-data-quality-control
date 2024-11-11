function getMenuColumn(ubereatsMenu) {
  // Assuming the first row contains headers
  if (ubereatsMenu.length === 0) {
    return []; // Return an empty array if there are no rows
  }

  var menuColumnIndex = -1;

  // Find the index of the "menu" column
  for (var i = 0; i < ubereatsMenu[0].length; i++) {
    if (ubereatsMenu[0][i].toLowerCase() === 'menu') {
      menuColumnIndex = i;
      break;
    }
  }

  if (menuColumnIndex === -1) {
    throw new Error('Menu column not found.'); // Column not found
  }

  var menuItems = [];

  // Collect all menu items from the "menu" column
  for (var j = 1; j < ubereatsMenu.length; j++) { // Start from 1 to skip header
    menuItems.push(ubereatsMenu[j][menuColumnIndex]);
  }

  return menuItems; // Return the list of menu items
}

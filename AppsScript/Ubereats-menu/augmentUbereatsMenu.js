function augmentUbereatsMenu(ubereatsMenu) {
  const headers = ubereatsMenu[0];
  
  // Add new headers for the menu1 and menu2 columns
  headers.push('menu1', 'menu2');

  // Iterate through each row in ubereatsMenu, starting from the second row (index 1)
  for (let i = 1; i < ubereatsMenu.length; i++) {
    const menuData = ubereatsMenu[i][headers.indexOf('menu')];

    // Parse the encoded menu string
    const parsedMenu = parseEncodedString(menuData);
    
    // Separate the parsed menu into two different strings
    const separatedMenu = separateMenu(parsedMenu);
    
    // Assign values to menu1 and menu2
    ubereatsMenu[i].push(separatedMenu[0], separatedMenu[1]); // Assuming separatedMenu[0] is for menu1 and [1] for menu2

    // Remove the 'menu' column from the row
    ubereatsMenu[i].splice(headers.indexOf('menu'), 1);
  }
  ubereatsMenu[0].splice(headers.indexOf('menu'),1)
  return ubereatsMenu; // Return the augmented menu without the 'menu' column
}

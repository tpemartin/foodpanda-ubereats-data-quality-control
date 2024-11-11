function separateMenu(df_menu) {
  // Create two objects to hold arrays for each field
  let object1 = {
    uuid: [],
    product: [],
    price: [],
    preDiscountPrice: []
  };

  let object2 = {
    uuid: [],
    description: [],
    isSoldOut: [],
    accessibilityText: []
    // Add any other remaining keys that you want to include here
  };

  // Iterate through each item in the df_menu
  for (let i = 0; i < df_menu.uuid.length; i++) {
    // Push the values into object1
    object1.uuid.push(df_menu.uuid[i]);
    object1.product.push(df_menu.product[i]);
    object1.price.push(df_menu.price[i]);
    object1.preDiscountPrice.push(df_menu.preDiscountPirce[i]);

    // Push the uuid and remaining keys into object2
    object2.uuid.push(df_menu.uuid[i]);

    // Collect remaining keys dynamically
    for (const key in df_menu) {
      if (!['uuid', 'product', 'price', 'preDiscountPirce'].includes(key)) {
        // Initialize the array if it doesn't exist yet
        if (!object2[key]) {
          object2[key] = [];
        }
        object2[key].push(df_menu[key][i]);
      }
    }
  }

  // Return an array containing both objects
  return [JSON.stringify(object1), JSON.stringify(object2)];
}

// Testing the separateMenu function with dummy data
const sampleMenuData = {
  uuid: ["uuid1", "uuid2"],
  product: ["Product 1", "Product 2"],
  price: [100, 200],
  preDiscountPirce: [100, 200],
  description: ["Description 1", "Description 2"],
  isSoldOut: [false, true],
  accessibilityText: ["$100.00", "$200.00"]
};

function test_separateMenu() {
  const result = separateMenu(sampleMenuData);
  Logger.log(result);
}

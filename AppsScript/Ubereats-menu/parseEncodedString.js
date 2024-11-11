function parseEncodedString(encodedString) {
  // Decode the Base64 URL string
  var decodedString = Utilities.newBlob(Utilities.base64Decode(encodedString)).getDataAsString();
  
  // Parse the JSON if it's valid JSON
  var jsonData;
  try {
    jsonData = JSON.parse(decodedString);
  } catch (e) {
    Logger.log("Failed to parse JSON: " + e);
    return null; // Return null or handle error as necessary
  }
  
  // Log or return the parsed JSON data
  Logger.log(jsonData);
  return jsonData;
}


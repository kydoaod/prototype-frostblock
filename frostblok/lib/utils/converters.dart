double kelvinToCelsius(double kelvin) {
  return kelvin - 273.15;  // Conversion formula
}

String formatDate(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${date.month}/${date.day}/${date.year}'; // Customize this format as needed
}

String calculateChanceOfIce(double tempCelsius, double humidity, double rain) {
  
  // Initialize the percentage as 0 (no chance)
  double iceChance = 0.0;
  
  // If temperature is at or below freezing (0°C), ice chance starts high
  if (tempCelsius <= 0) {
    iceChance = 100.0;
  } 
  // For temperatures between 1°C and 5°C, there's a moderate chance
  else if (tempCelsius > 0 && tempCelsius <= 5) {
    iceChance = 50.0;  // Base chance is 50%
    
    // Adjust based on rain and humidity
    if (rain > 0 || humidity > 80) {
      iceChance += 30.0; // Increase by 30% if there's rain or high humidity
    } else {
      iceChance += 10.0; // Slight increase if conditions are cool and dry
    }
  } 
  // Above 5°C, chances are very low
  else {
    iceChance = 0.0;  // No chance of ice
  }

  // Ensure the percentage is capped at 100
  iceChance = iceChance.clamp(0.0, 100.0);

  // Return the percentage as a string with one decimal place
  return "${iceChance.toStringAsFixed(1)}%";
}


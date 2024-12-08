double kelvinToCelsius(double kelvin) {
  return kelvin - 273.15;  // Conversion formula
}

String formatDate(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${date.month}/${date.day}/${date.year}'; // Customize this format as needed
}

String calculateChanceOfIce(double tempCelsius, double humidity, double rain) {
  print("$tempCelsius, $humidity, $rain");
  if (tempCelsius <= 0) {
    return 'High';  // 100% chance of ice
  } else if (tempCelsius > 0 && tempCelsius <= 5) {
    if (rain > 0 || humidity > 80) {
      return 'Moderate';  // 50% chance of ice
    } else {
      return 'Low';  // Lower chance, but still possible
    }
  } else {
    return 'None';  // Very low chance of ice
  }
}

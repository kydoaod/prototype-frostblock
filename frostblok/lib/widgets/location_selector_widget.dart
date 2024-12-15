import 'package:flutter/material.dart';

class LocationSelector extends StatefulWidget {
  final ValueChanged<String> onLocationSelected;

  const LocationSelector({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  final TextEditingController searchController = TextEditingController();
  final List<String> locations = [
    'Garden City, UT',
    'Garden Sequa, ID',
    'Rose Garden, OR'
  ];
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Set Location Of Device:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.mic),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
        // List of Locations
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),  // Padding on sides
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              final isSelected = location == selectedLocation;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedLocation = null;  // Deselect if already selected
                    } else {
                      selectedLocation = location;
                    }
                  });
                  widget.onLocationSelected(selectedLocation ?? ""); // Send back data
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1), // Bottom border
                    ),
                    color: isSelected ? Colors.white : Colors.transparent, // White only when selected
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location Name
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.blue : Colors.black, // Location text color
                        ),
                      ),
                      // "Selected" text and Checkmark, only appear when selected
                      if (isSelected)
                        Row(
                          children: [
                            // "Selected" text
                            const Text(
                              'Selected',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, // Blue color for selected text
                              ),
                            ),
                            const SizedBox(width: 4), // Space between "Selected" and checkmark
                            // Checkmark icon
                            const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frostblok/widgets/location_selector_widget.dart';

class AddDevicePage extends StatefulWidget {
  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final PageController _pageController = PageController();
  double progress = 0.0; // Track progress for the loading bar
  String selectedLocation = '';  // Store selected location

  // Method for navigating to the next page
  void goToNextPage() {
    if (_pageController.page == 0) {
      // Location selected, proceed to QR page
      setState(() {
        progress = 1.0; // Move progress bar
      });
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else if (_pageController.page == 1) {
      // QR page complete, finish the process and navigate to the home page
      Navigator.pop(context, {'location': selectedLocation});
    }
  }

  // Method for navigating to the previous page
  void goToPreviousPage() {
    if (_pageController.page == 1) {
      setState(() {
        progress = 0.0;
      });
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Loading Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 12,
                  color: Colors.grey[300],
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: MediaQuery.of(context).size.width * progress,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // PageView to switch between pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Prevent manual scrolling
                children: [
                  // Page 1: Location Selection
                  LocationSelector(
                    onLocationSelected: (location) {
                      setState(() {
                        selectedLocation = location;
                      });
                    },
                  ),

                  // Page 2: Placeholder for QR Scanner
                  const Center(
                    child: Text(
                      'QR Code Scanner Placeholder',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            // Back and Next Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: goToPreviousPage,
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: goToNextPage,
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

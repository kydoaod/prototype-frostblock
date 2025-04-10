import 'package:flutter/material.dart';
import 'package:frostblok/widgets/circular_indicator_widget.dart';
import 'package:frostblok/widgets/mode_tabs_widget.dart'; // Ensure you have this widget

class DefrostDevicePage extends StatelessWidget {
  const DefrostDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            "Garden City", // Example location, can be dynamic
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const Text(
            "Device 1: Defrosting Device", // Example device name
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 20),
          const CircularIndicator(
            progress: 0.40, // Example progress
            startColor: Color.fromARGB(255, 0, 112, 255),
            endColor: Color.fromARGB(255, 0, 178, 255),
            temperature: "29 °F",
            label: "Outdoor Temperature",
            size: 175,
          ),
          const SizedBox(height: 50),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const ModeTabs(), // Assuming you want tabs for controlling modes
            ),
          ),
        ],
      ),
    );
  }
}

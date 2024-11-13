import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final int temperature;
  final String location;
  final String status;
  final VoidCallback onToggle;

  const DeviceCard({
    required this.temperature,
    required this.location,
    required this.status,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Temperature Text
          Text(
            '$temperature°',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          // Location and Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Toggle Icon
          IconButton(
            icon: const Icon(Icons.toggle_off),
            color: Colors.grey.shade400,
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}

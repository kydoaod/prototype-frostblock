import 'package:flutter/material.dart';
import 'package:frostblok/utils/svg_icons.dart';

class DeviceCard extends StatelessWidget {
  final int temperature;
  final String location;
  final String status;
  final VoidCallback onToggle;
  final void Function(BuildContext context) onTap;

  const DeviceCard({
    required this.temperature,
    required this.location,
    required this.status,
    required this.onToggle,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Text(
              '$temperature°',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
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
            IconButton(
              icon: status == 'on'
                  ? SvgIcons.actionDefrostOn(size: 24, color: Colors.orange)
                  : SvgIcons.actionDefrostOff(size: 24, color: Colors.grey.shade400),
              onPressed: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}

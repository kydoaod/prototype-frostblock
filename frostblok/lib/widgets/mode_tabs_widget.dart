import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModeTabs extends StatefulWidget {
  const ModeTabs({super.key});

  @override
  State<ModeTabs> createState() => _ModeTabsState();
}

class _ModeTabsState extends State<ModeTabs> {
  int _selectedIndex = 0; // Default selected tab (Schedule)

  // Schedule Date-Time variables
  DateTime _selectedFromDate = DateTime.now();
  TimeOfDay _selectedFromTime = const TimeOfDay(hour: 8, minute: 0);
  DateTime _selectedToDate = DateTime.now();
  TimeOfDay _selectedToTime = const TimeOfDay(hour: 17, minute: 0);

  void _showDateTimePicker(
      BuildContext context, DateTime initialDate, TimeOfDay initialTime, Function(DateTime, TimeOfDay) onDateTimeChanged) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (pickedTime != null) {
        onDateTimeChanged(pickedDate, pickedTime);
      }
    }
  }

  Widget _buildDateTimePicker(
      BuildContext context, String label, DateTime date, TimeOfDay time) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _showDateTimePicker(
            context,
            date,
            time,
            (pickedDate, pickedTime) {
              setState(() {
                if (label == "From") {
                  _selectedFromDate = pickedDate;
                  _selectedFromTime = pickedTime;
                } else {
                  _selectedToDate = pickedDate;
                  _selectedToTime = pickedTime;
                }
              });
            },
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${time.format(context)}",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentContent() {
    switch (_selectedIndex) {
      case 0: // Schedule Mode
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Schedule",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  _buildDateTimePicker(
                      context, "From", _selectedFromDate, _selectedFromTime),
                  Container(
                    width: 1,
                    height: 60,
                    color: Colors.grey,
                  ),
                  _buildDateTimePicker(
                      context, "To", _selectedToDate, _selectedToTime),
                ],
              ),
            ),
          ],
        );
      case 1: // Timer Mode
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Timer",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: SizedBox(
                height: 150,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms, // Hours, Minutes, Seconds
                  initialTimerDuration: const Duration(minutes: 15),
                  onTimerDurationChanged: (Duration newDuration) {
                    // Handle timer duration selection
                    print("Selected duration: $newDuration");
                  },
                ),
              ),
            ),
          ],
        );
      case 2: // Manual Mode
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Manual",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Center(child: Text("Manual Content Here")),
          ],
        );
      default:
        return const Center(child: Text("Invalid selection"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // "Mode" Label
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "Mode",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Segmented Button
        CupertinoSegmentedControl<int>(
          children: const {
            0: Text("Schedule"),
            1: Text("Timer"),
            2: Text("Manual"),
          },
          onValueChanged: (int value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          groupValue: _selectedIndex,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _buildSegmentContent(),
        ),
      ],
    );
  }
}

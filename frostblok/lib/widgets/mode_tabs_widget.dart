import 'package:flutter/material.dart';

class ModeTabs extends StatefulWidget {
  const ModeTabs({super.key});

  @override
  _ModeTabsState createState() => _ModeTabsState();
}

class _ModeTabsState extends State<ModeTabs> {
  int _selectedIndex = 0;
  DateTime? _selectedFromDate;
  TimeOfDay? _selectedFromTime;
  DateTime? _selectedToDate;
  TimeOfDay? _selectedToTime;

  void _onSegmentSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _selectDateTime(BuildContext context, bool isFrom) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          if (isFrom) {
            _selectedFromDate = pickedDate;
            _selectedFromTime = pickedTime;
          } else {
            _selectedToDate = pickedDate;
            _selectedToTime = pickedTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // "Mode" Label aligned with the Segmented Button
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                "Mode",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Segmented Button (replaces TabBar)
        SegmentedButton<int>(
          selected: {_selectedIndex},
          onSelectionChanged: (Set<int> newSelection) {
            _onSegmentSelected(newSelection.first);
          },
          segments: const [
            ButtonSegment<int>(
              value: 0,
              label: Text('Schedule'),
            ),
            ButtonSegment<int>(
              value: 1,
              label: Text('Timer'),
            ),
            ButtonSegment<int>(
              value: 2,
              label: Text('Manual'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Content based on selected segment
        _buildSegmentContent(),
        const SizedBox(height: 20),
        Padding( 
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton( 
            onPressed: () { // Add your defrost start logic here 
            }, 
            style: ElevatedButton.styleFrom( 
              backgroundColor: Colors.blue, // Background color 
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50), // Full-width button
            ), 
            child: const Text("Start Defrost", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), 
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentContent() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Schedule label
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
                  _buildDateTimePicker(context, "From", _selectedFromDate, _selectedFromTime),
                  Container(
                    width: 1,
                    height: 60, // Adjust height as needed
                    color: Colors.grey,
                  ),
                  _buildDateTimePicker(context, "To", _selectedToDate, _selectedToTime),
                ],
              ),
            )
          ],
        );
      case 1:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timer label
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Timer",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Center(child: Text("Timer Content Here")),
          ],
        );
      case 2:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Manual label
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

  Widget _buildDateTimePicker(BuildContext context, String label, DateTime? selectedDate, TimeOfDay? selectedTime) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: label == "From" ? const Radius.circular(12) : Radius.zero,
              topRight: label == "From" ? Radius.zero : const Radius.circular(12),
              bottomLeft: label == "From" ? const Radius.circular(12) : Radius.zero,
              bottomRight: label == "From" ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 14, top: 5),
                child: Text(
                            label,
                            style: const TextStyle(color: Colors.grey),
                          ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _selectDateTime(context, label == "From"),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(8),
                      topRight: const Radius.circular(8),
                      bottomLeft: label == "From" ? Radius.zero : const Radius.circular(8),
                      bottomRight: label == "From" ? Radius.zero : const Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    selectedDate != null && selectedTime != null
                        ? "${selectedDate.year}/${selectedDate.month}/${selectedDate.day} ${selectedTime.format(context)}"
                        : "Select Date & Time",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (label == "From")
          Container(
            height: 1,
            color: Colors.grey.shade400,
          ),
      ],
    );
  }
}

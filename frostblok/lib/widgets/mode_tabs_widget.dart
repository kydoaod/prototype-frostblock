import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModeTabs extends StatefulWidget {
  const ModeTabs({super.key});

  @override
  State<ModeTabs> createState() => _ModeTabsState();
}

class _ModeTabsState extends State<ModeTabs> {
  int _selectedIndex = 0;
  DateTime _selectedFromDate = DateTime.now();
  TimeOfDay _selectedFromTime = const TimeOfDay(hour: 8, minute: 0);
  DateTime _selectedToDate = DateTime.now();
  TimeOfDay _selectedToTime = const TimeOfDay(hour: 17, minute: 0);

  bool _isDefrosting = false; // Added state to track defrosting

  // Theme Colors
  Color _activeThemeColor = Colors.blueAccent;

  void _toggleDefrost() {
    setState(() {
      _isDefrosting = !_isDefrosting;
      _activeThemeColor = _isDefrosting ? Colors.amberAccent : Colors.blueAccent;
    });
  }

  void _showDateTimePicker(
    BuildContext context,
    DateTime initialDate,
    TimeOfDay initialTime,
    Function(DateTime, TimeOfDay) onDateTimeChanged,
  ) async {
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
          _showDateTimePicker(context, date, time, (pickedDate, pickedTime) {
            setState(() {
              if (label == "From") {
                _selectedFromDate = pickedDate;
                _selectedFromTime = pickedTime;
              } else {
                _selectedToDate = pickedDate;
                _selectedToTime = pickedTime;
              }
            });
          });
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
              textAlign: TextAlign.center,
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
      case 0:
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              child: Padding(
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
            ),
          ],
        );
      case 1:
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
                height: 120,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  initialTimerDuration: const Duration(minutes: 15),
                  onTimerDurationChanged: (Duration newDuration) {
                    print("Selected duration: $newDuration");
                  },
                ),
              ),
            ),
          ],
        );
      case 2:
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

  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(3, (index) {
          final bool isSelected = _selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? _activeThemeColor : Colors.transparent,
                  borderRadius: isSelected ? BorderRadius.circular(24) : BorderRadius.zero,
                ),
                child: Text(
                  index == 0
                      ? 'Schedule'
                      : index == 1
                          ? 'Timer'
                          : 'Manual',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDefrostButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _activeThemeColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: MaterialButton(
          onPressed: _toggleDefrost,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            _isDefrosting ? 'Device is Running...' : 'Start Defrost',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "Mode",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildSegmentedControl(),
        const SizedBox(height: 16),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSegmentContent()),
          _buildDefrostButton(),
      ],
    );
  }
}

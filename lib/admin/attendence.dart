import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../Functions.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AddAttendance(),
    ListAttendance(),
    const ReportAttendance(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem_rounded),
            label: 'Report',
          ),
        ],
      ),
    );
  }
}

class AddAttendance extends StatefulWidget {
  const AddAttendance({Key? key}) : super(key: key);

  @override
  _AddAttendanceState createState() => _AddAttendanceState();
}

class _AddAttendanceState extends State<AddAttendance> {
  Map<String, dynamic>? _selectedEmployee;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  List<Map<String, dynamic>> _employeeData = [];

  @override
  void initState() {
    super.initState();
    fetchEmployee();
  }

  Future<void> fetchEmployee() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .get();
      _employeeData = querySnapshot.docs
        .map((doc) => {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        })
        .toList();
      setState(() {});
    } catch (e) {
      print('Error fetching Employee: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 150.0),
            DropdownButtonFormField<Map<String, dynamic>>(
              value: _selectedEmployee,
              onChanged: (Map<String, dynamic>? value) {
                setState(() {
                  _selectedEmployee = value;
                });
              },
              items: _employeeData.map((Map<String, dynamic> employee) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: employee,
                  child: Text('${employee['firstName']} ${employee['lastName']}'),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Select Employee'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? startTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (startTime != null) {
                  setState(() {
                    _startTime = startTime;
                  });
                }
              },
              child: const Text('Select Start Time'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? endTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (endTime != null) {
                  setState(() {
                    _endTime = endTime;
                  });
                }
              },
              child: const Text('Select End Time'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_selectedEmployee != null) {
                  if (_startTime != null && _endTime != null) {
                    String startTimeString =
                        '${_startTime!.hour}:${_startTime!.minute}';
                    String endTimeString =
                        '${_endTime!.hour}:${_endTime!.minute}';
                    addAttendance(
                      _selectedEmployee?['id'],
                      _selectedEmployee?['firstName'],
                      _selectedEmployee?['lastName'],
                      _selectedDate.toString(),
                      startTimeString,
                      endTimeString,
                      context
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}


class ListAttendance extends StatefulWidget {
  ListAttendance({Key? key});

  @override
  State<ListAttendance> createState() => _ListAttendanceState();
}

class _ListAttendanceState extends State<ListAttendance> {
  List<Map<String, dynamic>> _attendanceList = [];

  Future<void> fetchAttendance() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Attendance')
        .get();
      _attendanceList = querySnapshot.docs
        .map((doc) => {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        })
        .toList();
      setState(() {});
    } catch (e) {
      print('Error fetching Attendance: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _attendanceList.isEmpty
          ? const Center(
              child: Text('No attendance data available.'),
            )
          : ListView.builder(
              itemCount: _attendanceList.length,
              itemBuilder: (context, index) {
                DateTime date = DateTime.parse(_attendanceList[index]['date']);
                String formattedDate = DateFormat('yyyy/MM/dd').format(date);
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _attendanceList[index]['employeeFirstName']+' '+_attendanceList[index]['employeeLastName'],
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Date :$formattedDate',
                        style: const TextStyle(
                          fontSize: 18
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "From: ${_attendanceList[index]['startTime']}",
                            style: const TextStyle(
                              fontSize: 18
                            ),
                          ),
                          const SizedBox(width: 150.0),
                          Text(
                            "To: ${_attendanceList[index]['endTime']}", 
                            style: const TextStyle(
                              fontSize: 18
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey, 
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      )
                    ],
                  )
                );
              },
            ),
    );
  }
}

class ReportAttendance extends StatefulWidget {
  const ReportAttendance({super.key});

  @override
  State<ReportAttendance> createState() => _ReportAttendanceState();
}

class _ReportAttendanceState extends State<ReportAttendance> {
  List<Map<String, dynamic>> _attendanceReport = [];

  Future<void> fetchAttendanceReport() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AttendanceReport')
        .get();
      _attendanceReport = querySnapshot.docs
        .map((doc) => {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        })
        .toList();
      setState(() {});
    } catch (e) {
      print('Error fetching Attendance: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttendanceReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _attendanceReport.length,
        itemBuilder: (context, index) {
          DateTime date = DateTime.parse(_attendanceReport[index]['date']);
          String formattedDate = DateFormat('yyyy/MM/dd').format(date);
          TimeOfDay startTime = _extractTimeOfDay(_attendanceReport[index]['startTime']);
          TimeOfDay endTime = _extractTimeOfDay(_attendanceReport[index]['endTime']);
          String formattedStartTime = '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}';
          String formattedEndTime = '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}';
          return Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_attendanceReport[index]['employeeFirstName']} ${_attendanceReport[index]['employeeLastName']}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "From: $formattedStartTime",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 50.0),
                    Text(
                      "To: $formattedEndTime",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 50.0),
                    IconButton(
                      onPressed: () {
                        deleteAttendanceReport(_attendanceReport[index]['id'],context);
                        fetchAttendanceReport();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.grey, 
                  margin: const EdgeInsets.symmetric(vertical: 10),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  TimeOfDay _extractTimeOfDay(String timeOfDayString) {
    List<String> parts = timeOfDayString
        .replaceAll('TimeOfDay(', '')
        .replaceAll(')', '')
        .split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}

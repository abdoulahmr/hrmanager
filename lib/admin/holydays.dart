import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../Functions.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const AddHolidays(),
    LeaveApplication(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Add Holidays',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Leave Application',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AddHolidays extends StatefulWidget {
  const AddHolidays({super.key});

  @override
  _AddHolidaysState createState() => _AddHolidaysState();
}

class _AddHolidaysState extends State<AddHolidays> {
  Map<String, dynamic>? _selectedEmployee;
  List<Map<String, dynamic>> _employeeData = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

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
      appBar: AppBar(
        title: const Text('Add Holidays'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100.0),
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
            Text('Start Date: ${DateFormat('yyyy/MM/dd').format(_startDate)}'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectStartDate(context),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350.0, 20.0),
              ),
              child: const Text('Select Start Date'),
            ),
            const SizedBox(height: 16.0),
            Text('Start Date: ${DateFormat('yyyy/MM/dd').format(_endDate)}'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectEndDate(context),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350.0, 20.0),
              ),
              child: const Text('Select End Date'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                addHolyday(
                  _selectedEmployee!['id'],
                  _selectedEmployee!['firstName'],
                  _selectedEmployee!['lastName'],
                  _startDate.toString(),
                  _endDate.toString(),
                  context
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350.0, 20.0),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }
}

class LeaveApplication extends StatefulWidget {
  @override
  State<LeaveApplication> createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {
  List<Map<String, dynamic>> _leaveReq = [];

  Future<void> fetchLeaveRequest() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('LeaveRequest')
          .get();
      _leaveReq = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
      setState(() {});
    } catch (e) {
      print('Error fetching Leave Request: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLeaveRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Application'),
      ),
      body: ListView.builder(
        itemCount: _leaveReq.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_leaveReq[index]['employeeFirstName']} ${_leaveReq[index]['employeeLastName']}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Start Date: ${DateFormat('yy/MM/dd')
                      .format(DateTime.parse(_leaveReq[index]['startDate']))}',
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      'Start Date: ${DateFormat('yy/MM/dd')
                      .format(DateTime.parse(_leaveReq[index]['endDate']))}',
                    ),
                    IconButton(
                      onPressed: () {
                        deleteLeaveRequest(_leaveReq[index]['id'],context);
                        fetchLeaveRequest();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        addHolyday(
                          _leaveReq[index]['employeeId'],
                          _leaveReq[index]['employeeFirstName'],
                          _leaveReq[index]['employeeLastName'],
                          _leaveReq[index]['startDate'],
                          _leaveReq[index]['endDate'],
                          context
                        );
                        deleteLeaveRequest(_leaveReq[index]['id'],context);
                        fetchLeaveRequest();
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ],
                ),
                Text(
                  'Reason: ${_leaveReq[index]['reason']}',
                  style: const TextStyle(
                    fontSize: 18.0,
                  )
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
}

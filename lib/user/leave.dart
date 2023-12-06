import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Functions.dart';

class LeavRequest extends StatefulWidget {
  @override
  _AddHolidaysState createState() => _AddHolidaysState();
}

class _AddHolidaysState extends State<LeavRequest> {
  final TextEditingController _resonController = TextEditingController();
  List<Map<String, dynamic>> _employeeData = [];
  List<Map<String, dynamic>> _leaveList = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchEmployee();
    fetchLeaveRequests();
  }

  Future<void> fetchEmployee() async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .doc(user!.uid)
        .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> employeeData = {
          'id': documentSnapshot.id,
          ...documentSnapshot.data() as Map<String, dynamic>,
        };
        _employeeData = [employeeData];
        setState(() {});
      } else {
        print('Employee document not found for user ID: ${user.uid}');
      }
    } catch (e) {
      print('Error fetching Employee: $e');
    }
  }

  Future<void> fetchLeaveRequests() async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('LeaveRequest')
          .where('employeeId', isEqualTo: user!.uid)
          .get();

      _leaveList = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();

      setState(() {});
    } catch (e) {
      print('Error fetching leave requests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Leave'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Send a request",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectStartDate(context),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350.0, 20.0),
              ),
              child: const Text('Select Start Date'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectEndDate(context),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350.0, 20.0),
              ),
              child: const Text('Select End Date'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _resonController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Enter your text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                addLeaveRequest(
                    _employeeData[0]['id'],
                    _employeeData[0]['firstName'],
                    _employeeData[0]['lastName'],
                    _startDate.toString(),
                    _endDate.toString(),
                    _resonController.text,
                    context
                  );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350.0, 20.0),
              ),
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Your requests",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _leaveList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_leaveList[index]['startDate']} ${_leaveList[index]['endDate']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteLeaveRequest(_leaveList[index]['id'],context);
                            fetchLeaveRequests();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Functions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _employeeData = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
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
      if (_employeeData.isNotEmpty) {
        _firstNameController.text = _employeeData[0]['firstName'] ?? '';
        _lastNameController.text = _employeeData[0]['lastName'] ?? '';
        _emailController.text = _employeeData[0]['email'] ?? '';
        _passwordController.text = _employeeData[0]['password'] ?? '';
        _phoneController.text = _employeeData[0]['phone'] ?? '';
      }
    } catch (e) {
      print('Error fetching Employee: $e');
    }
  }

  @override
  void initState() { 
    super.initState();
    fetchEmployee();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                
              ),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350.0, 20.0),
              ),
              child: const Text('Select Date'),
            ),
            if (_selectedDate != null)
              Text('Selected Date: ${_selectedDate!.toLocal()}'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                updateEmployeeInfo(
                  _employeeData[0]['id'],
                  _firstNameController.text,
                  _lastNameController.text,
                  _emailController.text,
                  _passwordController.text,
                  _phoneController.text,
                  _selectedDate.toString(),
                  context
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350.0, 20.0),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

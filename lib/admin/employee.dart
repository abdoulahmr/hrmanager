import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Functions.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmployeeFormPageState createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  DateTime? _selectedDate;
  List<String> _departmentNames = [];
  List<Map<String, dynamic>> _employeeData = [];

  @override
  void initState() {
    super.initState();
    fetchDepartmentNames();
    fetchEmployee();
  }

  Future<void> fetchDepartmentNames() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Organization')
        .get();
      _departmentNames = querySnapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['departmentName'] as String)
        .toList();
      setState(() {});
    } catch (e) {
      print('Error fetching department names: $e');
    }
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
        title: const Text('Employee'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      const Text(
                        'Add Employee',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(labelText: 'First Name'),
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(labelText: 'Last Name'),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
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
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(350.0, 20.0),
                        ),
                        child: const Text('Select Date'),
                      ),
                      DropdownButtonFormField<String>(
                        value: _departmentController.text.isNotEmpty
                            ? _departmentController.text
                            : null,
                        items: _departmentNames.map((String department) {
                          return DropdownMenuItem<String>(
                            value: department,
                            child: Text(department),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _departmentController.text = value ?? '';
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Department'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await signUpWithUsernameAndPassword(
                            _firstNameController.text,
                            _lastNameController.text,
                            _emailController.text,
                            _passwordController.text,
                            _phoneNumberController.text,
                            _departmentController.text,
                            _selectedDate!,
                            context
                          );                        
                          await fetchEmployee();
                          _formKey.currentState?.reset();
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(350.0, 20.0),
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Add Employee',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _employeeData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_employeeData[index]['firstName']} ${_employeeData[index]['lastName']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteEmployee(_employeeData[index]['id'],_employeeData[index]['email'],context);
                            fetchEmployee();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

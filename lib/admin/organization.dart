import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Functions.dart';

class Organization extends StatefulWidget {
  @override
  State<Organization> createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Map<String, dynamic>> _departments = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Organization')
        .get();
      _departments = querySnapshot.docs
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
        title: const Text('Organization'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Add Department',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Enter Department Name',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.all(20.0),
              height: 40,
              width: 350,
              child: ElevatedButton(
                onPressed: () async {
                  await addDepartment(_textEditingController.text,context);
                  await fetchDepartments();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const Text(
              'Department List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _departments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${_departments[index]['departmentName']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      deleteDepartment(_departments[index]['departmentId'],context);
                      await fetchDepartments();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'admin/adminhome.dart';
import 'user/employeeHome.dart';
import 'login.dart';

Future<void> loginWithUsernameAndPassword(
    String username, String password, context) async {
  try {
    if (username == 'admin' && password == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }else{
      UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: username,
          password: password,
        );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmployeeHome()),
      );
    }
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Invalid username or password',
    );
  }
}

Future<void> signUpWithUsernameAndPassword(
  String firstName,
  String lastName,
  String email,
  String password,
  String phoneNumber,
  String department,
  DateTime birthday,
  context
) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseFirestore.instance
        .collection('Employee')
        .doc(userCredential.user!.uid)
        .set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'department': department,
      'birthday': birthday,
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Employee added successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Employee addition failed: $e',
    );
  }
}

Future<void> signOut(context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Sign out failed: $e',
    );
  }
}

Future<void> deleteEmployee(String employeeId, String userEmail, context) async {
  try {
    await FirebaseFirestore.instance.collection('Employee').doc(employeeId).delete();
    User? user = (await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(userEmail))
        .first as User?;
    user!.delete();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Employee deleted successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Employee deletion failed: $e',
    );
  }
}

Future<void> addDepartment(String departmentName,context) async {
  try {
    String departmentId = FirebaseFirestore.instance.collection('Organization').doc().id;
    await FirebaseFirestore.instance
        .collection('Organization') 
        .doc(departmentId)
        .set({
      'departmentName': departmentName,
      'departmentId': departmentId,
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Department added successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Department deletion failed: $e',
    );
  }
}

Future<void> deleteDepartment(String departmentId, context) async {
  try {
    await FirebaseFirestore.instance.collection('Organization').doc(departmentId).delete();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Department deleted successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Department deletion failed: $e',
    );
  }
}

Future<void> addAttendance(
  String employeeId, 
  String employeeFirstName, 
  String employeeLastName, 
  String date, 
  String startTime, 
  String endTime,
  context) async {
  try {
    
    String attendanceID = FirebaseFirestore.instance.collection('Attendance').doc().id;
    await FirebaseFirestore.instance
        .collection('Attendance')
        .doc(attendanceID)
        .set({
      'emporid': employeeId,
      'employeeFirstName': employeeFirstName,
      'employeeLastName': employeeLastName,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Attendance added successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Attendance addition failed: $e',
    );
  }
}

Future<void> addHolyday(
  String employeeID, 
  String empliyeeFirstName, 
  String employeeLastName, 
  String startDate, 
  String endDate,
  context) async {
  try {
    String holydayID = FirebaseFirestore.instance.collection('Holyday').doc().id;
    await FirebaseFirestore.instance
        .collection('Holyday') 
        .doc(holydayID)
        .set({
      'employeeID': employeeID,
      'employeeFirstName': empliyeeFirstName,
      'employeeLastName': employeeLastName,
      'startDate': startDate,
      'endDate': endDate,
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Holiday added successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Holiday addition failed: $e',
    );
  }
}

Future<void> updateEmployeeInfo(
  String employeeId,
  String newFirstName, 
  String newLastName,
  String newEmail,
  String newPassword,
  String newPhone,
  String newDate,
  context) async {
  try {
    await FirebaseFirestore.instance.collection('Employee').doc(employeeId).update({
      'firstName': newFirstName,
      'lastName': newLastName,
      'email': newEmail,
      'password': newPassword,
      'phone': newPhone,
      'birthday': newDate,
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Information updated successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Information update failed: $e',
    );
  }
}

Future<void> addLeaveRequest(
  String employeeId,
  String employeeFirstName,
  String employeeLastName,
  String startDate,
  String endDate,
  String reason,
  context
) async {
  try {
    String leaveRequestId = FirebaseFirestore.instance.collection('LeaveRequest').doc().id;
    await FirebaseFirestore.instance
        .collection('LeaveRequest')
        .doc(leaveRequestId)
        .set({
      'employeeId': employeeId,
      'employeeFirstName': employeeFirstName,
      'employeeLastName': employeeLastName,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'status': 'Pending',
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Leave request added successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Leave request addition failed: $e',
    );
  }
}

Future<void> deleteLeaveRequest(String leaveRequestId,context) async {
  try {
    await FirebaseFirestore.instance
        .collection('LeaveRequest')
        .doc(leaveRequestId)
        .delete();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Leave Request deleted successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Leave Request deletion failed: $e',
    );
  }
}

Future<void> addAttendanceReport(
  String employeeId,
  String employeeFirstName,
  String employeeLastName,
  String date,
  String startTime,
  String endTime,
  String reson,
  context
) async {
  try {
    String attendanceReportId = FirebaseFirestore.instance.collection('AttendanceReport').doc().id;
    await FirebaseFirestore.instance
        .collection('AttendanceReport')
        .doc(attendanceReportId)
        .set({
      'employeeId': employeeId,
      'employeeFirstName': employeeFirstName,
      'employeeLastName': employeeLastName,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'reson': reson,
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Attendance report added successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Attendance report addition failed: $e',
    );
  }
}

Future<void> deleteAttendanceReport(String attendanceReportId,context) async {
  try {
    await FirebaseFirestore.instance
        .collection('AttendanceReport')
        .doc(attendanceReportId)
        .delete();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Attendance report deleted successfully',
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Attendance report deletion failed: $e',
    );
  }
}

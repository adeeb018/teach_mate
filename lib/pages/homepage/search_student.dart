import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/bloc/home/body/body_bloc.dart';
import 'package:school_management/constants/widgets/scaffold_notification.dart';

class StudentSearch extends StatefulWidget {
  @override
  _StudentSearchState createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // Function to get current user’s UID for querying
  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  // Function to search students by name
  Stream<QuerySnapshot> searchStudents(String searchText) {
    final uid = getCurrentUserId();
    final list = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('students').where(
        'name', isGreaterThanOrEqualTo: searchText)
        .where('name', isLessThanOrEqualTo: '$searchText\uf8ff')
        .snapshots();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Students'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter student name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // setState(() {
                //   log(value);
                //   _searchText = value;
                // });
                context.read<BodyBloc>().add(
                    SearchStudentEvent(searchText: value));
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocConsumer<BodyBloc, BodyState>(
                listener: (context, state) {
                  if (state is SearchStudentError) {
                    ScaffoldSnackBar.of(context).show(state.error);
                  }
                },
                builder: (context, state) {
                  if (state is SearchStudentLoading) {
                    return Container(alignment:Alignment.center,child: CircularProgressIndicator());
                  } else if (state is SearchStudentNoResults) {
                    return Center(child: Text('No students found'),);
                  } else if (state is SearchStudentLoaded) {
                    return ListView(
                        children: state.students.map((data) {
                      return ListTile(
                        onTap: () {
                          // go to created student form with this student data
                          // debugPrint('id passed is${data['id']}');
                          context.go(Uri(
                            path: '/homepage/add-student/student-details',
                            queryParameters: {'id': data['id']},
                          ).toString());
                        },
                        title: Text(data['name'] ?? 'Unnamed'),
                        subtitle: Text(data['contact'] ?? 'No contact'),
                      );
                    }).toList());
                  }
                  else {
                    return const Center(child: Text('Start typing to search'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
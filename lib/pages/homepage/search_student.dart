import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        .collection('students').where('name', isGreaterThanOrEqualTo: searchText)
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
                setState(() {
                  log(value);
                  _searchText = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _searchText.isEmpty
                    ? null
                    : searchStudents(_searchText),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No students found'));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['name'] ?? 'Unnamed'),
                        subtitle: Text(data['contact'] ?? 'No contact'),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
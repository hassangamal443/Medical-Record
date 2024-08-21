import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsernameWidget extends StatelessWidget {
  final double fontSize;
  final Color color;

  const UsernameWidget({
    Key? key,
    required this.fontSize,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid) // Get current user's UID
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Center(
            child: Text('No user data found.'),
          );
        }

        // Extract the username from the user's document
        var userData = snapshot.data!.data() as Map<String, dynamic>;
        var username = userData['username'];

        return Text(
          username,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: 'Oxanium',
          ),
        );
      },
    );
  }
}

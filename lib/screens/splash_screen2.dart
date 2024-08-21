import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/screens/login_screen.dart';
import 'dart:async';

import 'package:personal_medical_record/screens/scaffold.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _subscription;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // If user is authenticated, get the user's document from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      // Listen for changes in the photoUrl field
      _subscription = userDoc.reference.snapshots().listen((docSnapshot) {
        if (docSnapshot.exists && docSnapshot.data() != null) {
          // Once photoUrl is available, navigate to main screen
          if (docSnapshot.data()!['photoUrl'] != null) {
            setState(() {
              _isLoading = false;
            });
            _subscription.cancel(); // Cancel the snapshot listener
            // Navigate to main screen after 3 seconds
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyScaffold()));
            });
          }
        }
      });
    } else {
      // If user is not authenticated, navigate to login screen after 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white,) // Display loading indicator
            : Container(child: Center(
          child: Image.asset('Images/medical-record.png',width: 100,),
        ),), // Once loading is complete, display nothing
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel(); // Cancel the snapshot listener when disposing the widget
    super.dispose();
  }
}

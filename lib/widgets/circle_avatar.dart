import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CircleAvatarWidget extends StatelessWidget {
  final int radius;

  const CircleAvatarWidget({Key? key, required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Image.asset('Images/user (3).png');
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        var photoUrl = userData['photoUrl']; // Changed 'photoURL' to 'photoUrl'

        if (photoUrl == null || !(photoUrl is String)) {
          return Image.asset('Images/user (3).png'); // Or any placeholder image
        }

        return CircleAvatar(
          radius: radius.toDouble(),
          backgroundImage: NetworkImage(photoUrl),
        );
      },
    );
  }
}

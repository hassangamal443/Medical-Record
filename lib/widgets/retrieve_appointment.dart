import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppointmentDetailPage extends StatefulWidget {


  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}
double deviceHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double deviceWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;
class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  @override
  Widget build(BuildContext context) {
    final currentUserUID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .orderBy('dateTime', descending: false)
            .where('userId', isEqualTo: currentUserUID)// Sort by date in ascending order
            .limit(1) // Limit the result to 1 appointment
            .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
    }

    if (snapshot.data!.docs.isEmpty) {
    return Center(child: Text('No appointments found'));
    }

    var appointment = snapshot.data!.docs.first;
    DateTime dateTime = appointment['dateTime'].toDate();
    String date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    String time = '${dateTime.hour}:${dateTime.minute}';
    String doctorName = appointment['doctorName'];
    String doctorType = appointment['doctorType'];

    return InkWell(
    child: Container(
    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    width: deviceWidth(context),
    height: deviceHeight(context) / 7,
    decoration: BoxDecoration(
    color: Colors.indigo[500],
    borderRadius: BorderRadius.all(Radius.circular(30)),
    boxShadow: [
    BoxShadow(
    color: Colors.white,
    spreadRadius: 2,
    blurRadius: 7,
    offset: Offset(3, -3),
    ),
    BoxShadow(
    color: Colors.black12,
    spreadRadius: 2,
    blurRadius: 7,
    offset: Offset(-3, 3),
    ),
    ],
    ),
    child: Column(
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    appointment['doctorName'],
    style: TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'Oxanium',
    ),
    ),
    SizedBox(),
    ],
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    appointment['doctorType'],
    style: TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontFamily: 'Oxanium',
    ),
    ),
    SizedBox(),
    ],
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Text(
            AppLocalizations.of(context)!.date,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Oxanium',
            ),
          ),
          Text(
            ' $date',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Oxanium',
            ),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            AppLocalizations.of(context)!.time,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Oxanium',
            ),
          ),
          Text(
            ' $time',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Oxanium',
            ),
          ),
        ],
      ),
    SizedBox(),
    ],
    ),
    ],
    ),
    ),
    onTap: () {
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.indigo[900],
      title: Text(
        'Appointment Details',
        style: TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Oxanium',
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(AppLocalizations.of(context)!.doctor_Name,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),),
                Text(
                  ' ${appointment['doctorName']}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.date,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
                Text(
                  ' $date',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.time,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
                Text(
                  ' $time',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.place,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
                Text(
                  ' ${appointment['place']}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.purpose,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
                Text(
                  ' ${appointment['purpose']}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.doctor_Type,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
                Text(
                  ' ${appointment['doctorType']}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.appointment_Number,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
                Text(
                  ' ${appointment['appointmentNumber']}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.close,
            style: TextStyle(
              fontSize: 20,
              color: Colors.indigo[200],
              fontWeight: FontWeight.bold,
              fontFamily: 'Oxanium',
            ),
          ),
        ),
      ],
    );
    },
    );
    },
    );

    }
    );
  }
}
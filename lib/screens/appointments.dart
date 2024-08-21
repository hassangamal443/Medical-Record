import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_medical_record/screens/add_appointment.dart';
import 'package:personal_medical_record/screens/edit_appointmets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}
double deviceHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double deviceWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserUID = FirebaseAuth.instance.currentUser!.uid;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(125.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 0,
                  blurRadius: 10,
                ),
              ],
            ),
            margin: EdgeInsets.all(10),
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.indigo[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                  top: Radius.circular(30),
                ),
              ),
              toolbarHeight: 100,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(30),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.appointments,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'Oxanium',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .where('userId', isEqualTo: currentUserUID)
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

            var appointments = snapshot.data!.docs;

            // Sorting appointments by date/time
            appointments.sort((a, b) {
              DateTime timeA = a['dateTime'].toDate();
              DateTime timeB = b['dateTime'].toDate();
              return timeA.compareTo(timeB);
            });

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                var appointment = appointments[index];
                DateTime dateTime = appointment['dateTime'].toDate();
                String date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                String time = '${dateTime.hour}:${dateTime.minute}';
                return InkWell(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    width: deviceWidth(context),
                    height: deviceHeight(context) / 5,
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
                                Text(AppLocalizations.of(context)!.date,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),),
                                Text("$date,",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),),
                                Text(AppLocalizations.of(context)!.time,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),),
                                Text(
                                  '$time',
                                  style: TextStyle(
                                    fontSize: 20,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!.appointment_Number,style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Oxanium',
                                ),),
                                Text(
                                  ' ${appointment['appointmentNumber']}',
                                  style: TextStyle(
                                    fontSize: 20,
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
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.manage_Appointment,style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),),
                          content: Text(
                            AppLocalizations.of(context)!.what_would_you_like_to_do_with_this_appointment,style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                // Delete the appointment from Firestore
                                await FirebaseFirestore.instance
                                    .collection('appointments')
                                    .doc(appointment.id)
                                    .delete();
                                // Close the dialog
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context)!.delete,style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oxanium',
                              ),),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditAppointmentScreen(
                                            appointment: appointment),
                                  ),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.edit,style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oxanium',
                              ),),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context)!.cancel,style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oxanium',
                              ),),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddAppointmentPage()),
            );
          },
          backgroundColor: Colors.indigo[900],
          child: Icon(Icons.add, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_medical_record/screens/add_appointment.dart';
import 'package:personal_medical_record/screens/add_medication.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:personal_medical_record/screens/edit_appointmets.dart';
import 'package:personal_medical_record/screens/edit_medication.dart';

class MedicationsScreen extends StatefulWidget {
  @override
  _MedicationsScreenState createState() => _MedicationsScreenState();
}
double deviceHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double deviceWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

class _MedicationsScreenState extends State<MedicationsScreen> {
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
                            AppLocalizations.of(context)!.medications,
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
              .collection('medication')
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
              return Center(child: Text('No medications found'));
            }

            var medications = snapshot.data!.docs;

            // Sorting appointments by date/time
            medications.sort((a, b) {
              DateTime timeA = a['fromDate'].toDate();
              DateTime timeB = b['fromDate'].toDate();
              return timeA.compareTo(timeB);
            });

            return ListView.builder(
              itemCount: medications.length,
              itemBuilder: (context, index) {
                var medication = medications[index];
                DateTime fromDate = medication['fromDate'].toDate();
                DateTime toDate = medication['toDate'].toDate();
                String fromDateString =
                    '${fromDate.day}/${fromDate.month}/${fromDate.year}';
                String toDateString =
                    '${toDate.day}/${toDate.month}/${toDate.year}';
                return InkWell(
                  child: Container(
                    margin: EdgeInsets.all(10),
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
                              medication['medicationName'],
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
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.dose,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '${medication['dose'].toString()}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Text(
                              medication['unit'],
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
                                  AppLocalizations.of(context)!.from,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '$fromDateString',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.to,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '$toDateString',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                              ],
                            ),
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
                            AppLocalizations.of(context)!.medication_Details,
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
                                    Text(
                                      AppLocalizations.of(context)!.medication_Name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oxanium',
                                      ),
                                    ),
                                    Text(
                                      '${medication['medicationName']}',
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
                                      AppLocalizations.of(context)!.from,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oxanium',
                                      ),
                                    ),
                                    Text(
                                      '$fromDateString',
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
                                      AppLocalizations.of(context)!.to,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oxanium',
                                      ),
                                    ),
                                    Text(
                                      '$toDateString',
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
                                      AppLocalizations.of(context)!.dose,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oxanium',
                                      ),
                                    ),
                                    Text(
                                      '${medication['dose']}',
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
                                      AppLocalizations.of(context)!.unit,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oxanium',
                                      ),
                                    ),
                                    Text(
                                      '${medication['unit']}',
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
                                      AppLocalizations.of(context)!.schedule,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oxanium',
                                      ),
                                    ),
                                    Text(
                                      '${medication['schedule']}',
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
                                      AppLocalizations.of(context)!.description,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oxanium',
                                      ),
                                    ),
                                    Text(
                                      '${medication['description']}',
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
                                      AppLocalizations.of(context)!.illness,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oxanium',
                                      ),
                                    ),
                                    Text(
                                      '${medication['illness']}',
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
                          title: Text(AppLocalizations.of(context)!.manage_Medications,style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),),
                          content: Text(
                              AppLocalizations.of(context)!.what_would_you_like_to_do_with_this_medication,style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                // Delete the appointment from Firestore
                                await FirebaseFirestore.instance
                                    .collection('medication')
                                    .doc(medication.id)
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
                                        EditMedicationPage(
                                            medication: medication),
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
              MaterialPageRoute(builder: (context) => AddMedicationPage()),
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

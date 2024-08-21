import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_medical_record/screens/add_prescription.dart';
import 'package:personal_medical_record/screens/edit_prescription.dart';
import 'package:personal_medical_record/screens/prescription_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrescriptionScreen extends StatefulWidget {
  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

double deviceHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double deviceWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

class _PrescriptionScreenState extends State<PrescriptionScreen> {
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
                            AppLocalizations.of(context)!.prescription,
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
              .collection('prescription')
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
              return Center(child: Text('No prescriptions found'));
            }

            var prescriptions = snapshot.data!.docs;

            // Sorting prescriptions by date


            return ListView.builder(
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                var prescription = prescriptions[index];
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prescription['appointmentName'],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.date,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Oxanium',
                              ),
                            ),
                            Text(
                              '${prescription['appointmentDate']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Oxanium',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.appointment_Number,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Oxanium',
                              ),
                            ),
                            Text(
                              '${prescription['appointmentNumber']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Oxanium',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrescriptionDetailsPage(prescription: prescription),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.manage_Prescription, style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),),
                          content: Text(
                            AppLocalizations.of(context)!.what_would_you_like_to_do_with_this_prescription, style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                // Delete the prescription from Firestore
                                await FirebaseFirestore.instance
                                    .collection('prescription')
                                    .doc(prescription.id)
                                    .delete();
                                // Close the dialog
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(
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
                                    builder: (context) => EditPrescriptionPage(
                                      prescription: prescription,
                                    ),
                                  ),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.edit, style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oxanium',
                              ),),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(
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
              MaterialPageRoute(builder: (context) => AddPrescriptionPage()),
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

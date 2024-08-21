import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_medical_record/screens/add_illness.dart';
import 'package:personal_medical_record/screens/edit_illnesses.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IllnessesScreen extends StatefulWidget {
  @override
  _IllnessesScreenState createState() => _IllnessesScreenState();
}

class _IllnessesScreenState extends State<IllnessesScreen> {
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
                            AppLocalizations.of(context)!.illnesses,
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
              .collection('illness')
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
              return Center(child: Text('No illnesses found'));
            }

            var illnesses = snapshot.data!.docs;

            // Sorting illnesses by date
            illnesses.sort((a, b) {
              DateTime fromDateA = a['fromDate'].toDate();
              DateTime fromDateB = b['fromDate'].toDate();
              return fromDateB.compareTo(fromDateA);
            });

            return ListView.builder(
              itemCount: illnesses.length,
              itemBuilder: (context, index) {
                var illness = illnesses[index];
                DateTime fromDate = illness['fromDate'].toDate();
                DateTime toDate = illness['toDate'].toDate();
                String fromDateString =
                    '${fromDate.day}/${fromDate.month}/${fromDate.year}';
                String toDateString =
                    '${toDate.day}/${toDate.month}/${toDate.year}';

                return InkWell(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 9,
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
                              illness['healthIssueName'],
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
                            AppLocalizations.of(context)!.illness_Details,
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
                                      AppLocalizations.of(context)!.health_Issue_Name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oxanium',
                                      ),
                                    ),
                                    Text(
                                      '${illness['healthIssueName']}',
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
                                      AppLocalizations.of(context)!.description,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oxanium',
                                      ),
                                    ),
                                    Text(
                                      '${illness['description']}',
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
                          title: Text('Manage Illnesses',style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),),
                          content: Text(
                              'What would you like to do with this Illness?',style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                // Delete the appointment from Firestore
                                await FirebaseFirestore.instance
                                    .collection('illness')
                                    .doc(illness.id)
                                    .delete();
                                // Close the dialog
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete',style: TextStyle(
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
                                        EditIllnessScreen(
                                            illness: illness),
                                  ),
                                );
                              },
                              child: Text('Edit',style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oxanium',
                              ),),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel',style: TextStyle(
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
              MaterialPageRoute(builder: (context) => AddIllnessPage()),
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

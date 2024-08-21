import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/screens/add_symptoms.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SymptomsScreen extends StatefulWidget {
  @override
  _SymptomsScreenState createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
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
                            AppLocalizations.of(context)!.symptoms,
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
              .collection('symptoms')
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
              return Center(child: Text('No symptoms found'));
            }

            var symptoms = snapshot.data!.docs;

            // Sorting symptoms by date/time

            return ListView.builder(
              itemCount: symptoms.length,
              itemBuilder: (context, index) {
                var symptom = symptoms[index];
                DateTime dateTime = symptom['dateTime'].toDate();
                String date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                String time = '${dateTime.hour}:${dateTime.minute}';
                List<dynamic> symptomList = symptom['symptoms'];
                return InkWell(
                  child: Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          Column(
                            children: [
                              for (var item in symptomList)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${item['name']}: ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Oxanium',
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(3, (index) {
                                          return Container(
                                            margin: EdgeInsets.only(right: 8),
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Color(item['colors'][index]),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            height: 10,
                                            width: 30,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
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
                                  Text(
                                    AppLocalizations.of(context)!.illness,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Oxanium',
                                    ),
                                  ),
                                  Text(
                                    '${symptom['illness']}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Oxanium',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.indigo[900],
                          title: Text(
                            AppLocalizations.of(context)!.symptom_Details,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var item in symptomList)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)!.name,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Oxanium',
                                                    ),
                                                  ),
                                                  Text(
                                                    ' ${item['name']}',
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
                                                children: List.generate(3, (index) {
                                                  return Container(
                                                    margin: EdgeInsets.only(right: 4),
                                                    padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                      color: Color(item['colors'][index]),
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                    height: 5,
                                                    width: 15,
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(AppLocalizations.of(context)!.date,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Oxanium',
                                          ),),
                                        Text("$date,",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Oxanium',
                                          ),),
                                        Text(AppLocalizations.of(context)!.time,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Oxanium',
                                          ),),
                                        Text(
                                          '$time',
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
                                      '${symptom['description']}',
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
                                      ' ${symptom['illness']}',
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
                          title: Text(AppLocalizations.of(context)!.manage_Symptoms,style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),),
                          content: Text(
                            AppLocalizations.of(context)!.what_would_you_like_to_do_with_this_symptom,style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                          ),),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                // Delete the appointment from Firestore
                                await FirebaseFirestore.instance
                                    .collection('symptoms')
                                    .doc(symptom.id)
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
              MaterialPageRoute(builder: (context) => AddSymptomsPage()),
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

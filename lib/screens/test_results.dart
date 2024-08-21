import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_medical_record/screens/add_test_results.dart';
import 'package:personal_medical_record/screens/edit_test_results.dart';
import 'package:personal_medical_record/screens/test_results_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TestResultsScreen extends StatefulWidget {
  @override
  _TestResultsScreenState createState() => _TestResultsScreenState();
}
double deviceHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double deviceWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

class _TestResultsScreenState extends State<TestResultsScreen> {
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
      AppLocalizations.of(context)!.tests,
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
        .collection('test_results')
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
        return Center(child: Text('No test results found'));
      }

      var testResults = snapshot.data!.docs;

      // Sorting test results by date
      testResults.sort((a, b) {
        DateTime timeA = a['date'].toDate();
        DateTime timeB = b['date'].toDate();
        return timeA.compareTo(timeB);
      });

      return ListView.builder(
        itemCount: testResults.length,
        itemBuilder: (context, index) {
          var testResult = testResults[index];
          DateTime date = testResult['date'].toDate();
          String formattedDate = '${date.day}/${date.month}/${date.year}';
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
                        testResult['testName'],
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
                        testResult['testType'],
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
                      Text(
                        '$formattedDate',
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
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestResultDetailsPage(testResult: testResult),
                ),
              );
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.manage_Tests,style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oxanium',
                    ),),
                    content: Text(
                      AppLocalizations.of(context)!.what_would_you_like_to_do_with_this_test,style: TextStyle(
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
                              .collection('test_results')
                              .doc(testResult.id)
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
                              builder: (context) => EditTestResultsPage(
                                testResult: testResult,
                              ),
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
                MaterialPageRoute(builder: (context) => AddTestResultsPage()),
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


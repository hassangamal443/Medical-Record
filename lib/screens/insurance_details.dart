import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/screens/add_insurance.dart';
import 'package:personal_medical_record/widgets/circle_avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InsuranceDetailsPage extends StatefulWidget {
  const InsuranceDetailsPage({super.key});

  @override
  State<InsuranceDetailsPage> createState() => _InsuranceDetailsPageState();
}

class _InsuranceDetailsPageState extends State<InsuranceDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final currentUserUID = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(
        child: Scaffold(
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
                              AppLocalizations.of(context)!.insurance,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontFamily: 'Oxanium',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(context,MaterialPageRoute(builder: (context) =>AddInsurancePage()));
                              },
                            ),
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
                .collection('insurance')
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
                return Center(child: Text('No insurance found'));
              }

              var insurances = snapshot.data!.docs;

              return ListView.builder(
                itemCount: insurances.length,
                itemBuilder: (context, index) {
                  var insurance = insurances[index];
                  DateTime validDate = insurance['validDate'].toDate();
                  DateTime dateOfBirth = insurance['dateOfBirth'].toDate();
                  String validDateString =
                      '${validDate.day}/${validDate.month}/${validDate.year}';
                  String dateOfBirthString =
                      '${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}';

                  return Column(
                    children: [
                      CircleAvatar(
                          radius: 53.0,
                          backgroundColor: Colors.indigo[900],
                          child: CircleAvatarWidget(radius: 50)
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.65 ,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.full_name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '${insurance['fullName']}',
                                  style: TextStyle(
                                    fontSize: 20,
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
                                  AppLocalizations.of(context)!.iD2,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '${insurance['id']}',
                                  style: TextStyle(
                                    fontSize: 20,
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
                                  AppLocalizations.of(context)!.valid_until,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '$validDateString',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.date_Of_birth,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '$dateOfBirthString',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.company2,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '${insurance['company']}',
                                  style: TextStyle(
                                    fontSize: 20,
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
                                  AppLocalizations.of(context)!.network2,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '${insurance['network']}',
                                  style: TextStyle(
                                    fontSize: 20,
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
                                  AppLocalizations.of(context)!.medication1,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '${insurance['medication']}',
                                  style: TextStyle(
                                    fontSize: 20,
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
                                  AppLocalizations.of(context)!.maternity2,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '${insurance['maternity']}',
                                  style: TextStyle(
                                    fontSize: 20,
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
                                  AppLocalizations.of(context)!.dental2,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '${insurance['dental']}',
                                  style: TextStyle(
                                    fontSize: 20,
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
                                  AppLocalizations.of(context)!.vision2,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  '${insurance['vision']}',
                                  style: TextStyle(
                                    fontSize: 20,
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
                                  AppLocalizations.of(context)!.grade2,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oxanium',
                                  ),
                                ),
                                Text(
                                  'Grade: ${insurance['grade']}',
                                  style: TextStyle(
                                    fontSize: 20,
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
                    ],
                  );
                },
              );
            },
          ),
        )
    );
  }
}

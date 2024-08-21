import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_medical_record/screens/add_symptoms.dart';
import 'package:personal_medical_record/screens/appointments.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_medical_record/screens/bmi_calculator.dart';
import 'package:personal_medical_record/screens/illnesses.dart';
import 'package:personal_medical_record/screens/insurance_details.dart';
import 'package:personal_medical_record/screens/medications.dart';
import 'package:personal_medical_record/screens/prescription.dart';
import 'package:personal_medical_record/screens/symptoms.dart';
import 'package:personal_medical_record/screens/test_results.dart';
import 'package:personal_medical_record/widgets/retrieve_appointment.dart';
import 'package:personal_medical_record/widgets/username.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomeScreen extends StatelessWidget {
  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    final currentUserUID = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: Stack(
            children: [Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              width: deviceWidth(context),
              height: 400,
              decoration: BoxDecoration(
                color: Colors.indigo[600],
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.hi,
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontFamily: 'Oxanium',
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                UsernameWidget(fontSize: 25, color: Colors.white),
                              ],
                            ),
                            SizedBox()
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.welcome_Back,
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontFamily: 'Oxanium',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(9, 0, 9, 0),
                  height: deviceHeight(context) -390,
                  width: deviceWidth(context),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 10, 15, 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.categorys,
                                  style: TextStyle(
                                      fontFamily: 'Oxanium',
                                      fontSize: 20,
                                      color: Colors.indigo[900],
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 50,)
                              ],
                            ),
                            Container(
                              width: deviceWidth(context),
                              height: 125,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (context) =>AppointmentsScreen()));
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo[500],
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset('Images/doctor (2).png',
                                            height: 50,
                                          ),
                                          SizedBox(height: 10,),
                                          Text(AppLocalizations.of(context)!.appointments,
                                            style: TextStyle(
                                                fontFamily: 'Oxanium',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  TextButton(
                                    onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) =>MedicationsScreen()));},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo[500],
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset('Images/syringe (1).png',
                                            height: 50,
                                          ),
                                          SizedBox(height: 10,),
                                          Text(AppLocalizations.of(context)!.medications,
                                            style: TextStyle(
                                                fontFamily: 'Oxanium',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  TextButton(
                                    onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) =>TestResultsScreen()));},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo[500],
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset('Images/blood-analysis.png',
                                            height: 50,
                                          ),
                                          SizedBox(height: 10,),
                                          Text(AppLocalizations.of(context)!.tests,
                                            style: TextStyle(
                                                fontFamily: 'Oxanium',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  TextButton(
                                    onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) =>IllnessesScreen()));},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo[500],
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset('Images/coronavirus (1).png',
                                            height: 50,
                                          ),
                                          SizedBox(height: 10,),
                                          Text(AppLocalizations.of(context)!.illnesses,
                                            style: TextStyle(
                                                fontFamily: 'Oxanium',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  TextButton(
                                    onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) =>SymptomsScreen()));},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo[500],
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset('Images/symptoms.png',
                                            height: 50,
                                          ),
                                          SizedBox(height: 5,),
                                          Text(AppLocalizations.of(context)!.symptoms,
                                            style: TextStyle(
                                                fontFamily: 'Oxanium',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  TextButton(
                                    onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) =>PrescriptionScreen()));},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo[500],
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset('Images/prescription.png',
                                            height: 50,
                                          ),
                                          SizedBox(height: 5,),
                                          Text(AppLocalizations.of(context)!.prescription,
                                            style: TextStyle(
                                                fontFamily: 'Oxanium',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  TextButton(
                                    onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) =>InsuranceDetailsPage()));},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo[500],
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset('Images/health-insurance.png',
                                            height: 50,
                                          ),
                                          SizedBox(height: 5,),
                                          Text(AppLocalizations.of(context)!.insurance,
                                            style: TextStyle(
                                                fontFamily: 'Oxanium',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  TextButton(
                                    onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) =>BMICalculator()));},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo[500],
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset('Images/bmi.png',
                                            height: 50,
                                          ),
                                          SizedBox(height: 5,),
                                          Text(AppLocalizations.of(context)!.bmi,
                                            style: TextStyle(
                                                fontFamily: 'Oxanium',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 10, 15, 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.next_Appointment,
                                  style: TextStyle(
                                      fontFamily: 'Oxanium',
                                      fontSize: 20,
                                      color: Colors.indigo[900],
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 50,)
                              ],
                            ),
                            AppointmentDetailPage(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
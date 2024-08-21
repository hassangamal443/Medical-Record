import 'package:flutter/material.dart';
import 'package:personal_medical_record/recources/auth_methods.dart';
import 'package:personal_medical_record/screens/add_medication.dart';
import 'package:personal_medical_record/screens/appointments.dart';
import 'package:personal_medical_record/screens/bmi_calculator.dart';
import 'package:personal_medical_record/screens/illnesses.dart';
import 'package:personal_medical_record/screens/insurance_details.dart';
import 'package:personal_medical_record/screens/login_screen.dart';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:personal_medical_record/screens/medications.dart';
import 'package:personal_medical_record/screens/prescription.dart';
import 'package:personal_medical_record/screens/symptoms.dart';
import 'package:personal_medical_record/screens/test_results.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeaturesScreen extends StatelessWidget {
  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>AppointmentsScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: (deviceWidth(context) -50) /2,
                          height: (deviceHeight(context) -325) /3,
                          decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                          ),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.appointments,
                                style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.indigo[900]
                                ),
                              ),
                              SizedBox(height: 10,),
                              Image.asset('Images/doctor (2).png',
                                height: (deviceHeight(context) -536) /3,
                              )
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MedicationsScreen()),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: (deviceWidth(context) -50) /2,
                          height: (deviceHeight(context) -325) /3,
                          decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                          ),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.medications,
                                style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.indigo[900]
                                ),
                              ),
                              SizedBox(height: 10,),
                              Image.asset('Images/syringe (1).png',
                                height: (deviceHeight(context) -533) /3,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: (){Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TestResultsScreen()),
                        );},
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: (deviceWidth(context) -50) /2,
                          height: (deviceHeight(context) -325) /3,
                          decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                          ),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.tests,
                                style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.indigo[900]
                                ),
                              ),
                              SizedBox(height: 10,),
                              Image.asset('Images/blood-analysis.png',
                                height: (deviceHeight(context) -533) /3,
                              )
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) =>IllnessesScreen()));},
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: (deviceWidth(context) -50) /2,
                          height: (deviceHeight(context) -325) /3,
                          decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                          ),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.illnesses,
                                style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.indigo[900]
                                ),
                              ),
                              SizedBox(height: 10,),
                              Image.asset('Images/coronavirus (1).png',
                                height: (deviceHeight(context) -533) /3,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: (){Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SymptomsScreen()),
                        );},
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: (deviceWidth(context) -50) /2,
                          height: (deviceHeight(context) -325) /3,
                          decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                          ),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.symptoms,
                                style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.indigo[900]
                                ),
                              ),
                              SizedBox(height: 10,),
                              Image.asset('Images/symptoms.png',
                                height: (deviceHeight(context) -533) /3,
                              )
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: (){Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PrescriptionScreen()),
                        );},
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: (deviceWidth(context) -50) /2,
                          height: (deviceHeight(context) -325) /3,
                          decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                          ),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.prescription,
                                style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.indigo[900]
                                ),
                              ),
                              SizedBox(height: 10,),
                              Image.asset('Images/prescription.png',
                                height: (deviceHeight(context) -533) /3,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) =>InsuranceDetailsPage()));},
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: (deviceWidth(context) -50) /2,
                          height: (deviceHeight(context) -325) /3,
                          decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                          ),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.insurance,
                                style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.indigo[900]
                                ),
                              ),
                              SizedBox(height: 10,),
                              Image.asset('Images/health-insurance.png',
                                height: (deviceHeight(context) -533) /3,
                              )
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: (){Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BMICalculator()),
                        );},
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: (deviceWidth(context) -50) /2,
                          height: (deviceHeight(context) -325) /3,
                          decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                                BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                          ),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.bmi_Calculator,
                                style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.indigo[900]
                                ),
                              ),
                              SizedBox(height: 10,),
                              Image.asset('Images/bmi.png',
                                height: (deviceHeight(context) -536) /3,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
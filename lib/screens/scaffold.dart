import 'package:flutter/material.dart';
import 'package:personal_medical_record/main.dart';
import 'package:personal_medical_record/recources/auth_methods.dart';
import 'package:personal_medical_record/screens/appointments.dart';
import 'package:personal_medical_record/screens/bmi_calculator.dart';
import 'package:personal_medical_record/screens/features_screen.dart';
import 'package:personal_medical_record/screens/home_screen.dart';
import 'package:personal_medical_record/screens/illnesses.dart';
import 'package:personal_medical_record/screens/insurance_details.dart';
import 'package:personal_medical_record/screens/login_screen.dart';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:personal_medical_record/screens/medications.dart';
import 'package:personal_medical_record/screens/profile_screen.dart';
import 'package:personal_medical_record/screens/test_results.dart';
import 'package:personal_medical_record/widgets/circle_avatar.dart';
import 'package:personal_medical_record/widgets/email.dart';
import 'package:personal_medical_record/widgets/language_button.dart';
import 'package:personal_medical_record/widgets/username.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyScaffold extends StatefulWidget {
  const MyScaffold({Key? key}) : super(key: key);
  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;
  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;


  // Define the list of widgets to be shown in the bottom navigation bar.

  // This function is called when an item in the bottom navigation bar is tapped.



  @override

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    HomeScreen(),
    FeaturesScreen(),
    ProfileScreen(),
  ];

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[200],
          drawer: Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Drawer(
              width: 280,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(20),
                    left: Radius.circular(20),
                  )
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.list,
                          size: 30,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.inventory,
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Oxanium',
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                    width: 10.0,
                    child: Divider(

                      color: Colors.grey[350],
                    ),
                  ),
                  ListTile(
                      iconColor: Colors.grey[700],
                      textColor: Colors.grey[700],
                      leading: Icon(Icons.calendar_today),
                      title: Text(AppLocalizations.of(context)!.appointments,
                        style: TextStyle(
                          fontFamily: 'Oxanium',
                          fontWeight: FontWeight.bold,
                        ),),
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) =>AppointmentsScreen()));
                      }
                  ),
                  ListTile(
                    iconColor: Colors.grey[700],
                    textColor: Colors.grey[700],
                    leading: Icon(Icons.medication_outlined),
                    title: Text(AppLocalizations.of(context)!.medications,
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),),
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>MedicationsScreen()));
                    },
                  ),
                  ListTile(
                    iconColor: Colors.grey[700],
                    textColor: Colors.grey[700],
                    leading: Icon(Icons.document_scanner_outlined),
                    title: Text(AppLocalizations.of(context)!.tests,
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),),
                    onTap: ()  {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>TestResultsScreen()));
                    },
                  ),
                  ListTile(
                    iconColor: Colors.grey[700],
                    textColor: Colors.grey[700],
                    leading: Icon(Icons.coronavirus_outlined),
                    title: Text(
                      AppLocalizations.of(context)!.illnesses,
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: ()  {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>IllnessesScreen()));
                    },
                  ),
                  ListTile(
                    iconColor: Colors.grey[700],
                    textColor: Colors.grey[700],
                    leading: Icon(Icons.thermostat_auto),
                    title: Text(
                      AppLocalizations.of(context)!.symptoms,
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: ()  {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>IllnessesScreen()));
                    },
                  ),
                  ListTile(
                    iconColor: Colors.grey[700],
                    textColor: Colors.grey[700],
                    leading: Icon(Icons.document_scanner_rounded),
                    title: Text(
                      AppLocalizations.of(context)!.prescription,
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: ()  {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>IllnessesScreen()));
                    },
                  ),
                  ListTile(
                    iconColor: Colors.grey[700],
                    textColor: Colors.grey[700],
                    leading: Icon(Icons.scale_outlined),
                    title: Text(
                      AppLocalizations.of(context)!.bmi_Calculator,
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: ()  {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>BMICalculator()));
                    },
                  ),
                  ListTile(
                    iconColor: Colors.grey[700],
                    textColor: Colors.grey[700],
                    leading: Icon(Icons.person_pin_outlined),
                    title: Text(
                      AppLocalizations.of(context)!.insurance,
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: ()  {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>InsuranceDetailsPage()));
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Icon(Icons.language_outlined,
                        color: Colors.grey[700],),
                        LocaleToggleButton(),
                      ],
                    ),
                  ),
                  ListTile(
                    iconColor: Colors.grey[700],
                    textColor: Colors.grey[700],
                    leading: Icon(Icons.exit_to_app),
                    title: Text(AppLocalizations.of(context)!.logout,
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),),
                    onTap: () async{
                      await AuthMethods().signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen(),),);
                    },

                  ),
                  Container(
                    height: 90,
                    width: 280,
                    margin: EdgeInsets.only(left: 5, bottom: 5, right: 5,
                      top: (deviceHeight(context) -0)/40,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {

                          },
                          child: CircleAvatarWidget(radius: 20)
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              UsernameWidget(fontSize: 17, color: Colors.white),
                              EmailWidget(fontSize: 10, color: Colors.white60)
                            ],
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                        ],
                        color: Colors.indigo[800],
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/cover.jpg'))),
                  )
                ],
              ),
            ),
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(140.0), // Set the preferred height of your AppBar
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),]
              ),
              margin: EdgeInsets.all(10),
              child: AppBar(
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
                                AppLocalizations.of(context)!.medical_Record,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontFamily: 'Oxanium',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10,),
                              CircleAvatarWidget(radius: 20)
                            ],
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          ),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
                bottomBarPages.length, (index) => bottomBarPages[index]),
          ),
          bottomNavigationBar: (bottomBarPages.length <= maxCount)
              ? AnimatedNotchBottomBar(
            /// Provide NotchBottomBarController
            notchBottomBarController: _controller,
            color: Color(0xff331e9e),
            showLabel: false,
            shadowElevation: 2,
            kBottomRadius: 28.0,
            // notchShader: const SweepGradient(
            //   startAngle: 0,
            //   endAngle: pi / 2,
            //   colors: [Colors.red, Colors.green, Colors.orange],
            //   tileMode: TileMode.mirror,
            // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
            notchColor: Colors.white,

            /// restart app if you change removeMargins
            removeMargins: false,
            bottomBarWidth: 500,
            showShadow: true,
            durationInMilliSeconds: 300,
            elevation: 1,
            bottomBarItems: const [
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                ),
                activeItem: Icon(
                  Icons.home_outlined,
                  color: Color(0xff4434bd),
                ),
                itemLabel: 'Home',
              ),
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.space_dashboard_outlined,
                  color: Colors.white,
                ),
                activeItem: Icon(
                  Icons.space_dashboard_outlined,
                  color: Color(0xff4434bd),
                ),
                itemLabel: 'Features',
              ),
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.person_2_outlined,
                  color: Colors.white,
                ),
                activeItem: Icon(
                  Icons.person_2_outlined,
                  color: Color(0xff4434bd),
                ),
                itemLabel: 'Profile',
              ),
            ],
            onTap: (index) {
              /// perform action on tab change and to update pages you can update pages without pages
              log('current selected index $index');
              _pageController.jumpToPage(index);
            },
            kIconSize: 24.0,
          )
              : null,
        ));
  }
}


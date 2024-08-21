import 'package:flutter/material.dart';
import 'package:personal_medical_record/screens/appointments.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BMICalculator extends StatelessWidget {
  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: SafeArea(
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
                              AppLocalizations.of(context)!.bMI_Calculator,
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
          body: BMICalculatorScreen(),
        ),
      ),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  int height = 170;
  int weight = 70;
  int age = 20;
  bool isMaleSelected = true;
  double bmi = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMaleSelected = true;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isMaleSelected ? Colors.indigo : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: (deviceWidth(context)-20)/2,
                  height: (deviceWidth(context)-20)/2,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.male,
                      size: 100,
                      color: isMaleSelected ? Colors.white : Colors.blue,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMaleSelected = false;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isMaleSelected ? Colors.white : Colors.indigo,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: (deviceWidth(context)-20)/2,
                  height: (deviceWidth(context)-20)/2,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.female,
                      size: 100,
                      color: isMaleSelected ? Colors.pink : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: deviceHeight(context)/4,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.indigo[500],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.hEIGHT,
                style: TextStyle(
                    fontFamily: 'Oxanium',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    height.toString(),
                    style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.white
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.cm,
                    style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
              Slider(
                activeColor: Colors.white,
                value: height.toDouble(),
                min: 120,
                max: 220,
                onChanged: (newValue) {
                  setState(() {
                    height = newValue.round();
                  });
                },
              ),
            ],
          ),
        ),
        Row(
          children: [Container(
            decoration: BoxDecoration(
              color: Colors.indigo[500],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            margin: EdgeInsets.all(5),
            width: (deviceWidth(context)-15)/2,
            height: (deviceWidth(context)-15)/2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.wEIGHT,
                  style: TextStyle(
                      fontFamily: 'Oxanium',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weight.toString(),
                      style: TextStyle(
                          fontFamily: 'Oxanium',
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Colors.white
                      ),
                    ),
                    Text(
                    AppLocalizations.of(context)!.kg,
                      style: TextStyle(
                          fontFamily: 'Oxanium',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                        width: 50,
                        height: 50,
                        child: Icon(Icons.remove,color: Colors.indigo[900],),
                      ),
                      onTap: () {
                        setState(() {
                          if (weight > 30) weight--;
                        });
                      },
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                        width: 50,
                        height: 50,
                        child: Icon(Icons.add,color: Colors.indigo[900],),
                      ),
                      onTap: () {
                        setState(() {
                          if (weight < 150) weight++;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
            Container(
              width: (deviceWidth(context)-15)/2,
              height: (deviceWidth(context)-15)/2,
              decoration: BoxDecoration(
                color: Colors.indigo[500],
                borderRadius: BorderRadius.all(Radius.circular(20)),

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.aGE,
                    style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        age.toString(),
                        style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                          ),
                          width: 50,
                          height: 50,
                          child: Icon(Icons.remove,color: Colors.indigo[900],),
                        ),
                        onTap: () {
                          setState(() {
                            if (age > 1) age--;
                          });
                        },
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                          ),
                          width: 50,
                          height: 50,
                          child: Icon(Icons.add,color: Colors.indigo[900],),
                        ),
                        onTap: () {
                          setState(() {
                            if (age < 100) age++;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            calculateBMI();
            showBMIPopup(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.indigo[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5, offset: Offset(-1, 1)),]
            ),
            width: deviceWidth(context)-10,
            height: deviceHeight(context)/15,
            child: Center(
              child: Text(
                'CALCULATE',
                style: TextStyle(
                    fontFamily: 'Oxanium',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void calculateBMI() {
    // Formula to calculate BMI: weight (kg) / (height (m) * height (m))
    double heightInMeters = height / 100;
    bmi = weight / (heightInMeters * heightInMeters);
  }

  void showBMIPopup(BuildContext context) {
    String weightStatus;
    if (bmi <= 18) {
      weightStatus = "Underweight";
    } else if (bmi > 18 && bmi <= 24) {
      weightStatus = "Normal weight";
    } else if (bmi > 24 && bmi <= 30) {
      weightStatus = "Overweight";
    } else if (bmi > 30 && bmi <= 39) {
      weightStatus = "Obese";
    } else {
      weightStatus = "Severely obese";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.your_BMI,
            style: TextStyle(
              fontFamily: 'Oxanium',
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.your_BMI_is,
                style: TextStyle(
                  fontFamily: 'Oxanium',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              Text(
                "${bmi.toStringAsFixed(1)}",
                style: TextStyle(
                  fontFamily: 'Oxanium',
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.you_are,
                    style: TextStyle(
                      fontFamily: 'Oxanium',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    " $weightStatus",
                    style: TextStyle(
                      fontFamily: 'Oxanium',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.oK,
                style: TextStyle(
                  fontFamily: 'Oxanium',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

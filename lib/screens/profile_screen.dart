import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_medical_record/widgets/circle_avatar.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:personal_medical_record/widgets/username.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _ageController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  String _gender = '';
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        body: FutureBuilder(
          future: _getCurrentUser(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                return _buildProfileView(snapshot.data!);
              } else {
                return Text('Error: User not found.');
              }
            }
          },
        ),
      ),
    );
  }

  Future<User?> _getCurrentUser() async {
    return _auth.currentUser;
  }

  Widget _buildProfileView(User user) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _firestore.collection('profile').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var userData = snapshot.data?.data();
        if (userData == null) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [

                    CircleAvatar(
                        radius: 53.0,
                        backgroundColor: Colors.indigo[900],
                        child: CircleAvatarWidget(radius: 50)
                    ),
                    SizedBox(height: 10,),
                    UsernameWidget(fontSize: 30, color: Color(0xff1a074e),),

                    Text('Patiant',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oxanium',
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: (deviceWidth(context) -50) /2,
                      height: deviceHeight(context)/8,
                      decoration: BoxDecoration(
                          color: Colors.indigo[50],
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                      ),
                      child: Column(
                        children: [
                          Text('Age',
                            style: TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text('Null',
                            style: TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 25,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: (deviceWidth(context) -50) /2,
                      height: deviceHeight(context)/8,
                      decoration: BoxDecoration(
                          color: Colors.indigo[50],
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                      ),
                      child: Column(
                        children: [
                          Text('Gender',
                            style: TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text('Null',
                            style: TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 25,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: (deviceWidth(context) -50) /2,
                      height: deviceHeight(context)/8,
                      decoration: BoxDecoration(
                          color: Colors.indigo[50],
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                      ),
                      child: Column(
                        children: [
                          Text('Hight',
                            style: TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text('Null',
                            style: TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 25,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: (deviceWidth(context) -50) /2,
                      height: deviceHeight(context)/8,
                      decoration: BoxDecoration(
                          color: Colors.indigo[50],
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                      ),
                      child: Column(
                        children: [
                          Text('Weight',
                            style: TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text('Null',
                            style: TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 25,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog();
                        },
                      ),
                  ),
                  CircleAvatar(
                      radius: 53.0,
                      backgroundColor: Colors.indigo[900],
                      child: CircleAvatarWidget(radius: 50)
                  ),
                  SizedBox(height: 10,),
                  UsernameWidget(fontSize: 30, color: Color(0xff1a074e),),
                  Text(AppLocalizations.of(context)!.patiant,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oxanium',
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: (deviceWidth(context) -50) /2,
                    height: deviceHeight(context)/8,
                    decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                          BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                    ),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.age,
                          style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text('${userData['age'] ?? 'Null'}',
                          style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 25,
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: (deviceWidth(context) -50) /2,
                    height: deviceHeight(context)/8,
                    decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                          BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                    ),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.gender,
                          style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text('${userData['gender'] ?? 'Null'}',
                          style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 25,
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: (deviceWidth(context) -50) /2,
                    height: deviceHeight(context)/8,
                    decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                          BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                    ),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.hEIGHT,
                          style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text('${_convertHeight(userData['height'], _heightUnit)} $_heightUnit',
                          style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 25,
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: (deviceWidth(context) -50) /2,
                    height: deviceHeight(context)/8,
                    decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 2, blurRadius: 7, offset: Offset(3, -3)),
                          BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 7, offset: Offset(-3, 3)),]
                    ),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.wEIGHT,
                          style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text('${_convertWeight(userData['weight'], _weightUnit)} $_weightUnit',
                          style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 25,
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _convertHeight(String? value, String unit) {
    if (value == null || value.isEmpty) {
      return 'Null';
    }
    double height = double.parse(value.split(" ")[0]);
    if (unit == 'cm') {
      return height.toStringAsFixed(1);
    } else {
      return (height * 0.0328084).toStringAsFixed(1); // Convert cm to feet
    }
  }

  String _convertWeight(String? value, String unit) {
    if (value == null || value.isEmpty) {
      return 'Null';
    }
    double weight = double.parse(value.split(" ")[0]);
    if (unit == 'kg') {
      return weight.toStringAsFixed(1);
    } else {
      return (weight * 2.20462).toStringAsFixed(1); // Convert kg to lb
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.indigo[900],
              title: Text(AppLocalizations.of(context)!.edit_Profile,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Oxanium',
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Radio(
                          fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          value: AppLocalizations.of(context)!.male,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value as String;
                            });
                          },
                        ),
                        Text(AppLocalizations.of(context)!.male,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Oxanium',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Radio(
                          fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          value: AppLocalizations.of(context)!.female,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value as String;
                            });
                          },
                        ),
                        Text(AppLocalizations.of(context)!.female,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Oxanium',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    TextFieldInput(
                      hintText: AppLocalizations.of(context)!.enter_your_age,
                      textInputType: TextInputType.number,
                      textEditingController:  _ageController,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context)!.height,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Oxanium',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 100,
                          decoration: BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(30)),
                              color: Colors.white
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              value: _heightUnit,
                              onChanged: (value) {
                                setState(() {
                                  _heightUnit = value!;
                                });
                              },
                              items: ['cm', 'feet'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    TextFieldInput(
                      hintText: AppLocalizations.of(context)!.enter_your_height,
                      textInputType: TextInputType.number,
                      textEditingController:  _heightController,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context)!.weight,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Oxanium',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 100,
                          decoration: BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(30)),
                              color: Colors.white
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              value: _weightUnit,
                              onChanged: (value) {
                                setState(() {
                                  _weightUnit = value!;
                                });
                              },
                              items: ['kg', 'lb'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    TextFieldInput(
                      hintText: AppLocalizations.of(context)!.enter_your_weight,
                      textInputType: TextInputType.number,
                      textEditingController: _weightController,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Oxanium',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _saveProfile();
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.save,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Oxanium',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('profile').doc(user.uid).set({
        'gender': _gender,
        'age': _ageController.text,
        'height': '${_heightController.text} $_heightUnit',
        'weight': '${_weightController.text} $_weightUnit',
      });
      // Clear text controllers after saving
      _ageController.clear();
      _heightController.clear();
      _weightController.clear();
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}

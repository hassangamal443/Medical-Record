import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/screens/appointments.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddIllnessPage extends StatefulWidget {
  @override
  _AddIllnessPageState createState() => _AddIllnessPageState();
}

class _AddIllnessPageState extends State<AddIllnessPage> {
  final TextEditingController _healthIssueNameController =
  TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late DateTime _fromDate;
  late DateTime _toDate;
  bool _isButtonDisabled = true; // Initially, button is disabled

  @override
  void initState() {
    super.initState();
    _fromDate = DateTime.now();
    _toDate = DateTime.now();
  }

  Future<void> _addIllness() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Check if any field is empty
      if (_healthIssueNameController.text.isEmpty ||
          _descriptionController.text.isEmpty) {
        // Show error message and return
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill out all fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Reference to the illness collection
      CollectionReference illness =
      FirebaseFirestore.instance.collection('illness');

      // Add a new document with auto-generated ID
      await illness.add({
        'userId': userId,
        'healthIssueName': _healthIssueNameController.text,
        'description': _descriptionController.text,
        'fromDate': _fromDate,
        'toDate': _toDate,
      });

      // Navigate back after adding the illness
      Navigator.of(context).pop();

      // Show a snackbar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Illness added successfully!'),
        ),
      );

      // Clear the input fields after adding the illness
      _healthIssueNameController.clear();
      _descriptionController.clear();
    } catch (e) {
      // Handle any errors here
      print('Error adding illness: $e');
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
        _isButtonDisabled = false; // Enable the button after selecting the date
        _healthIssueNameController.text =
        "${_fromDate.day}/${_fromDate.month}/${_fromDate.year}";
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo[900],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(125.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            margin: EdgeInsets.all(10),
            child: AppBar(
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios,
                    color: Colors.indigo[900]),
                onPressed: () => Navigator.of(context).pop(),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.white,
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
                          AppLocalizations.of(context)!.add_Illness,
                            style: TextStyle(
                              color: Colors.indigo[900],
                              fontSize: 23,
                              fontFamily: 'Oxanium',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_the_name_of_your_health_issue,
                  textInputType: TextInputType.text,
                  textEditingController: _healthIssueNameController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_the_description,
                  textInputType: TextInputType.text,
                  textEditingController: _descriptionController,
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
                      width: (deviceWidth(context)-40)/2,
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        AppLocalizations.of(context)!.from_date,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Oxanium',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: (deviceWidth(context)-40)/2,
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        AppLocalizations.of(context)!.to_date,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Oxanium',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectFromDate(context),
                        child: IgnorePointer(
                          child: TextFieldInput(
                            hintText: AppLocalizations.of(context)!.from_Date,
                            textInputType: TextInputType.datetime,
                            textEditingController: TextEditingController(
                                text:
                                "${_fromDate.day}/${_fromDate.month}/${_fromDate.year}"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectToDate(context),
                        child: IgnorePointer(
                          child: TextFieldInput(
                            hintText: AppLocalizations.of(context)!.to_Date,
                            textInputType: TextInputType.datetime,
                            textEditingController: TextEditingController(
                                text:
                                "${_toDate.day}/${_toDate.month}/${_toDate.year}"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                TextButton(
                  onPressed: _isButtonDisabled ? null : _addIllness,
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(-1, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.add_Illness,
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Oxanium',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/screens/appointments.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddMedicationPage extends StatefulWidget {
  @override
  _AddMedicationPageState createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  final TextEditingController _medicationNameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  late String _selectedUnit;
  late String _selectedIllness = ''; // Initialize with an empty string
  late List<String> _illnesses;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  late DateTime _fromDate;
  late DateTime _toDate;
  bool _isButtonDisabled = true; // Initially, button is disabled

  // Define list of units
  List<String> _units = [
    'ampule (s)',
    'application (s)',
    'capsule (s)',
    'drop (s)',
    'gram (s)',
    'injection (s)',
    'milligram (s)',
    'milliliter (s)',
    'sachet (s)',
    'patch (es)',
    'piece (s)',
    'tablet (s)',
    'puff (s)',
    'spray (s)',
    'suppository (ies)',
    'tablespoon (s)',
    'teaspoon(s)',
    'unit (s)'
  ];

  @override
  void initState() {
    super.initState();
    _fromDate = DateTime.now();
    _toDate = DateTime.now();
    _selectedUnit = '';
    _illnesses = [];
    _fetchUserIllnesses(); // Initialize selected unit to empty string
  }

  Future<void> _fetchUserIllnesses() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('illness')
        .where('userId', isEqualTo: userId)
        .get();

    setState(() {
      _illnesses = querySnapshot.docs
          .map((doc) => doc['healthIssueName'] as String)
          .toList();
    });
  }

  Future<void> _addMedication() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Check if any field is empty
      if (_medicationNameController.text.isEmpty ||
          _doseController.text.isEmpty ||
          _selectedUnit.isEmpty ||
          _descriptionController.text.isEmpty ||
          _scheduleController.text.isEmpty ||
          _selectedIllness.isEmpty) {
        // Show error message and return
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill out all fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Reference to the medication collection
      CollectionReference medication =
      FirebaseFirestore.instance.collection('medication');

      // Add a new document with auto-generated ID
      await medication.add({
        'userId': userId,
        'illness': _selectedIllness, // Add selected illness to Firestore
        'medicationName': _medicationNameController.text,
        'dose': int.parse(_doseController.text),
        'unit': _selectedUnit,
        'description': _descriptionController.text,
        'schedule': _scheduleController.text,
        'fromDate': _fromDate,
        'toDate': _toDate,
      });

      // Navigate back after adding the medication
      Navigator.of(context).pop();

      // Show a snackbar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medication added successfully!'),
        ),
      );

      // Clear the input fields after adding the medication
      _medicationNameController.clear();
      _doseController.clear();
      _descriptionController.clear();
      _scheduleController.clear();
    } catch (e) {
      // Handle any errors here
      print('Error adding medication: $e');
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
                icon: new Icon(Icons.arrow_back_ios, color: Colors.indigo[900]),
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
                            AppLocalizations.of(context)!.add_Medication,
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
                DropdownButtonFormField<String>(
                  value: _selectedIllness.isEmpty ? null : _selectedIllness,
                  hint: Text(AppLocalizations.of(context)!.select_Illness,),
                  items: _illnesses.map((illness) {
                    return DropdownMenuItem(
                      value: illness,
                      child: Text(illness),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedIllness = value!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  dropdownColor: Colors.white,
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextFieldInput(
                          hintText: AppLocalizations.of(context)!.enter_the_dose,
                          textInputType: TextInputType.number,
                          textEditingController: _doseController,
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedUnit.isEmpty ? null : _selectedUnit,
                        hint: Text(AppLocalizations.of(context)!.select_Unit), // Hint text
                        items: _units.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedUnit = value!;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: AppLocalizations.of(context)!.select_Unit,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_the_name_of_the_medication,
                  textInputType: TextInputType.text,
                  textEditingController: _medicationNameController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_the_description,
                  textInputType: TextInputType.text,
                  textEditingController: _descriptionController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_the_schedule,
                  textInputType: TextInputType.text,
                  textEditingController: _scheduleController,
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 40) / 2,
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
                      width: (MediaQuery.of(context).size.width - 40) / 2,
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
                                text: "${_fromDate.day}/${_fromDate.month}/${_fromDate.year}"
                            ),
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
                                text: "${_toDate.day}/${_toDate.month}/${_toDate.year}"
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                TextButton(
                  onPressed: _isButtonDisabled ? null : _addMedication,
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
                        AppLocalizations.of(context)!.add_Medication,
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

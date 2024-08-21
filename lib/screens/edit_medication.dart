import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/screens/appointments.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditMedicationPage extends StatefulWidget {
  final DocumentSnapshot medication;

  EditMedicationPage({required this.medication});
  @override
  _EditMedicationPageState createState() => _EditMedicationPageState();
}

class _EditMedicationPageState extends State<EditMedicationPage> {
  late TextEditingController _medicationNameController;
  late TextEditingController _doseController;
  late String _selectedUnit;
  late String _selectedIllness; // Initialize with an empty string
  late List<String> _illnesses = [];
  late TextEditingController _descriptionController;
  late TextEditingController _scheduleController;
  late DateTime _fromDate;
  late DateTime _toDate;
  late List<String> _units;

  @override
  void initState() {
    super.initState();
    _medicationNameController = TextEditingController(text: widget.medication['medicationName']);
    _scheduleController = TextEditingController(text: widget.medication['schedule']);
    _doseController = TextEditingController(text: widget.medication['dose'].toString());
    _selectedIllness = widget.medication['illness'];
    _descriptionController = TextEditingController(text: widget.medication['description']);
    _selectedUnit = widget.medication['unit'];
    _units = ['ampule (s)',
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
      'unit (s)'];
    _fromDate = widget.medication['fromDate'].toDate();
    _illnesses = []; // Initialize with empty list
    _fetchUserIllnesses(); // Fetch user illnesses from Firestore
    _toDate = widget.medication['toDate'].toDate(); // Initialize selectedDateTime with appointment's dateTime
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
                            AppLocalizations.of(context)!.edits_Medication,
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
                  onPressed: _saveChanges,
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
                        AppLocalizations.of(context)!.save_Changes,
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

  void _saveChanges() async {
    try {
      await FirebaseFirestore.instance.collection('medication').doc(widget.medication.id).update({
        'medicationName': _medicationNameController.text,
        'dose': _doseController.text,
        'unit': _selectedUnit,
        'description': _descriptionController.text,
        'schedule': _scheduleController.text,
        'illness': _selectedIllness,
        'fromDate': _fromDate,
        'toDate': _toDate,
      });
      Navigator.of(context).pop(); // Close the edit illness screen
    } catch (e) {
      print('Error saving changes: $e');
      // Handle any errors here
    }
  }
}


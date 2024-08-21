import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddInsurancePage extends StatefulWidget {
  @override
  _AddInsurancePageState createState() => _AddInsurancePageState();
}

class _AddInsurancePageState extends State<AddInsurancePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  DateTime _validDate = DateTime.now();
  DateTime _dateOfBirth = DateTime.now();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _networkController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  bool _maternity = false;
  bool _dental = false;
  bool _vision = false;


  void initState() {
    super.initState();
    _dateOfBirth = DateTime.now();
    _validDate = DateTime.now();
  }

  Future<void> _selectValidDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _validDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _validDate) {
      setState(() {
        _validDate = picked;
      });
    }
  }
  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;

      });
    }
  }


  Future<void> _addInsurance() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Check if any field is empty
      if (_fullNameController.text.isEmpty ||
          _idController.text.isEmpty ||
          _companyController.text.isEmpty ||
          _networkController.text.isEmpty ||
          _medicationController.text.isEmpty ||
          _gradeController.text.isEmpty) {
        // Show error message and return
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill out all fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Reference to the insurance collection
      CollectionReference insurance =
      FirebaseFirestore.instance.collection('insurance');

      // Query to check if the document already exists for the user
      QuerySnapshot querySnapshot = await insurance
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update existing document
        await insurance.doc(querySnapshot.docs.first.id).update({
          'fullName': _fullNameController.text,
          'id': int.parse(_idController.text),
          'validDate': _validDate,
          'dateOfBirth': _dateOfBirth,
          'company': _companyController.text,
          'network': _networkController.text,
          'medication': int.parse(_medicationController.text),
          'maternity': _maternity,
          'dental': _dental,
          'vision': _vision,
          'grade': _gradeController.text,
        });
      } else {
        // Add a new document if not exists
        await insurance.add({
          'userId': userId,
          'fullName': _fullNameController.text,
          'id': int.parse(_idController.text),
          'validDate': _validDate,
          'dateOfBirth': _dateOfBirth,
          'company': _companyController.text,
          'network': _networkController.text,
          'medication': int.parse(_medicationController.text),
          'maternity': _maternity,
          'dental': _dental,
          'vision': _vision,
          'grade': _gradeController.text,
        });
      }

      Navigator.of(context).pop();

      // Show a snackbar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insurance details added successfully!'),
        ),
      );
    } catch (e) {
      // Handle any errors here
      print('Error adding/updating insurance: $e');
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
                            AppLocalizations.of(context)!.add_Insurance_Details,
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
                  hintText: AppLocalizations.of(context)!.full_Name,
                  textInputType: TextInputType.text,
                  textEditingController: _fullNameController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.iD,
                  textInputType: TextInputType.number,
                  textEditingController: _idController,
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.valid_Date,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Oxanium',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          InkWell(
                            onTap: () => _selectValidDate(context),
                            child: IgnorePointer(
                              child: TextFieldInput(
                                hintText: AppLocalizations.of(context)!.valid_date,
                                textInputType: TextInputType.datetime,
                                textEditingController: TextEditingController(
                                    text:
                                    "${_validDate.day}/${_validDate
                                        .month}/${_validDate.year}"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.date_of_Birth,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Oxanium',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          InkWell(
                            onTap: () => _selectDateOfBirth(context),
                            child: IgnorePointer(
                              child: TextFieldInput(
                                hintText: AppLocalizations.of(context)!.date_of_birth,
                                textInputType: TextInputType.datetime,
                                textEditingController: TextEditingController(
                                    text:
                                    "${_dateOfBirth.day}/${_dateOfBirth
                                        .month}/${_dateOfBirth.year}"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.company,
                  textInputType: TextInputType.text,
                  textEditingController: _companyController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.network,
                  textInputType: TextInputType.text,
                  textEditingController: _networkController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.medication,
                  textInputType: TextInputType.number,
                  textEditingController: _medicationController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.grade,
                  textInputType: TextInputType.text,
                  textEditingController: _gradeController,
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.maternity,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Checkbox(
                      value: _maternity,
                      onChanged: (value) {
                        setState(() {
                          _maternity = value!;
                        });
                      },
                      activeColor: Colors.white,
                      hoverColor: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dental,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Checkbox(
                      value: _dental,
                      onChanged: (value) {
                        setState(() {
                          _dental = value!;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.vision,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Oxanium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Checkbox(
                      value: _vision,
                      onChanged: (value) {
                        setState(() {
                          _vision = value!;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                InkWell(
                  onTap: _addInsurance,
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
                        AppLocalizations.of(context)!.add_insurance_Details,
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

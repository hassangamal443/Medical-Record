import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/screens/appointments.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditIllnessScreen extends StatefulWidget {
  final DocumentSnapshot illness;

  EditIllnessScreen({required this.illness});

  @override
  _EditIllnessScreenState createState() => _EditIllnessScreenState();
}

class _EditIllnessScreenState extends State<EditIllnessScreen> {
  late TextEditingController _healthIssueNameController;
  late TextEditingController _descriptionController;
  late DateTime _fromDate;
  late DateTime _toDate;

  @override
  void initState() {
    super.initState();
    _healthIssueNameController = TextEditingController(text: widget.illness['healthIssueName']);
    _descriptionController = TextEditingController(text: widget.illness['description']);
    _fromDate = widget.illness['fromDate'].toDate();
    _toDate = widget.illness['toDate'].toDate();
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
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.indigo[900]),
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
                            AppLocalizations.of(context)!.edit_Illness,
                            style: TextStyle(
                              color: Colors.indigo[900],
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_the_name_of_your_health_issue,
                  textInputType: TextInputType.text,
                  textEditingController:  _healthIssueNameController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_the_description,
                  textInputType: TextInputType.text,
                  textEditingController:  _descriptionController,
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
                        child: TextFieldInput(
                          hintText: AppLocalizations.of(context)!.from_Date,
                          textInputType: TextInputType.datetime,
                          textEditingController: TextEditingController(text: "${_fromDate.day}/${_fromDate.month}/${_fromDate.year}"),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectToDate(context),
                        child: TextFieldInput(
                          hintText: AppLocalizations.of(context)!.to_Date,
                          textInputType: TextInputType.datetime,
                          textEditingController: TextEditingController(text: "${_toDate.day}/${_toDate.month}/${_toDate.year}"),
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
      await FirebaseFirestore.instance.collection('illness').doc(widget.illness.id).update({
        'healthIssueName': _healthIssueNameController.text,
        'description': _descriptionController.text,
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddSymptomsPage extends StatefulWidget {
  @override
  _AddSymptomsPageState createState() => _AddSymptomsPageState();
}

class _AddSymptomsPageState extends State<AddSymptomsPage> {
  final TextEditingController _symptomNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  late String _selectedIllness = '';
  late List<String> _illnesses;
  List<String> _addedSymptoms = [];
  Map<String, List<Color>> _symptomColors = {};

  @override
  void initState() {
    super.initState();
    _illnesses = [];
    _fetchUserIllnesses();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
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

  void _addSymptom() {
    String symptomName = _symptomNameController.text.trim();
    if (symptomName.isNotEmpty) {
      setState(() {
        _addedSymptoms.add(symptomName);
        _symptomNameController.clear();
        _symptomColors[symptomName] = [Colors.white, Colors.white, Colors.white];
      });
    }
  }

  void _updateColor(String symptomName, int index) {
    setState(() {
      for (int i = 0; i <= index; i++) {
        _symptomColors[symptomName]![i] = index == 0 ? Colors.yellow :
        index == 1 ? Colors.orange : Colors.red;
      }
      if (index < 2) {
        for (int i = index + 1; i < 3; i++) {
          _symptomColors[symptomName]![i] = Colors.white;
        }
      }
    });
  }

  Future<void> _addSymptoms() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Check if any field is empty
      if (_addedSymptoms.isEmpty ||
          _selectedIllness.isEmpty ||
          _selectedDateTime == null ||
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

      // Reference to the symptoms collection
      CollectionReference symptoms =
      FirebaseFirestore.instance.collection('symptoms');

      // Prepare a map to store symptoms with their colors
      List<Map<String, dynamic>> symptomsWithColors = _addedSymptoms.map((symptomName) {
        return {
          'name': symptomName,
          'colors': _symptomColors[symptomName]!.map((color) => color.value).toList(),
        };
      }).toList();

      // Add symptoms to Firestore
      await symptoms.add({
        'userId': userId,
        'illness': _selectedIllness, // Add selected illness to Firestore
        'symptoms': symptomsWithColors,
        'description': _descriptionController.text,
        'dateTime': _selectedDateTime,
      });

      // Navigate back after adding the symptoms
      Navigator.of(context).pop();

      // Show a snackbar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Symptoms added successfully!'),
        ),
      );

      // Clear the input fields after adding the symptoms
      _descriptionController.clear();
      setState(() {
        _addedSymptoms.clear();
        _symptomColors.clear();
      });
    } catch (e) {
      // Handle any errors here
      print('Error adding symptoms: $e');
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
                            AppLocalizations.of(context)!.add_Symptoms,
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
                      child: TextFieldInput(
                        hintText: AppLocalizations.of(context)!.enter_the_symptom_name,
                        textInputType: TextInputType.text,
                        textEditingController: _symptomNameController,
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addSymptom,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                if (_addedSymptoms.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.added_Symptoms,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _addedSymptoms.length,
                        itemBuilder: (context, index) {
                          String symptomName = _addedSymptoms[index];
                          List<Color> colors = _symptomColors[symptomName]!;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  width: 200,
                                  child: Center(
                                    child: Text(
                                      symptomName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: List.generate(3, (i) {
                                    return InkWell(
                                      onTap: () => _updateColor(symptomName, i),
                                      child: Container(
                                        height: 10,
                                        width: 30,
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: colors[i],
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0), // Adjust the value as needed
                    // Add border to match the DropdownButtonFormField style
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.date_Time,),
                              Text(
                                '${_selectedDateTime != null ? "${_selectedDateTime.year}-${_selectedDateTime.month}-${_selectedDateTime.day} ${_selectedDateTime.hour}:${_selectedDateTime.minute}" : "Select a Date & Time"}',
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectDateTime(context),
                          child: Text(AppLocalizations.of(context)!.selectDate_Time),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_the_description,
                  textInputType: TextInputType.text,
                  textEditingController: _descriptionController,
                ),
                SizedBox(height: 30.0),
                TextButton(
                  onPressed: _addSymptoms,
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
                        AppLocalizations.of(context)!.add_Symptoms,
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

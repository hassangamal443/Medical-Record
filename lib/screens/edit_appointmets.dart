import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditAppointmentScreen extends StatefulWidget {
  final DocumentSnapshot appointment;

  EditAppointmentScreen({required this.appointment});

  @override
  _EditAppointmentScreenState createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  late TextEditingController _doctorNameController;
  late TextEditingController _placeController;
  late TextEditingController _purposeController;
  late String _selectedDoctorType;
  late List<String> _doctorTypes;
  late DateTime _selectedDateTime;
  late TextEditingController _appointmentNumber;

  @override
  void initState() {
    super.initState();
    _doctorNameController = TextEditingController(text: widget.appointment['doctorName']);
    _placeController = TextEditingController(text: widget.appointment['place']);
    _purposeController = TextEditingController(text: widget.appointment['purpose']);
    _selectedDoctorType = widget.appointment['doctorType'];
    _doctorTypes = ['General Physician', 'Dentist', 'Dermatologist', 'Pediatrician'];
    _selectedDateTime = widget.appointment['dateTime'].toDate();
    _appointmentNumber = TextEditingController(text: widget.appointment['appointmentNumber'].toString());// Assume appointment number is stored in Firestore
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
                  bottomLeft: Radius.circular(30)),
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
                            AppLocalizations.of(context)!.edit_Appointments,
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
                  hintText: AppLocalizations.of(context)!.enter_doctors_name,
                  textInputType: TextInputType.text,
                  textEditingController:  _doctorNameController,
                ),

                SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.white
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedDoctorType.isEmpty ? null : _selectedDoctorType,
                    items: _doctorTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDoctorType = value!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 0),
                        borderRadius: BorderRadius.circular(30.0), // Adjust the value as needed
                      ),
                    ),
                    dropdownColor: Colors.white, // Set the background color to white
                  ),
                ),
                SizedBox(height: 10.0),
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
                          child: Text(AppLocalizations.of(context)!.selectDate_Time,),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_the_location,
                  textInputType: TextInputType.text,
                  textEditingController:  _placeController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_the_purpose_of_the_visit,
                  textInputType: TextInputType.text,
                  textEditingController:  _purposeController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_appointment_number,
                  textInputType: TextInputType.number,
                  textEditingController:  _appointmentNumber,
                ),
                SizedBox(height: 20.0),
                TextButton(onPressed: _saveChanges,
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5, offset: Offset(-1, 1)),]
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.save_Changes,
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oxanium',
                              fontSize: 15
                          ),
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
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

  void _saveChanges() async {
    try {
      await FirebaseFirestore.instance.collection('appointments').doc(widget.appointment.id).update({
        'doctorName': _doctorNameController.text,
        'place': _placeController.text,
        'purpose': _purposeController.text,
        'doctorType': _selectedDoctorType,
        'dateTime': _selectedDateTime,
        'appointmentNumber': _appointmentNumber.text,
      });
      Navigator.of(context).pop();
    } catch (e) {
      print('Error saving changes: $e');
    }
  }
}

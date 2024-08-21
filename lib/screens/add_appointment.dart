import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_medical_record/screens/appointments.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class AddAppointmentPage extends StatefulWidget {
  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final TextEditingController _doctorNameController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  String _selectedDoctorType = 'General Physician';
  List<String> _doctorTypes = [
    'General Physician',
    'Dentist',
    'Dermatologist',
    'Pediatrician'
  ];
  final TextEditingController _appointmentNumberController = TextEditingController();

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

  Future<void> _addAppointment() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      if (_doctorNameController.text.isEmpty ||
          _placeController.text.isEmpty ||
          _purposeController.text.isEmpty ||
          _selectedDateTime == null ||
          _selectedDoctorType.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill out all fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

      var docRef = await appointments.add({
        'userId': userId,
        'doctorName': _doctorNameController.text,
        'dateTime': _selectedDateTime,
        'place': _placeController.text,
        'purpose': _purposeController.text,
        'doctorType': _selectedDoctorType,
        'appointmentNumber': _appointmentNumberController.text,
      });

      await _scheduleNotification(docRef.id);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment added successfully!'),
        ),
      );

      _doctorNameController.clear();
      _placeController.clear();
      _purposeController.clear();
      _appointmentNumberController.clear();
    } catch (e) {
      print('Error adding appointment: $e');
    }
  }

  Future<void> _scheduleNotification(String appointmentId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No authenticated user. Notification not scheduled.');
        return;
      }
      String userId = user.uid;

      print('Current User ID: $userId');

      DocumentSnapshot appointmentSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (appointmentSnapshot.exists) {
        String appointmentUserId = appointmentSnapshot['userId'];
        print('Appointment User ID: $appointmentUserId');

        if (appointmentUserId == userId) {
          print('Scheduling notification for appointment ID: $appointmentId');
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: appointmentId.hashCode,
              channelKey: 'key1',
              title: 'You have an appointment',
              body: 'Doctor: ${_doctorNameController.text}, Type: $_selectedDoctorType',
              payload: {'userId': userId}, // Include user ID in payload
            ),
            schedule: NotificationCalendar.fromDate(date: _selectedDateTime),
          );
        } else {
          print('Appointment does not belong to the current user. Notification not scheduled.');
        }
      } else {
        print('Appointment document does not exist. Notification not scheduled.');
      }
    } catch (e) {
      print('Error scheduling notification: $e');
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
                            AppLocalizations.of(context)!.add_Appointments,
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
            textEditingController: _doctorNameController,
          ),

          SizedBox(height: 10.0),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.white),
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
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              dropdownColor: Colors.white,
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
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
                    textEditingController: _placeController,
                  ),
                  SizedBox(height: 10.0),
                  TextFieldInput(
                    hintText: AppLocalizations.of(context)!.enter_the_purpose_of_the_visit,
                    textInputType: TextInputType.text,
                    textEditingController: _purposeController,
                  ),
                  SizedBox(height: 10.0),
                  TextFieldInput(
                    hintText: AppLocalizations.of(context)!.enter_appointment_number,
                    textInputType: TextInputType.number,
                    textEditingController: _appointmentNumberController,
                  ),
                  SizedBox(height: 30.0),
                  TextButton(
                    onPressed: _addAppointment,
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
                          AppLocalizations.of(context)!.add_Appointment,
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxanium',
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
            ),
          ),
        ),
      ),
    );
  }
}
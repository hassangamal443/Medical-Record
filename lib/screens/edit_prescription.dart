import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditPrescriptionPage extends StatefulWidget {
  final DocumentSnapshot prescription;

  const EditPrescriptionPage({Key? key, required this.prescription}) : super(key: key);

  @override
  State<EditPrescriptionPage> createState() => _EditPrescriptionPageState();
}

class _EditPrescriptionPageState extends State<EditPrescriptionPage> {
  late String _selectedAppointmentId;
  late String _selectedAppointmentName;
  late String _selectedAppointmentDate;
  late String _selectedAppointmentNumber;
  late List<String> _appointmentsId;
  late List<String> _appointmentsName;
  late List<String> _appointmentsDate;
  late List<String> _appointmentsNumbers;
  List<XFile> _prescriptionImages = [];
  late List<String> _prescriptionImagesUrls = [];
  bool _updatingPrescription = false;

  @override
  void initState() {
    super.initState();
    _appointmentsId = [];
    _appointmentsName = [];
    _appointmentsDate = [];
    _appointmentsNumbers = [];
    _fetchUserAppointments();
    _selectedAppointmentId = widget.prescription['appointmentId'];
    _selectedAppointmentName = widget.prescription['appointmentName'];
    _selectedAppointmentDate = widget.prescription['appointmentDate'];
    _selectedAppointmentNumber = widget.prescription['appointmentNumber'];
    _prescriptionImagesUrls = List<String>.from(widget.prescription['images']);
  }

  Future<void> _fetchUserAppointments() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .get();

    setState(() {
      _appointmentsId = querySnapshot.docs
          .map((doc) => doc.id as String)
          .toList();
      _appointmentsName = querySnapshot.docs
          .map((doc) => doc['doctorName'] as String)
          .toList();
      _appointmentsDate = querySnapshot.docs
          .map((doc) => (doc['dateTime'] as Timestamp).toDate().toString())
          .toList();
      _appointmentsNumbers = querySnapshot.docs
          .map((doc) => doc['appointmentNumber'] as String)
          .toList();
    });
  }

  Future<void> _updatePrescription() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      if (_selectedAppointmentName.isEmpty || _prescriptionImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill out all fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _updatingPrescription = true;
      });

      CollectionReference prescription =
      FirebaseFirestore.instance.collection('prescription');

      List<String> imageUrls = [];
      for (XFile image in _prescriptionImages) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('prescription_images/$fileName');
        UploadTask uploadTask = ref.putFile(File(image.path));
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      await prescription.doc(widget.prescription.id).update({
        'userId': userId,
        'appointmentId': _selectedAppointmentId,
        'appointmentName': _selectedAppointmentName,
        'appointmentDate': _selectedAppointmentDate,
        'appointmentNumber': _selectedAppointmentNumber,
        'images': imageUrls,
      });

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prescription updated successfully!'),
        ),
      );

      setState(() {
        _prescriptionImages.clear();
        _updatingPrescription = false;
      });
    } catch (e) {
      print('Error updating prescription: $e');
      setState(() {
        _updatingPrescription = false;
      });
    }
  }

  Future<void> _addPrescriptionImages() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _prescriptionImages.add(pickedFile);
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
                            AppLocalizations.of(context)!.edit_Prescription,
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
                DropdownButtonFormField<String>(
                  value: _selectedAppointmentId.isEmpty ? null : _selectedAppointmentId,
                  hint: Text(AppLocalizations.of(context)!.select_Appointment,),
                  items: _appointmentsId.map((appointmentId) {
                    int index = _appointmentsId.indexOf(appointmentId);
                    return DropdownMenuItem(
                      value: appointmentId,
                      child: Text('${_appointmentsName[index]} - Appointment Number: ${_appointmentsNumbers[index]}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    int index = _appointmentsId.indexOf(value!);
                    setState(() {
                      _selectedAppointmentId = value;
                      _selectedAppointmentName = _appointmentsName[index];
                      _selectedAppointmentDate = _appointmentsDate[index];
                      _selectedAppointmentNumber = _appointmentsNumbers[index];
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
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _selectedAppointmentDate,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addPrescriptionImages,
                  child: Text(AppLocalizations.of(context)!.add_Prescription_Images,),
                ),
                SizedBox(height: 10),
                _prescriptionImagesUrls.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _prescriptionImagesUrls.map((image) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: image.startsWith('http')
                          ? Image.network(image)
                          : Image.file(File(image)), // Display local image file
                    );
                  }).toList(),
                )
                    : Container(),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _updatePrescription,
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
                      child: _updatingPrescription
                          ? CircularProgressIndicator(
                        color: Colors.indigo,
                      )
                          : Text(
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
}

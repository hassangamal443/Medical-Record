import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPrescriptionPage extends StatefulWidget {
  const AddPrescriptionPage({Key? key}) : super(key: key);

  @override
  State<AddPrescriptionPage> createState() => _AddPrescriptionPageState();
}

class _AddPrescriptionPageState extends State<AddPrescriptionPage> {
  late String _selectedAppointmentId = ''; // Initialize with an empty string
  late String _selectedAppointmentName = ''; // Initialize with an empty string
  late String _selectedAppointmentDate = ''; // Initialize with an empty string
  late List<String> _appointmentsId;
  late List<String> _appointmentsName;
  late List<String> _appointmentsDate;
  late List<String> _appointmentsNumbers;
  List<XFile> _prescriptionImages = []; // List to store prescription images
  bool _addingPrescription = false; // Flag to track adding prescription state

  @override
  void initState() {
    super.initState();
    _appointmentsId = [];
    _appointmentsName = [];
    _appointmentsDate = [];
    _appointmentsNumbers = [];
    _fetchUserAppointments();
  }

  Future<void> _fetchUserAppointments() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .get();

    setState(() {
      _appointmentsId = querySnapshot.docs
          .map((doc) => doc.id as String) // Store appointment document IDs
          .toList();
      _appointmentsName = querySnapshot.docs
          .map((doc) => doc['doctorName'] as String)
          .toList();
      _appointmentsDate = querySnapshot.docs
          .map((doc) =>
          (doc['dateTime'] as Timestamp).toDate().toString())
          .toList();
      _appointmentsNumbers = querySnapshot.docs
          .map((doc) => doc['appointmentNumber'] as String)
          .toList();
    });
  }

  Future<void> _addPrescription() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Check if any field is empty
      if (_selectedAppointmentName.isEmpty ||
          _prescriptionImages.isEmpty) {
        // Show error message and return
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill out all fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Set adding prescription state to true
      setState(() {
        _addingPrescription = true;
      });

      // Reference to the prescription collection
      CollectionReference prescription =
      FirebaseFirestore.instance.collection('prescription');

      // Upload images to Firebase Storage and get their download URLs
      List<String> imageUrls = [];
      for (XFile image in _prescriptionImages) {
        // Generate a unique filename for the image
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        // Upload image to Firebase Storage
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('prescription_images/$fileName');
        UploadTask uploadTask = ref.putFile(File(image.path));
        // Get download URL for the image
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        // Add image URL to the list
        imageUrls.add(imageUrl);
      }

      // Add a new document with auto-generated ID
      await prescription.add({
        'userId': userId,
        'appointmentId': _selectedAppointmentId, // Store appointment ID
        'appointmentName': _selectedAppointmentName,
        'appointmentDate': _selectedAppointmentDate,
        'appointmentNumber': _appointmentsNumbers[_appointmentsName.indexOf(_selectedAppointmentName)], // Store appointment number
        'images': imageUrls,
      });

      // Navigate back after adding the prescription
      Navigator.of(context).pop();

      // Show a snackbar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prescription added successfully!'),
        ),
      );

      setState(() {
        _prescriptionImages.clear();
        _addingPrescription = false; // Reset adding prescription state
      });

      // Clear the input fields after adding the prescription
    } catch (e) {
      // Handle any errors here
      print('Error adding prescription: $e');
      // Set adding prescription state to false
      setState(() {
        _addingPrescription = false;
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
                            AppLocalizations.of(context)!.add_Prescription,
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
                  value: _selectedAppointmentId.isEmpty
                      ? null
                      : _selectedAppointmentId,
                  hint: Text(
                    AppLocalizations.of(context)!.select_Appointment,
                  ),
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
                _prescriptionImages.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _prescriptionImages
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    XFile image = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Stack(
                        children: [
                          Image.file(File(image.path)),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _prescriptionImages.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
                    : Container(),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _addPrescription,
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
                      child: _addingPrescription
                          ? CircularProgressIndicator(
                        color: Colors.indigo,
                      )
                          : Text(
                        AppLocalizations.of(context)!.add_Prescription,
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

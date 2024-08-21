import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTestResultsPage extends StatefulWidget {
  const AddTestResultsPage({super.key});

  @override
  State<AddTestResultsPage> createState() => _AddTestResultsPageState();
}

class _AddTestResultsPageState extends State<AddTestResultsPage> {
  final TextEditingController _testNameController = TextEditingController();
  final TextEditingController _testTypeController = TextEditingController();
  List<XFile> _testImages = []; // List to store images of the test
  DateTime _selectedDate = DateTime.now(); // Initialize with non-null value

  Future<void> _addTestResults() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Check if any field is empty
      if (_testNameController.text.isEmpty ||
          _testTypeController.text.isEmpty ||
          _testImages.isEmpty ||
          _selectedDate == null) {
        // Show error message and return
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill out all fields and add at least one image'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Reference to the test results collection
      CollectionReference testResults =
      FirebaseFirestore.instance.collection('test_results');

      // Upload images to Firebase Storage and get their download URLs
      List<String> imageUrls = [];
      for (XFile image in _testImages) {
        // Generate a unique filename for the image
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        // Upload image to Firebase Storage
        Reference ref = FirebaseStorage.instance.ref().child('test_images/$fileName');
        UploadTask uploadTask = ref.putFile(File(image.path));
        // Get download URL for the image
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        // Add image URL to the list
        imageUrls.add(imageUrl);
      }

      // Add a new document with auto-generated ID
      await testResults.add({
        'userId': userId,
        'testName': _testNameController.text,
        'testType': _testTypeController.text,
        'testImages': imageUrls,
        'date': _selectedDate,
      });

      Navigator.of(context).pop();
      // Show a snackbar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Test results added successfully!'),
        ),
      );

      // Clear the input fields after adding the test results
      _testNameController.clear();
      _testTypeController.clear();
      setState(() {
        _testImages.clear();
      });
    } catch (e) {
      // Handle any errors here
      print('Error adding test results: $e');
    }
  }

  Future<void> _addTestImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _testImages.add(pickedFile);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
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
                            AppLocalizations.of(context)!.add_Tests,
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
                  hintText: AppLocalizations.of(context)!.enter_test_name,
                  textInputType: TextInputType.text,
                  textEditingController: _testNameController,
                ),
                SizedBox(height: 10.0),
                TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_test_type,
                  textInputType: TextInputType.text,
                  textEditingController: _testTypeController,
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 50, // or any appropriate height
                  child: Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: IgnorePointer(
                        child: TextFieldInput(
                          hintText: "Select Date: ${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
                          textInputType: TextInputType.datetime,
                          textEditingController: TextEditingController(
                            text: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _addTestImages,
                  child: Text(AppLocalizations.of(context)!.add_Test_Images,),
                ),
                SizedBox(height: 10.0),
                _testImages.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _testImages.asMap().entries.map((entry) {
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
                                  _testImages.removeAt(index);
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
                SizedBox(height: 30.0),
                TextButton(
                  onPressed: _addTestResults,
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
                        AppLocalizations.of(context)!.add_Tests,
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
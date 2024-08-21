import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTestResultsPage extends StatefulWidget {
  final DocumentSnapshot testResult;

  const EditTestResultsPage({Key? key, required this.testResult}) : super(key: key);

  @override
  State<EditTestResultsPage> createState() => _EditTestResultsPageState();
}

class _EditTestResultsPageState extends State<EditTestResultsPage> {
  late TextEditingController _testNameController;
  late TextEditingController _testTypeController;
  late DateTime _selectedDate; // New variable to hold selected DateTime
  late List<XFile> _testImages = []; // List to store images of the test
  late List<String> _testImagesUrls = []; // List to hold local paths of test images
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _testNameController = TextEditingController(text: widget.testResult['testName']);
    _testTypeController = TextEditingController(text: widget.testResult['testType']);
    _selectedDate = widget.testResult['date'].toDate();
    _testImagesUrls = List<String>.from(widget.testResult['testImages']);
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
                            AppLocalizations.of(context)!.edit_Tests,
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
                _testImagesUrls.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _testImagesUrls.map((image) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: image.startsWith('http')
                          ? Image.network(image)
                          : Image.file(File(image)), // Display local image file
                    );
                  }).toList(),
                )
                    : Container(),
                SizedBox(height: 30.0),
                _isSaving
                    ? Center(child: CircularProgressIndicator())
                    : TextButton(
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

  Future<void> _addTestImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _testImages.add(pickedFile);
        _testImagesUrls.add(pickedFile.path); // Add local file path
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      List<String> newImageUrls = [];

      // Upload new images to Firebase Storage and get their download URLs
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
        newImageUrls.add(imageUrl);
      }

      // Update test results in Firestore only if there are new images
      if (newImageUrls.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('test_results')
            .doc(widget.testResult.id)
            .update({
          'userId': userId,
          'testName': _testNameController.text,
          'testType': _testTypeController.text,
          'date': _selectedDate,
          'testImages': FieldValue.arrayUnion(newImageUrls),
        });
      } else {
        // If there are no new images, update other fields only
        await FirebaseFirestore.instance
            .collection('test_results')
            .doc(widget.testResult.id)
            .update({
          'userId': userId,
          'testName': _testNameController.text,
          'testType': _testTypeController.text,
          'date': _selectedDate,
        });
      }

      Navigator.of(context).pop(); // Close the edit test results screen
    } catch (e) {
      print('Error saving changes: $e');
      // Handle any errors here
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
}

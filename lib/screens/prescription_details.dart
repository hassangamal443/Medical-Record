import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrescriptionDetailsPage extends StatelessWidget {
  final DocumentSnapshot prescription;

  const PrescriptionDetailsPage({Key? key, required this.prescription})
      : super(key: key);

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
                            AppLocalizations.of(context)!.prescription_Details,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.appointment_Name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oxanium',
                    ),
                  ),
                  Text(
                    '${prescription['appointmentName']}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oxanium',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.date,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oxanium',
                    ),
                  ),
                  Text(
                    '${DateTime.parse(prescription['appointmentDate']).toString()}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oxanium',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.appointment_Number,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oxanium',
                    ),
                  ),
                  Text(
                    '${prescription['appointmentNumber']}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oxanium',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.prescription_Images,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oxanium',
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: prescription['images'].length,
                  itemBuilder: (context, index) {
                    String imageUrl = prescription['images'][index];
                    return ListTile(
                      title: Image.network(imageUrl),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

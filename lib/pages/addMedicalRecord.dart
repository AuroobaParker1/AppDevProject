import 'dart:io';
import 'dart:math';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_block.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_event.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_states.dart';
import 'package:aap_dev_project/core/repository/medicalRecords_repo.dart';
import 'package:aap_dev_project/models/report.dart';
import 'package:aap_dev_project/pages/appDrawer.dart';
import 'package:aap_dev_project/pages/bottomNavigationBar.dart';
import 'package:aap_dev_project/pages/dashboard.dart';
import 'package:aap_dev_project/pages/viewMedicalRecords.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddReport extends StatefulWidget {
  const AddReport({Key? key}) : super(key: key);

  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  File? _selectedImage;

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });

      // Navigate to the other page to display the selected image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DisplaySelectedImage(selectedImage: _selectedImage!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        bottomNavigationBar: BaseMenuBar(),
        body: Column(children: [
          Container(
  padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 0),
  width: double.infinity,
  height: MediaQuery.of(context).size.height * 0.3,
  decoration: const BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(50.0),
      bottomRight: Radius.circular(50.0),
    ),
    color: Color(0xFF01888B),
  ),
  child: Stack(
    alignment: Alignment.center,
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => DashboardApp()),
  ModalRoute.withName('/'),
),
          ),
        ),
      ),
      const Text(
        'Add A Report',
        style: TextStyle(
          fontSize: 36.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ],
  ),
),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          SizedBox(
              child: Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(
                              0xFF01888B), // Choose your desired color
                          width: 5.0, // Choose the width of the border
                        ),
                        borderRadius: BorderRadius.circular(
                            8.0), // Optional: Add border radius
                      ),
                      child: GestureDetector(
                          onTap: () {
                            _getImage(ImageSource
                                .camera); // Option 1: Click a picture
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/camera.png',
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(height: 20),
                              const Text('Take Picture',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ))),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(
                              0xFF01888B), // Choose your desired color
                          width: 5.0, // Choose the width of the border
                        ),
                        borderRadius: BorderRadius.circular(
                            8.0), // Optional: Add border radius
                      ),
                      child: GestureDetector(
                          onTap: () {
                            _getImage(ImageSource.gallery);
                          },
                          child: Column(children: [
                            Image.asset(
                              'assets/uploadImage.png',
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(height: 20),
                            const Text('Upload Picture',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ])))
                ]),
          ))
        ]));
  }
}

class DisplaySelectedImage extends StatelessWidget {
  final TextEditingController reportTypeController = TextEditingController();
  final File selectedImage;
  final MedicalRecordsRepository recordsRepository = MedicalRecordsRepository();
  late final MedicalRecordsBloc _recordsBloc =
      MedicalRecordsBloc(recordsRepository: recordsRepository);

  DisplaySelectedImage({Key? key, required this.selectedImage})
      : super(key: key);

  String generateRandomName() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const length = 50;

    Random random = Random();
    String randomName = '';

    for (int i = 0; i < length; i++) {
      randomName += chars[random.nextInt(chars.length)];
    }

    return randomName;
  }

  Future<void> _UploadReport() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    Reference storageReference =
        FirebaseStorage.instance.ref().child(generateRandomName());
    TaskSnapshot uploadTask =
        await storageReference.putFile(File(selectedImage.path));
    String imageUrl = await uploadTask.ref.getDownloadURL();
    _recordsBloc.add(SetRecord(
        report: UserReport(
            type: reportTypeController.text,
            image: imageUrl,
            createdAt: formattedDate)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        bottomNavigationBar: BaseMenuBar(),
        body: BlocBuilder(
            bloc: _recordsBloc,
            builder: (_, RecordState state) {
              if (state is RecordSetError) {
                return Center(child: Text(state.errorMsg!));
              }
              if (state is RecordSetting) {
                return const Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      CircularProgressIndicator(),
                      Text('Uploading Report...')
                    ]));
              }
              if (state is RecordSetSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ViewRecords(
                                userid: '',
                                name: '',
                              )));
                });
              }
              return SingleChildScrollView(
                  child: Column(children: [
                       Container(
  padding: const EdgeInsets.all(16.0),
  width: double.infinity,
  height: MediaQuery.of(context).size.height * 0.3,
  decoration: const BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(50.0),
      bottomRight: Radius.circular(50.0),
    ),
    color: Color(0xFF01888B),
  ),
  child: Stack(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AddReport()),
            ),
          ),
        ),
      ),
      const Align(
        alignment: Alignment.center,
        child: Text(
          "Upload Report",
          style: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  ),
),
                const SizedBox(height: 50.0),
                Image.file(selectedImage),
                const SizedBox(height: 40.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: reportTypeController,
                    decoration: InputDecoration(
                      labelText: 'Report Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFCCE7E8),
                      labelStyle: const TextStyle(color: Color(0xFF01888B)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF01888B), width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                FractionallySizedBox(
                    widthFactor: 0.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _UploadReport();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01888B),
                        ),
                        child: const Text(
                            style: TextStyle(color: Colors.white), 'UPLOAD'),
                      ),
                    )),
              ]));
            }));
  }
}

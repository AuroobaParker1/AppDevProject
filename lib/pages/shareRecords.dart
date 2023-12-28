// ignore_for_file: file_names, library_private_types_in_public_api, sized_box_for_whitespace
import 'dart:math';

import 'package:aap_dev_project/bloc/recordShare/recordShare_block.dart';
import 'package:aap_dev_project/bloc/recordShare/recordShare_event.dart';
import 'package:aap_dev_project/bloc/recordShare/recordShare_states.dart';
import 'package:aap_dev_project/core/repository/recordsSharing_repo.dart';
import 'package:aap_dev_project/pages/viewMedicalRecords.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottomNavigationBar.dart';
import 'appDrawer.dart';

class ShareRecords extends StatefulWidget {
  const ShareRecords({Key? key}) : super(key: key);

  @override
  _ShareRecordsState createState() => _ShareRecordsState();
}

class _ShareRecordsState extends State<ShareRecords> {
  final RecordsSharingRepository recordsRepository = RecordsSharingRepository();
  late RecordShareBloc _recordsBloc;
  String accessCode = '';
  String personalCode = '';
  bool accessCodeFound = true;

  @override
  void initState() {
    super.initState();
    _recordsBloc = RecordShareBloc(recordsRepository: recordsRepository);
    _recordsBloc.add(const FetchRecord());
  }

  String generateRandomString() {
    Random random = Random();
    String result = '';
    for (var i = 0; i < 5; i++) {
      result += random.nextInt(10).toString();
    }
    return result;
  }

  Future<void> _startShare() async {
    _recordsBloc.add(AddRecord(code: personalCode));
  }

  Future<void> _stopShare() async {
    _recordsBloc.add(RemoveRecord());
  }

  void checkAccessCode(BuildContext context, String accessCode, state) {
    try {
      var user = state.records.firstWhere((user) => user.code == accessCode);
      if (user != null) {
        accessCodeFound = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewRecords(
              userid: user.userid,
              name: user.name,
            ),
          ),
        );
      }
    } catch (e) {
      accessCodeFound = false;
      print('Error occurred: $e');
    }

    if (!accessCodeFound) {
      // Set your error variable to true here
      // errorVariable = true;
      print('Access code not found or error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      bottomNavigationBar: BaseMenuBar(),
      body: BlocBuilder(
          bloc: _recordsBloc,
          builder: (_, RecordState state) {
            return SingleChildScrollView(
                child: Column(
              children: [
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
                  child: const Center(
                    child: Text(
                      'Medical Records Sharing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const Text(
                        textAlign: TextAlign.center,
                        "Enter Access Code To View Medical Records:",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF01888B),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: const Color(0xFF01888B),
                            width: 2.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF01888B),
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    accessCode = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    accessCodeFound = true;
                                  });
                                  checkAccessCode(context, accessCode, state);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF01888B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Text(
                                  'Enter',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        accessCodeFound ? '' : 'No corresponding user found.',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 60.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const Text(
                        textAlign: TextAlign.center,
                        'Share This Code For Records Sharing:',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF01888B),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: const Color(0xFF01888B),
                        ),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (personalCode == '') {
                                  personalCode = generateRandomString();
                                  _startShare();
                                }
                              });
                            },
                            child: Center(
                              child: Text(
                                personalCode != ''
                                    ? personalCode
                                    : 'Generate Code',
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          _stopShare();
                          personalCode = '';
                        },
                        child: Text(
                            personalCode != ''
                                ? 'Click Here To Stop Sharing'
                                : '',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                              decoration: TextDecoration.underline,
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ));
          }),
    );
  }
}

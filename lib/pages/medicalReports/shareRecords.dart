// // // ignore_for_file: file_names, library_private_types_in_public_api, sized_box_for_whitespace
// import 'dart:convert';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:aap_dev_project/bloc/recordShare/recordShare_block.dart';
// import 'package:aap_dev_project/bloc/recordShare/recordShare_event.dart';
// import 'package:aap_dev_project/bloc/recordShare/recordShare_state.dart';
// import 'package:aap_dev_project/core/repository/recordsSharing_repo.dart';
// import 'package:aap_dev_project/models/report.dart';
// import 'package:aap_dev_project/pages/medicalReports/shared_viewRecords.dart';
// import 'package:aap_dev_project/pages/medicalReports/viewMedicalRecords.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import '../../API/jwtStorage.dart';
// import '../navigation/bottomNavigationBar.dart';
// import '../navigation/appDrawer.dart';
// import 'package:aap_dev_project/util/constant.dart'as constants;

// class ShareRecords extends StatefulWidget {
//   const ShareRecords({Key? key}) : super(key: key);

//   @override
//   _ShareRecordsState createState() => _ShareRecordsState();
// }

// class _ShareRecordsState extends State<ShareRecords> with RouteAware {
//   final RecordsSharingRepository recordsRepository = RecordsSharingRepository();
//   String accessCode = '';
//   String personalCode = 'Generate Code';
//   bool accessCodeFound = true;

//   @override
//   void initState() {
//     super.initState();
//   }

//   String generateRandomString() {
//     Random random = Random();
//     String result = '';
//     for (var i = 0; i < 5; i++) {
//       result += random.nextInt(10).toString();
//     }
//     return result;
//   }

//   Future<void> _startShare() async {
//     // Code to start sharing
//   }

//   Future<void> _stopShare() async {
//     // Code to stop sharing
//   }

//   void checkAccessCode(BuildContext context, String accessCode) async {
//     try {
//       List<MedicalRecord> records = await recordsRepository.verifyCodeAndRetrieveRecords(accessCode);
//       if (records.isNotEmpty) {
//         accessCodeFound = true;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ViewRecordsShared(records: records),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         accessCodeFound = false;
//       });
//       print('Error occurred: $e');
//     }

//     if (!accessCodeFound) {
//       print('Access code not found or error occurred.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Hide keyboard when tapping anywhere outside the text field
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         drawer: const CustomDrawer(),
//         bottomNavigationBar: BaseMenuBar(),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               buildHeader(context),
//               buildAccessCodeInput(),
//               buildSharingCodeSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.2,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(50.0),
//           bottomRight: Radius.circular(50.0),
//         ),
//         color: Color(0xFF01888B),
//       ),
//       child: const Align(
//         alignment: Alignment.center,
//         child: Text(
//           'Medical Records Sharing',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 36.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildAccessCodeInput() {
//     return Column(
//       children: [
//         const SizedBox(height: 120.0),
//         const Text(
//           "Enter Access Code To View Medical Records:",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 24.0,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF01888B),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         Container(
//           width: double.infinity,
//           height: 60.0,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.0),
//             border: Border.all(
//               color: const Color(0xFF01888B),
//               width: 2.0,
//             ),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   style: const TextStyle(
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF01888B),
//                   ),
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       accessCode = value;
//                     });
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: SizedBox(
//                   width: 40.0,
//                   height: 40.0,
//                   child: FloatingActionButton(
//                     onPressed: () {
//                       setState(() {
//                         accessCodeFound = true;
//                       });
//                        checkAccessCode(context, accessCode);
//                     },
//                     backgroundColor: const Color(0xFF01888B),
//                     child: const Icon(
//                       Icons.check,
//                       size: 24.0,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//         const SizedBox(height: 8.0),
//         Text(
//           accessCodeFound ? '' : 'No corresponding user found.',
//           style: const TextStyle(
//             fontSize: 12.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.red,
//           ),
//         )
//       ],
//     );
//   }

//   Widget buildSharingCodeSection() {
//     return Column(
//       children: [
//         const SizedBox(height: 60.0),
//         const Text(
//           'Share This Code For Records Sharing:',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 24.0,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF01888B),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         Container(
//           width: double.infinity,
//           height: 60.0,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.0),
//             color: const Color(0xFF01888B),
//           ),
//           child: GestureDetector(
//             onTap: () async {
//               if (personalCode == 'Generate Code') {
//                 try {
//                   personalCode = await recordsRepository.generateVerificationCode();
//                   print(personalCode);
//                   setState(() {});
//                   _startShare();
//                 } catch (e) {
//                   print('Error generating verification code: $e');
//                 }
//               }
//             },
//             child: Center(
//               child: Text(
//                 personalCode,
//                 style: const TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),

//         const SizedBox(height: 16.0),
//         GestureDetector(
//           onTap: () {
//             _stopShare();
//             setState(() {
//               personalCode = '';
//             });
//           },
//           child: Text(
//             personalCode != '' ? 'Click Here To Stop Sharing' : '',
//             style: TextStyle(
//               fontSize: 16.0,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[800],
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class ShareRecords extends StatefulWidget {
//   const ShareRecords({Key? key}) : super(key: key);

//   @override
//   _ShareRecordsState createState() => _ShareRecordsState();
// }

// class _ShareRecordsState extends State<ShareRecords> with RouteAware {
//   final RecordsSharingRepository recordsRepository = RecordsSharingRepository();
//   // late RecordShareBloc _recordsBloc;
//   String accessCode = '';
//   String personalCode = '';
//   bool accessCodeFound = true;

//   @override
//   void didPopNext() {
//     setState(() {});
//     super.didPopNext();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // _recordsBloc = BlocProvider.of<RecordShareBloc>(context);
//     // _recordsBloc.add(const FetchRecord());
//   }

//   String generateRandomString() {
//     Random random = Random();
//     String result = '';
//     for (var i = 0; i < 5; i++) {
//       result += random.nextInt(10).toString();
//     }
//     return result;
//   }

//   Future<void> _startShare() async {
//     // _recordsBloc.add(AddRecord(code: personalCode));
//   }

//   Future<void> _stopShare() async {
//     // _recordsBloc.add(const RemoveRecord());
//   }

//   void checkAccessCode(BuildContext context, String accessCode, state) {
//     try {
//       var user = state.records.firstWhere((user) => user.code == accessCode);
//       if (user != null) {
//         accessCodeFound = true;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ViewRecords(
//               // userid: user.userid,
//               // name: user.name,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       accessCodeFound = false;
//       print('Error occurred: $e');
//     }

//     if (!accessCodeFound) {
//       // Set your error variable to true here
//       // errorVariable = true;
//       print('Access code not found or error occurred.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Hide keyboard when tapping anywhere outside the text field
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         drawer: const CustomDrawer(),
//         bottomNavigationBar: BaseMenuBar(),
//         body: BlocBuilder(
//             bloc: _recordsBloc,
//             builder: (_, RecordState state) {
//               return SingleChildScrollView(
//                   child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     width: double.infinity,
//                     height: MediaQuery.of(context).size.height * 0.2,
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(50.0),
//                         bottomRight: Radius.circular(50.0),
//                       ),
//                       color: Color(0xFF01888B),
//                     ),
//                     child: Stack(
//                       children: [
//                         const Align(
//                           alignment: Alignment.center,
//                           child: Text(
//                             'Medical Records Sharing',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 36.0,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 120.0),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Column(
//                       children: [
//                         const Text(
//                           textAlign: TextAlign.center,
//                           "Enter Access Code To View Medical Records:",
//                           style: TextStyle(
//                             fontSize: 24.0,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF01888B),
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         Container(
//                           width: double.infinity,
//                           height: 60.0,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20.0),
//                             border: Border.all(
//                               color: const Color(0xFF01888B),
//                               width: 2.0,
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   style: const TextStyle(
//                                     fontSize: 24.0,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF01888B),
//                                   ),
//                                   decoration: const InputDecoration(
//                                     border: InputBorder.none,
//                                     contentPadding:
//                                         EdgeInsets.symmetric(horizontal: 16.0),
//                                   ),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       accessCode = value;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 10.0),
//                                 child: SizedBox(
//                                   width: 40.0,
//                                   height: 40.0,
//                                   child: FloatingActionButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         accessCodeFound = true;
//                                       });
//                                       checkAccessCode(
//                                           context, accessCode, state);
//                                     },
//                                     backgroundColor: const Color(0xFF01888B),
//                                     child: const Icon(
//                                       Icons.check,
//                                       size: 24.0,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 8.0),
//                         Text(
//                           accessCodeFound ? '' : 'No corresponding user found.',
//                           style: const TextStyle(
//                             fontSize: 12.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 60.0),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Column(
//                       children: [
//                         const Text(
//                           textAlign: TextAlign.center,
//                           'Share This Code For Records Sharing:',
//                           style: TextStyle(
//                             fontSize: 24.0,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF01888B),
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         Container(
//                           width: double.infinity,
//                           height: 60.0,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20.0),
//                             color: const Color(0xFF01888B),
//                           ),
//                           child: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   if (personalCode == '') {
//                                     personalCode = generateRandomString();
//                                     _startShare();
//                                   }
//                                 });
//                               },
//                               child: Center(
//                                 child: Text(
//                                   personalCode != ''
//                                       ? personalCode
//                                       : 'Generate Code',
//                                   style: const TextStyle(
//                                     fontSize: 24.0,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               )),
//                         ),
//                         const SizedBox(height: 16.0),
//                         GestureDetector(
//                           onTap: () {
//                             _stopShare();
//                             personalCode = '';
//                           },
//                           child: Text(
//                               personalCode != ''
//                                   ? 'Click Here To Stop Sharing'
//                                   : '',
//                               style: TextStyle(
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue[800],
//                                 decoration: TextDecoration.underline,
//                               )),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ));
//             }),
//       ),
//     );
//   }
// }



  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       // Hide keyboard when tapping anywhere outside the text field
  //       FocusScope.of(context).unfocus();
  //     },
  //     child: Scaffold(
  //       drawer: const CustomDrawer(),
  //       bottomNavigationBar: BaseMenuBar(),
  //       body: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(16.0),
  //               width: double.infinity,
  //               height: MediaQuery.of(context).size.height * 0.2,
  //               decoration: const BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(50.0),
  //                   bottomRight: Radius.circular(50.0),
  //                 ),
  //                 color: Color(0xFF01888B),
  //               ),
  //               child: const Align(
  //                 alignment: Alignment.center,
  //                 child: Text(
  //                   'Medical Records Sharing',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: 36.0,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 120.0),
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //               child: Column(
  //                 children: [
  //                   const Text(
  //                     textAlign: TextAlign.center,
  //                     "Enter Access Code To View Medical Records:",
  //                     style: TextStyle(
  //                       fontSize: 24.0,
  //                       fontWeight: FontWeight.bold,
  //                       color: Color(0xFF01888B),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16.0),
  //                   Container(
  //                     width: double.infinity,
  //                     height: 60.0,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(20.0),
  //                       border: Border.all(
  //                         color: const Color(0xFF01888B),
  //                         width: 2.0,
  //                       ),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: TextField(
  //                             style: const TextStyle(
  //                               fontSize: 24.0,
  //                               fontWeight: FontWeight.bold,
  //                               color: Color(0xFF01888B),
  //                             ),
  //                             decoration: const InputDecoration(
  //                               border: InputBorder.none,
  //                               contentPadding:
  //                                   EdgeInsets.symmetric(horizontal: 16.0),
  //                             ),
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 accessCode = value;
  //                               });
  //                             },
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.only(right: 10.0),
  //                           child: SizedBox(
  //                             width: 40.0,
  //                             height: 40.0,
  //                             child: FloatingActionButton(
  //                               onPressed: () {
  //                                 setState(() {
  //                                   accessCodeFound = true;
  //                                 });
  //                                 checkAccessCode(context, accessCode);
  //                               },
  //                               backgroundColor: const Color(0xFF01888B),
  //                               child: const Icon(
  //                                 Icons.check,
  //                                 size: 24.0,
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8.0),
  //                   Text(
  //                     accessCodeFound ? '' : 'No corresponding user found.',
  //                     style: const TextStyle(
  //                       fontSize: 12.0,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.red,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 60.0),
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //               child: Column(
  //                 children: [
  //                   const Text(
  //                     textAlign: TextAlign.center,
  //                     'Share This Code For Records Sharing:',
  //                     style: TextStyle(
  //                       fontSize: 24.0,
  //                       fontWeight: FontWeight.bold,
  //                       color: Color(0xFF01888B),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16.0),
  //                   Container(
  //                     width: double.infinity,
  //                     height: 60.0,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(20.0),
  //                       color: const Color(0xFF01888B),
  //                     ),
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           if (personalCode == '') {
  //                             _startShare();
  //                           }
  //                         });
  //                       },
  //                       child: Center(
  //                         child: Text(
  //                           personalCode != ''
  //                               ? personalCode
  //                               : 'Generate Code',
  //                           style: const TextStyle(
  //                             fontSize: 24.0,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16.0),
  //                   GestureDetector(
  //                     onTap: () {
  //                       _stopShare();
  //                     },
  //                     child: Text(
  //                       personalCode != ''
  //                           ? 'Click Here To Stop Sharing'
  //                           : '',
  //                       style: TextStyle(
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.blue[800],
  //                         decoration: TextDecoration.underline,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16.0),
  //                   GestureDetector(
  //                     onTap: () {
  //                       _generateTemporaryLink();
  //                     },
  //                     child: Container(
  //                       width: double.infinity,
  //                       height: 60.0,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(20.0),
  //                         color: const Color(0xFF01888B),
  //                       ),
  //                       child: Center(
  //                         child: const Text(








// class ShareRecords extends StatefulWidget {
//   const ShareRecords({Key? key}) : super(key: key);

//   @override
//   _ShareRecordsState createState() => _ShareRecordsState();
// }

// class _ShareRecordsState extends State<ShareRecords> with RouteAware {
//   final RecordsSharingRepository recordsRepository = RecordsSharingRepository();
//   String accessCode = '';
//   String personalCode = 'Generate Code';
//   bool accessCodeFound = true;
//   String _temporaryLink = '';
//   bool _isQRCodeVisible = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _generateTemporaryLink() async {
//     try {
//       var token = await retrieveJwtToken();
//       final response = await http.get(
//         Uri.parse('${constants.url}/api/medical-records/generate-link'),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           _temporaryLink = data['link'];
//           _isQRCodeVisible = true;
//         });
//       } else {
//         // Handle error
//       }
//     } catch (e) {
//       // Handle exception
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         drawer: const CustomDrawer(),
//         bottomNavigationBar: BaseMenuBar(),
//         body: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   buildHeader(context),
//                   buildAccessCodeInput(),
//                   buildSharingCodeSection(),
//                 ],
//               ),
//             ),
//             if (_isQRCodeVisible) _buildBlurBackground(),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: _generateTemporaryLink,
//           child: Icon(Icons.qr_code),
//         ),
//       ),
//     );
//   }

//   Widget buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.2,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(50.0),
//           bottomRight: Radius.circular(50.0),
//         ),
//         color: Color(0xFF01888B),
//       ),
//       child: const Align(
//         alignment: Alignment.center,
//         child: Text(
//           'Medical Records Sharing',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 36.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildAccessCodeInput() {
//     return Column(
//       children: [
//         const SizedBox(height: 120.0),
//         const Text(
//           "Enter Access Code To View Medical Records:",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 24.0,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF01888B),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         Container(
//           width: double.infinity,
//           height: 60.0,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.0),
//             border: Border.all(
//               color: const Color(0xFF01888B),
//               width: 2.0,
//             ),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   style: const TextStyle(
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF01888B),
//                   ),
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       accessCode = value;
//                     });
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: SizedBox(
//                   width: 40.0,
//                   height: 40.0,
//                   child: FloatingActionButton(
//                     onPressed: () {
//                       setState(() {
//                         accessCodeFound = true;
//                       });
//                         // checkAccessCode(context, accessCode);
//                     },
//                     backgroundColor: const Color(0xFF01888B),
//                     child: const Icon(
//                       Icons.check,
//                       size: 24.0,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//         const SizedBox(height: 8.0),
//         Text(
//           accessCodeFound ? '' : 'No corresponding user found.',
//           style: const TextStyle(
//             fontSize: 12.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.red,
//           ),
//         )
//       ],
//     );
//   }

//   Widget buildSharingCodeSection() {
//     return Column(
//       children: [
//         const SizedBox(height: 60.0),
//         const Text(
//           'Share This Code For Records Sharing:',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 24.0,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF01888B),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         Container(
//           width: double.infinity,
//           height: 60.0,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.0),
//             color: const Color(0xFF01888B),
//           ),
//           child: GestureDetector(
//             onTap: () async {
//               if (personalCode == 'Generate Code') {
//                 try {
//                   personalCode = await recordsRepository.generateVerificationCode();
//                   print(personalCode);
//                   setState(() {});
//                   // _startShare();
//                 } catch (e) {
//                   print('Error generating verification code: $e');
//                 }
//               }
//             },
//             child: Center(
//               child: Text(
//                 personalCode,
//                 style: const TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         GestureDetector(
//           onTap: () {
//             // _stopShare();
//             setState(() {
//               personalCode = '';
//             });
//           },
//           child: Text(
//             personalCode != '' ? 'Click Here To Stop Sharing' : '',
//             style: TextStyle(
//               fontSize: 16.0,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[800],
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildBlurBackground() {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _isQRCodeVisible = false;
//         });
//       },
//       child: Container(
//         color: Colors.black.withOpacity(0.5),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 padding: EdgeInsets.all(16),
//                 child: QrImageView(
//                   data: _temporaryLink,
//                   version: QrVersions.auto,
//                   size: 200.0,
//                 ),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     _isQRCodeVisible = false;
//                   });
//                 },
//                 child: Text('Close'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



















import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:aap_dev_project/bloc/recordShare/recordShare_block.dart';
import 'package:aap_dev_project/bloc/recordShare/recordShare_event.dart';
import 'package:aap_dev_project/bloc/recordShare/recordShare_state.dart';
import 'package:aap_dev_project/core/repository/recordsSharing_repo.dart';
import 'package:aap_dev_project/models/report.dart';
import 'package:aap_dev_project/pages/medicalReports/shared_viewRecords.dart';
import 'package:aap_dev_project/pages/medicalReports/viewMedicalRecords.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../API/jwtStorage.dart';
import '../navigation/bottomNavigationBar.dart';
import '../navigation/appDrawer.dart';
import 'package:aap_dev_project/util/constant.dart'as constants;

class ShareRecords extends StatefulWidget {
  const ShareRecords({Key? key}) : super(key: key);

  @override
  _ShareRecordsState createState() => _ShareRecordsState();
}

class _ShareRecordsState extends State<ShareRecords> with RouteAware {
  final RecordsSharingRepository recordsRepository = RecordsSharingRepository();
  String accessCode = '';
  String personalCode = 'Generate Code';
  bool accessCodeFound = true;

  @override
  void initState() {
    super.initState();
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
    // Code to start sharing
  }

  Future<void> _stopShare() async {
    // Code to stop sharing
  }

  void checkAccessCode(BuildContext context, String accessCode) async {
    try {
      List<MedicalRecord> records = await recordsRepository.verifyCodeAndRetrieveRecords(accessCode);
      if (records.isNotEmpty) {
        accessCodeFound = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewRecordsShared(records: records),
          ),
        );
      }
    } catch (e) {
      setState(() {
        accessCodeFound = false;
      });
      print('Error occurred: $e');
    }

    if (!accessCodeFound) {
      print('Access code not found or error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide keyboard when tapping anywhere outside the text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        drawer: const CustomDrawer(),
        bottomNavigationBar: BaseMenuBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(context),
              buildAccessCodeInput(),
              buildSharingCodeSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
        ),
        color: Color(0xFF01888B),
      ),
      child: const Align(
        alignment: Alignment.center,
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
    );
  }

  Widget buildAccessCodeInput() {
    return Column(
      children: [
        const SizedBox(height: 120.0),
        const Text(
          "Enter Access Code To View Medical Records:",
          textAlign: TextAlign.center,
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
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
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        accessCodeFound = true;
                      });
                       checkAccessCode(context, accessCode);
                    },
                    backgroundColor: const Color(0xFF01888B),
                    child: const Icon(
                      Icons.check,
                      size: 24.0,
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
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget buildSharingCodeSection() {
    return Column(
      children: [
        const SizedBox(height: 60.0),
        const Text(
          'Share This Code For Records Sharing:',
          textAlign: TextAlign.center,
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
            onTap: () async {
              if (personalCode == 'Generate Code') {
                try {
                  personalCode = await recordsRepository.generateVerificationCode();
                  print(personalCode);
                  setState(() {});
                  _startShare();
                } catch (e) {
                  print('Error generating verification code: $e');
                }
              }
            },
            child: Center(
              child: Text(
                personalCode,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        GestureDetector(
          onTap: () {
            _stopShare();
            setState(() {
              personalCode = 'Generate Code';
            });
          },
          child: Text(
            personalCode != '' && personalCode != 'Generate Code' ? 'Click Here To Stop Sharing' : '',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}

// // ignore_for_file: library_private_types_in_public_api, avoid_print, sized_box_for_whitespace, prefer_typing_uninitialized_variables

// import 'package:aap_dev_project/bloc/user/user_block.dart';
// import 'package:aap_dev_project/bloc/user/user_event.dart';
// import 'package:aap_dev_project/bloc/user/user_state.dart';
// import 'package:aap_dev_project/core/repository/user_repo.dart';
// import 'package:aap_dev_project/nodeBackend/jwtStorage.dart';
// import 'package:aap_dev_project/pages/medicalReports/addMedicalRecord.dart';
// import 'package:aap_dev_project/pages/medicalReports/viewMedicalRecords.dart';
// import 'package:aap_dev_project/pages/reminder/alarm.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import 'package:aap_dev_project/pages/navigation/bottomNavigationBar.dart';
// import 'package:aap_dev_project/pages/navigation/appDrawer.dart';

// class DashboardApp extends StatelessWidget {
//   const DashboardApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final UserRepository userRepository = UserRepository();
//     return DashboardScreen(userRepository: userRepository);
//   }
// }


// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key, required this.userRepository});
//   final UserRepository userRepository;

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   late UserBloc _userBloc;
//    @override
//   void initState() {
//     super.initState();
//     _userBloc = BlocProvider.of<UserBloc>(context);

    
//     _fetchData(); // Call the new method
    
//   }

//   Future<void> _fetchData() async {
//     String? token = await retrieveJwtToken();
//     print("token is $token");
//     if (token != null) {
//       _userBloc.add(FetchUserData(jwtToken: token));
//     } else {
//       print("i am in dashboard");
//       // Handle the case where there's no token (e.g., show a login screen)
//       print('No token found. User might need to log in.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           // Handle back button press here
//           // You can add your logic to either close the app or stay on this screen
//           return false; // Return false to prevent navigating back
//         },
//         child: Scaffold(
//             drawer: const CustomDrawer(),
//             bottomNavigationBar: BaseMenuBar(),
//             body: BlocBuilder(
//                 bloc: _userBloc,
//                 builder: (_, UserState state) {
//                   print(state);
//                   if (state is UserEmpty) {
//                     return const Center(child: Text('Empty state'));
//                   }
//                   if (state is UserLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (state is UserLoaded) {
//                     print(state.user.name);
//                     return SingleChildScrollView(
//                         child: Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                           width: double.infinity,
//                           height: MediaQuery.of(context).size.height * 0.25,
//                           decoration: const BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(50.0),
//                               bottomRight: Radius.circular(50.0),
//                             ),
//                             color: Color(0xFF01888B),
//                           ),
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       state.user.name.length > 14
//                                           ? '${state.user.name.substring(0, 14)}...'
//                                           : state.user.name,
//                                       style: const TextStyle(
//                                         fontFamily: 'Urbanist',
//                                         fontSize: 30,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 20.0),
//                                     Text(
//                                       state.user.mobile,
//                                       style: const TextStyle(
//                                           fontFamily: 'Urbanist',
//                                           fontSize: 20,
//                                           color: Colors.white),
//                                     ),
//                                   ],
//                                 ),
//                                 Container(
//                                   width: 100,
//                                   height: 100,
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.white,
//                                   ),
//                                   child: ClipOval(
//                                       child: Container(
//                                     decoration: state.user.image.isEmpty
//                                         ? const BoxDecoration(
//                                             image: DecorationImage(
//                                               image: AssetImage(
//                                                   "assets/profile.png"),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           )
//                                         : null, // Set to null if there's no decoration
//                                     child: state.user.image.isEmpty
//                                         ? null // No child if using decoration
//                                         : Image.network(
//                                             state.user.image,
//                                             fit: BoxFit.cover,
//                                             width: 100,
//                                             height: 100,
//                                           ),
//                                   )),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 60.0),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                           height: 220,
//                           width: double.infinity,
//                           child: GestureDetector(
//                             onTap: () async {
//                               print('Tapped');
//                               const url =
//                                   'https://www.drugs.com/drug_information.html';
//                               await launchUrlString(url);
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: const Color(
//                                       0xFF01888B), // Black color border
//                                   width: 3.0, // Border width
//                                 ),
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(15),
//                                 child: Image.network(
//                                   'https://www.needymeds.org/images/drugs.com_promo.png',
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 25),
//                         Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 24.0),
//                             child: Container(
//                                 height: 80,
//                                 width: double.infinity,
//                                 child: FloatingActionButton.extended(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => const AddReport(),
//                                       ),
//                                     );
//                                   },
//                                   label: const Text(
//                                     'Add Medical Records',
//                                     style: TextStyle(fontSize: 22),
//                                   ),
//                                   icon: const Icon(Icons.add_circle_outline),
//                                   backgroundColor: const Color(0xFF01888B),
//                                 ))),
//                         const SizedBox(height: 10.0),
//                         Padding(
//                           padding: const EdgeInsets.all(24.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 // Encapsulate in an Expanded widget
//                                 flex:
//                                     3, // Adjust flex factor as needed for layout
//                                 child: Container(
//                                   height: 80,
//                                   child: FloatingActionButton.extended(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               const AlarmHomeScreen(),
//                                         ),
//                                       );
//                                     },
//                                     label: const Text(
//                                       'Alarm',
//                                       style: TextStyle(fontSize: 22),
//                                     ),
//                                     icon: const Icon(Icons.alarm),
//                                     backgroundColor: const Color(0xFFF04444),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                   width: 10.0), // Spacing between buttons
//                               Expanded(
//                                 // Encapsulate in an Expanded widget
//                                 flex:
//                                     5, // Adjust flex factor as needed for layout
//                                 child: Container(
//                                   height: 80,
//                                   child: FloatingActionButton.extended(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               const ViewRecords(
//                                             // userid: '',
//                                             // name: '',
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     label: const Text(
//                                       'View Medical\nRecords',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(fontSize: 22),
//                                     ),
//                                     icon: const Icon(
//                                         Icons.remove_red_eye_outlined),
//                                     backgroundColor: const Color(0xFF01888B),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 20.0),
//                       ],
//                     ));
//                   }
//                   if (state is UserError) {
//                     return Center(child: Text(state.errorMsg!));
//                   }
//                   return const Center(child: Text('Unhandled state'));
//                 })));
//   }

//   // @override
//   // void dispose() {
//   //   _userBloc.close();
//   //   super.dispose();
//   // }
// }






import 'dart:convert';

import 'package:aap_dev_project/bloc/user/user_block.dart';
import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/bloc/user/user_state.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/API/jwtStorage.dart';
import 'package:aap_dev_project/pages/medicalReports/addMedicalRecord.dart';
import 'package:aap_dev_project/pages/medicalReports/viewMedicalRecords.dart';
import 'package:aap_dev_project/pages/reminder/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:aap_dev_project/pages/navigation/bottomNavigationBar.dart';
import 'package:aap_dev_project/pages/navigation/appDrawer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:aap_dev_project/util/constant.dart'as constants;


class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = UserRepository();
    return DashboardScreen(userRepository: userRepository);
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.userRepository});
  final UserRepository userRepository;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late UserBloc _userBloc;
  String _temporaryLink = '';
  bool _isQRCodeVisible = false;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _fetchData(); // Call the new method
  }

  Future<void> _fetchData() async {
    String? token = await retrieveJwtToken();
    print("token is $token");
    if (token != null) {
      _userBloc.add(FetchUserData(jwtToken: token));
    } else {
      print("i am in dashboard");
      // Handle the case where there's no token (e.g., show a login screen)
      print('No token found. User might need to log in.');
    }
  }

  Future<void> _generateTemporaryLink() async {
    try {
      var token = await retrieveJwtToken();
      final response = await http.get(
        Uri.parse('${constants.url}/api/medical-records/generate-link'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temporaryLink = data['link'];
          _isQRCodeVisible = true;
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Handle back button press here
          // You can add your logic to either close the app or stay on this screen
          return false; // Return false to prevent navigating back
        },
        child: Scaffold(
            drawer: const CustomDrawer(),
            bottomNavigationBar: BaseMenuBar(),
            body: Stack(
              children: [
                BlocBuilder(
                    bloc: _userBloc,
                    builder: (_, UserState state) {
                      print(state);
                      if (state is UserEmpty) {
                        return const Center(child: Text('Empty state'));
                      }
                      if (state is UserLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is UserLoaded) {
                        print(state.user.name);
                        return SingleChildScrollView(
                            child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50.0),
                                  bottomRight: Radius.circular(50.0),
                                ),
                                color: Color(0xFF01888B),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.user.name.length > 14
                                              ? '${state.user.name.substring(0, 14)}...'
                                              : state.user.name,
                                          style: const TextStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        Text(
                                          state.user.mobile,
                                          style: const TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: _generateTemporaryLink,
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: _isQRCodeVisible && _temporaryLink.isNotEmpty
                                              ? QrImageView(
                                                  data: _temporaryLink,
                                                  version: QrVersions.auto,
                                                  size: 100.0,
                                                )
                                              : Icon(
                                                  Icons.qr_code,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 60.0),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              height: 220,
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () async {
                                  print('Tapped');
                                  const url =
                                      'https://www.drugs.com/drug_information.html';
                                  await launchUrlString(url);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(
                                          0xFF01888B), // Black color border
                                      width: 3.0, // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      'https://www.needymeds.org/images/drugs.com_promo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Container(
                                    height: 80,
                                    width: double.infinity,
                                    child: FloatingActionButton.extended(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddReport(),
                                          ),
                                        );
                                      },
                                      label: const Text(
                                        'Add Medical Records',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      icon: const Icon(Icons.add_circle_outline),
                                      backgroundColor: const Color(0xFF01888B),
                                    ))),
                            const SizedBox(height: 10.0),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    // Encapsulate in an Expanded widget
                                    flex:
                                        3, // Adjust flex factor as needed for layout
                                    child: Container(
                                      height: 80,
                                      child: FloatingActionButton.extended(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AlarmHomeScreen(),
                                            ),
                                          );
                                        },
                                        label: const Text(
                                          'Alarm',
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        icon: const Icon(Icons.alarm),
                                        backgroundColor: const Color(0xFFF04444),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 10.0), // Spacing between buttons
                                  Expanded(
                                    // Encapsulate in an Expanded widget
                                    flex:
                                        5, // Adjust flex factor as needed for layout
                                    child: Container(
                                      height: 80,
                                      child: FloatingActionButton.extended(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ViewRecords(
                                                // userid: '',
                                                // name: '',
                                              ),
                                            ),
                                          );
                                        },
                                        label: const Text(
                                          'View Medical\nRecords',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        icon: const Icon(
                                            Icons.remove_red_eye_outlined),
                                        backgroundColor: const Color(0xFF01888B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ));
                      }
                      if (state is UserError) {
                        return Center(child: Text(state.errorMsg!));
                      }
                      return const Center(child: Text('Unhandled state'));
                    }),
                if (_isQRCodeVisible) _buildBlurBackground(),
              ],
            )));
  }

  Widget _buildBlurBackground() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isQRCodeVisible = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(16),
                child: QrImageView(
                  data: _temporaryLink,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isQRCodeVisible = false;
                  });
                },
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}























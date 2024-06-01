// // ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, library_private_types_in_public_api, use_build_context_synchronously

// import 'package:aap_dev_project/models/user.dart';
// import 'package:aap_dev_project/pages/home/dashboard.dart';
// import 'package:flutter/material.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import '../navigation/bottomNavigationBar.dart';
// import '../navigation/appDrawer.dart';

// Future<void> sendEmail(String userEmail, String userRequest) async {
//   String username = 'auroobaparker@outlook.com';
//   String password = 'Aabathebest1';

//   final smtpServer = hotmail(username, password);

//   final message = Message()
//     ..from = Address(username)
//     ..recipients.add('auroobaparker@gmail.com')
//     ..subject = 'New Request/Complaint'
//     ..text = 'User Email: $userEmail\n\nRequest/Complaint: $userRequest';

//   try {
//     final sendReport = await send(message, smtpServer);
//     print('Message sent: ' + sendReport.toString());
//   } on MailerException catch (e) {
//     print('Message not sent. Error: $e');
//   }
// }

// class HelpPage extends StatefulWidget {
//   final String emailAdress;
//   final UserProfile user;

//   const HelpPage({super.key, required this.emailAdress, required this.user});
//   @override
//   _HelpPageState createState() => _HelpPageState();
// }

// class _HelpPageState extends State<HelpPage> with RouteAware {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _requestController = TextEditingController();

//   @override
//   void didPopNext() {
//     setState(() {});
//     super.didPopNext();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _requestController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Hide keyboard when tapping anywhere outside the text field
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//           bottomNavigationBar: BaseMenuBar(),
//           drawer: CustomDrawer(user: widget.user),
//           body: SingleChildScrollView(
//               child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50.0),
//                     bottomRight: Radius.circular(50.0),
//                   ),
//                   color: Color(0xFF01888B),
//                 ),
//                 child: Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: Padding(
//                           padding: const EdgeInsets.only(top: 50.0),
//                           child: IconButton(
//                             icon: const Icon(Icons.arrow_back,
//                                 color: Colors.white),
//                             onPressed: () {
//                               Navigator.of(context)
//                                   .pushReplacement(MaterialPageRoute(
//                                 builder: (context) => DashboardApp(),
//                               ));
//                             },
//                           )),
//                     ),
//                     const Align(
//                         alignment: Alignment.center,
//                         child: Padding(
//                           padding:
//                               EdgeInsets.only(left: 50, right: 50, top: 20),
//                           child: Text(
//                             textAlign: TextAlign.center,
//                             'How Can We Help?',
//                             style: TextStyle(
//                               fontSize: 36.0,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         )),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 70.0),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 height: MediaQuery.of(context).size.height * 0.53,
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(bottom: 20.0),
//                       child: Text(
//                         'You got a problem?',
//                         style: TextStyle(
//                           fontSize: 24.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const Text(
//                       'Don\'t worry, leave us a message and we will help you solve the problem.',
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 20.0),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Your Email',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8.0),
//                         TextField(
//                           controller: _emailController,
//                           decoration: InputDecoration(
//                             hintText: widget.emailAdress,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20.0),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20.0),
//                         const Text(
//                           'Your Request/Complaint',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8.0),
//                         TextField(
//                           controller: _requestController,
//                           maxLines: 3,
//                           decoration: InputDecoration(
//                             hintText: 'Enter your request/complaint',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20.0),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20.0),
//                       ],
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         FloatingActionButton.extended(
//                             onPressed: () async {
//                               await sendEmail(
//                                 _emailController.text,
//                                 _requestController.text,
//                               );
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                       'Message sent successfully! We have received your message and will get back to you soon.'),
//                                 ),
//                               );
//                             },
//                             backgroundColor: const Color(0xFF01888B),
//                             label: const Text('Send Message'),
//                             icon: Icon(Icons.send, color: Colors.white)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ))),
//     );
//   }
// }























import 'package:aap_dev_project/models/user.dart';
import 'package:aap_dev_project/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../navigation/bottomNavigationBar.dart';
import '../navigation/appDrawer.dart';

Future<void> sendEmail(String userEmail, String userRequest) async {
  String username = 'auroobaparker@outlook.com';
  String password = 'Aabathebest1';

  final smtpServer = hotmail(username, password);

  final message = Message()
    ..from = Address(username)
    ..recipients.add('auroobaparker@gmail.com')
    ..subject = 'New Request/Complaint'
    ..text = 'User Email: $userEmail\n\nRequest/Complaint: $userRequest';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. Error: $e');
  }
}

class HelpPage extends StatefulWidget {
  final String emailAdress;
  final UserProfile user;

  const HelpPage({super.key, required this.emailAdress, required this.user});
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> with RouteAware {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _requestController = TextEditingController();

  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide keyboard when tapping anywhere outside the text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: BaseMenuBar(),
        drawer: CustomDrawer(user: widget.user),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => DashboardApp(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 50, right: 50, top: 20),
                        child: Text(
                          textAlign: TextAlign.center,
                          'How Can We Help?',
                          style: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        'You got a problem?',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      'Don\'t worry, leave us a message and we will help you solve the problem.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Your Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: widget.emailAdress,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Your Request/Complaint',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _requestController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter your request/complaint',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () async {
                            await sendEmail(
                              _emailController.text,
                              _requestController.text,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Message sent successfully! We have received your message and will get back to you soon.'),
                              ),
                            );
                          },
                          backgroundColor: const Color(0xFF01888B),
                          label: const Text('Send Message'),
                          icon: Icon(Icons.send, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

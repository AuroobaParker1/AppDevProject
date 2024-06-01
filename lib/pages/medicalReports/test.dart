// import 'dart:convert';
// import 'dart:io';
// import 'package:aap_dev_project/nodeBackend/jwtStorage.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
// import 'package:aap_dev_project/util/constant.dart'as constants;


// class MedicalRecordsPage extends StatefulWidget {
//   @override
//   _MedicalRecordsPageState createState() => _MedicalRecordsPageState();
// }

// class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
//   String _temporaryLink = '';
//   List<Widget> _medicalRecords = [];

//   Future<void> _generateTemporaryLink() async {
//   try {
//     var token = await retrieveJwtToken();
//     final response = await http.get(
//       Uri.parse('${constants.url}/api/medical-records/generate-link'),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         _temporaryLink = data['link'];
//       });
//       _launchTemporaryLink();
//     } else {
//       // Handle error
//     }
//   } catch (e) {
//     // Handle exception
//   }
// }
// Future<void> _launchTemporaryLink() async {
//   if (await canLaunchUrl(Uri.parse(_temporaryLink))) {
//     await launchUrl(Uri.parse(_temporaryLink));
//   } else {
//     // Handle the case where the link cannot be launched
//     print('Could not launch the temporary link: $_temporaryLink');
//   }
// }


//   Future<void> _fetchMedicalRecords() async {
//     try {
//       final response = await http.get(Uri.parse(_temporaryLink));
//       if (response.statusCode == 200) {
//         final html = response.body;
//         // Parse the HTML and extract the medical records
//         final documents = _parseHtml(html);
//         setState(() {
//           _medicalRecords = documents;
//         });
//       } else {
//         // Handle error
//       }
//     } catch (e) {
//       // Handle exception
//     }
//   }

//   List<Widget> _parseHtml(String html) {
//     // Implement the logic to parse the HTML and extract the medical records
//     // This will depend on the structure of the HTML returned by the API
//     // You can use a package like html_parser to help with this
//     return [
//       Image.network('https://example.com/image1.jpg'),
//       Image.network('https://example.com/image2.jpg'),
//       // Add more medical record widgets
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Medical Records'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _generateTemporaryLink,
//             child: Text('Generate Temporary Link'),
//           ),
//           if (_temporaryLink.isNotEmpty)
//             Text('Temporary Link: $_temporaryLink'),
//           Expanded(
//             child: ListView(
//               children: _medicalRecords,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:aap_dev_project/API/jwtStorage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:aap_dev_project/util/constant.dart' as constants;

class MedicalRecordsPage extends StatefulWidget {
  @override
  _MedicalRecordsPageState createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  String _temporaryLink = '';
  bool _isQRCodeVisible = false;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Records'),
      ),
      body: Stack(
        children: [
          _buildContent(),
          if (_isQRCodeVisible) _buildBlurBackground(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateTemporaryLink,
        child: Icon(Icons.qr_code),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Medical Records Page',
            style: TextStyle(fontSize: 24),
          ),
          // Other content
        ],
      ),
    );
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


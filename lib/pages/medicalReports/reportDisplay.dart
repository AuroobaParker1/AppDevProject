import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../models/report.dart';
import '../navigation/bottomNavigationBar.dart';
import '../navigation/appDrawer.dart';
import 'dart:async';

class ViewReport extends StatefulWidget {
  final MedicalRecord report;
  const ViewReport({Key? key, required this.report}) : super(key: key);

  @override
  _ViewReportState createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> with RouteAware {
  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      bottomNavigationBar: BaseMenuBar(),
      body: Stack(
        children: [
          SingleChildScrollView( // Added SingleChildScrollView here
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
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          widget.report.filename,
                          style: const TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 80.0),
                Image.memory(widget.report.data),
              ],
            ),
          ),
          const Positioned(
            top: 60,
            left: 20,
            child: BackButton(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

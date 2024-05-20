// ignore_for_file: file_names, library_private_types_in_public_api, sized_box_for_whitespace
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_block.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_event.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_state.dart';
import 'package:aap_dev_project/core/repository/medicalRecords_repo.dart';
import 'package:aap_dev_project/pages/home/dashboard.dart';
import 'package:aap_dev_project/pages/medicalReports/reportDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user/user_block.dart';
import '../../core/repository/user_repo.dart';
import '../navigation/bottomNavigationBar.dart';
import '../navigation/appDrawer.dart';

class ViewRecords extends StatefulWidget {
  const ViewRecords({Key? key})
      : super(key: key);
  
  // final String name;

  @override
  _ViewRecordsState createState() => _ViewRecordsState();
}

class _ViewRecordsState extends State<ViewRecords> with RouteAware {
  final MedicalRecordsRepository recordsRepository = MedicalRecordsRepository();
  late MedicalRecordsBloc _recordsBloc;
// late UserBloc _userBloc;
  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  @override
  void initState() {
    super.initState();
    _recordsBloc = BlocProvider.of<MedicalRecordsBloc>(context);
    _recordsBloc.add(const FetchRecord());
    // _userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        bottomNavigationBar: BaseMenuBar(),
        body: BlocBuilder(
            bloc: _recordsBloc,
            builder: (_, RecordState state) {
              if (state is RecordEmpty) {
                return const Center(child: Text('Empty state'));
              }
              if (state is RecordLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is RecordLoaded) {
                return Column(children: [
                  Stack(
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
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              // child: Text(
                              //       // _userBloc.userProfile?.name != null
                              //       //     ? 'Medical Records of ${_userBloc.userProfile!.name}'
                              //       //     : 'Your Medical Records',
                              //   textAlign: TextAlign.center,
                              //   style: const TextStyle(
                              //     fontSize: 36.0,
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.white,
                              //   ),
                              // ),
                            )),
                      ),
                      Positioned(
                        top: 60.0,
                        left: 16.0,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardApp()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: ListView.builder(
                          itemCount: state.records.length,
                          itemBuilder: (BuildContext context, int index) {
                            final record = state.records[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewReport(
                                        report: state.records[index]),
                                  ),
                                );
                              },
                              child: Card(
                                color: Color(0xFFCCE7E8),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: const BorderSide(
                                    color: Color(0xFF01888B),
                                    width: 3.0,
                                  ),
                                ),
                                elevation: 4.0,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  leading: Image.asset(
                                    'assets/report.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                      text: 'Title: ',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xFF01888B),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: record.filename,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF01888B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // subtitle: Text(
                                  //   'Date of Upload: ${record.createdAt!}',
                                  //   style: TextStyle(
                                  //     fontSize: 14.0,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                  trailing: Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF01888B),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                  )
                ]);
              }
              if (state is RecordError) {
                return Center(child: Text(state.errorMsg!));
              }
              return const Center(child: Text('Unhandled state'));
            }));
  }

  // @override
  // void dispose() {
  //   _recordsBloc.close();
  //   super.dispose();
  // }
}

// ignore_for_file: duplicate_import, unused_import
import 'package:aap_dev_project/bloc/alarm/alarm_bloc.dart';
import 'package:aap_dev_project/bloc/medicalRecords/medicalRecords_block.dart';
import 'package:aap_dev_project/bloc/user/user_block.dart';
import 'package:aap_dev_project/core/repository/recordsSharing_repo.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/pages/reminder/medicine.dart';
import 'package:aap_dev_project/pages/account/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/recordShare/recordShare_block.dart';
import 'core/repository/medicalRecords_repo.dart';
import 'pages/account/register.dart';
import 'pages/home/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        // BlocProvider<AlarmBloc>(
        //   create: (context) => AlarmBloc(alarmRepository: AlarmRepository()),
        // ),
        BlocProvider<UserBloc>( // Add your UserBloc provider here
          create: (context) => UserBloc(userRepository: UserRepository()), // Replace with your UserBloc implementation
        ),
        BlocProvider<MedicalRecordsBloc>( // Add your UserBloc provider here
          create: (context) => MedicalRecordsBloc(recordsRepository:MedicalRecordsRepository()), // Replace with your UserBloc implementation
        ),
        // BlocProvider<RecordShareBloc>( // Add your UserBloc provider here
        //   create: (context) => RecordShareBloc(recordsRepository:RecordsSharingRepository()), // Replace with your UserBloc implementation
        // ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      
      home: const Authentication(),
//       home: Scaffold(
//   body: Center(
//     child: Text('Test screen'),
//   ),
// ),

    );
  }
}

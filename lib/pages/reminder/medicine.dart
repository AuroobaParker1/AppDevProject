
import 'package:aap_dev_project/bloc/alarm/alarm_bloc.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_event.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_state.dart';
import 'package:aap_dev_project/core/repository/alarm_repo.dart';
import 'package:aap_dev_project/pages/navigation/bottomNavigationBar.dart';
import 'package:aap_dev_project/pages/reminder/alarm.dart';
import 'package:aap_dev_project/pages/navigation/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/widgets.dart';
import 'package:aap_dev_project/models/alarmInfo.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MedqrPage extends StatelessWidget {
  const MedqrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset('assets/MEDQR.jpg'),
              ],
            ),
          ),
          const SizedBox(height: 40),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider<AlarmBloc>(
                          create: (context) =>
                              AlarmBloc(alarmRepository: AlarmRepository()),
                          child: const MedicineScreen(),
                        )),
              );
            },
            label: const Text('Add your Medicine'),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({Key? key}) : super(key: key);

  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> with RouteAware {
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  List<String> allMedicines = [
    'Panadol',
    'Ibuprofen',
    'Adderall',
    'Ativan',
  ];
  String? selectedMedicine;
  TimeOfDay? selectedTime;
  int? frequencyPerDay;
  List<int> frequencyOptions = List.generate(5, (index) => index + 1);

  void setAlarm() async {
    if (selectedMedicine == null ||
        frequencyPerDay == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select all fields')));
      return;
    }

    DateTime currentDate = DateTime.now();

    DateTime dateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    String uniqueId = '${DateTime.now().millisecondsSinceEpoch}';
    AlarmInformation alarmInfo = AlarmInformation(
      id: uniqueId,
      name: selectedMedicine!,
      time: dateTime,
      isActive: true,
      frequency: frequencyPerDay!,
    );

    BlocProvider.of<AlarmBloc>(context).add(SetAlarm(alarmInfo));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
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
                        padding: EdgeInsets.only(top: 50),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AlarmHomeScreen(),
                            ));
                          },
                        )),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Add Alarm",
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
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'What Medicine would you like to add?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Type and Select from the list',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _typeAheadController,
                      decoration: const InputDecoration(
                        labelText: 'Select Medicine',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return allMedicines.where(
                        (medicine) => medicine
                            .toLowerCase()
                            .contains(pattern.toLowerCase()),
                      );
                    },
                    itemBuilder: (context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (String suggestion) {
                      _typeAheadController.text = suggestion;
                      selectedMedicine = suggestion;
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: DropdownButton2<int>(
                      value: frequencyPerDay,
                      hint: const Text('Select Dosage Per Day'),
                      items: frequencyOptions
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value times a day'),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          frequencyPerDay = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () => {
                        if (selectedMedicine != null && frequencyPerDay != null)
                          {_selectTime(context).then((_) {})}
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please select a medicine and frequency')))
                          }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer),
                            SizedBox(width: 8.0),
                            Text('Select First Dosage Time'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AlarmBloc, AlarmState>(
                    builder: (context, state) {
                      if (state is AlarmLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is AlarmSetSuccess) {
                        BlocProvider.of<AlarmBloc>(context)
                            .add(const FetchAlarm());
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AlarmHomeScreen(), // Remove BlocProvider here
                            ),
                          );
                        });
                        return Container();
                      } else if (state is AlarmSetError) {
                        return Text('Error: ${state.errorMsg}');
                      }
                      return Container();
                    },
                  ),
                  Center(
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        setAlarm();
                      },
                      label: const Text('Set Alarm'),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      icon: const Icon(Icons.alarm),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
        bottomNavigationBar: BaseMenuBar(),
      ),
    );
  }
}

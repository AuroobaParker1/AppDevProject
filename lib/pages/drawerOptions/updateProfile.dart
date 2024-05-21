// ignore_for_file: avoid_print, file_names, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:aap_dev_project/bloc/user/user_block.dart';
import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/bloc/user/user_state.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/models/user.dart';
import 'package:aap_dev_project/API/jwtStorage.dart';
import 'package:aap_dev_project/pages/navigation/bottomNavigationBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../navigation/appDrawer.dart';

class UpdateProfilePage extends StatefulWidget {
  final UserProfile user;
  const UpdateProfilePage({Key? key, required this.user}) : super(key: key);
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> with RouteAware {
  final UserRepository userRepository = UserRepository();
  late UserBloc _userBloc;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _medicalHistoryController =
      TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  var snap;

  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  Future<void> _pickImage(user) async {
    
    // final XFile? pickedFile =
    //     await _picker.pickImage(source: ImageSource.gallery);

    // if (pickedFile != null) {
    //   Reference storageReference =
    //       FirebaseStorage.instance.ref().child('user_images/${user.uid}');
    //   TaskSnapshot uploadTask =
    //       await storageReference.putFile(File(pickedFile.path));
    //   String imageUrl = await uploadTask.ref.getDownloadURL();
    //   // Update the image controller text and setState to rebuild UI
    //   setState(() {
    //     _imageController.text = imageUrl;
    //   });
    // }
  }

  @override
  void initState() async {
    super.initState();
        String? token = await retrieveJwtToken();

    _userBloc = UserBloc(userRepository: userRepository);
    if (token != null) {
      _userBloc.add(FetchUserData(jwtToken: token));
    } else {
            print("i am in dashboard");
      // Handle the case where there's no token (e.g., show a login screen)
      print('No token found. User might need to log in.');
    }
  }

  Future<void> _updateUserProfile(state) async {
    _userBloc.add(SetUser(
        user: UserProfile(
      name: _nameController.text == '' ? state.user.name : _nameController.text,
      age: _ageController.text == ''
          ? state.user.age
          : int.tryParse(_ageController.text) ?? 0,
      email: _emailController.text == ''
          ? state.user.email
          : _emailController.text,
      mobile: _mobileController.text == ''
          ? state.user.mobile
          : _mobileController.text,
      adress: _addressController.text == ''
          ? state.user.adress
          : _addressController.text,
      cnic: _cnicController.text == '' ? state.user.cnic : _cnicController.text,
      medicalHistory: _medicalHistoryController.text == ''
          ? state.user.medicalHistory
          : _medicalHistoryController.text,
      image: _imageController.text == ''
          ? state.user.image
          : _imageController.text,
    ),
    ));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfilePage(user: state.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide keyboard when tapping anywhere outside the text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: BlocBuilder(
              bloc: _userBloc,
              builder: (_, UserState state) {
                if (state is UserLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is UserLoaded) {
                  return Container(
                    color: const Color(0xFFCCE7E8),
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 0, bottom: 0),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 32),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: ClipOval(
                                      child: Container(
                                    decoration: state.user.image == ''
                                        ? const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/profile.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : null, // Set to null if there's no decoration
                                    child: state.user.image == ''
                                        ? null // No child if using decoration
                                        : Image.network(
                                            _imageController.text == ''
                                                ? state.user.image
                                                : _imageController.text,
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                  )),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _pickImage(_auth.currentUser);
                                  },
                                  child: const Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      // ... (your existing container and image code)
                                      Icon(Icons.camera_alt),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 64),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: 'Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: state.user.name,
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        color: Color(0xFF01888B)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF01888B), width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                TextField(
                                  controller: _ageController,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: state.user.age.toString() == '0'
                                        ? ''
                                        : state.user.age.toString(),
                                    labelText: 'Age',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        color: Color(0xFF01888B)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF01888B), width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 32),
                                TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: state.user.email,
                                    labelText: 'Email',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        color: Color(0xFF01888B)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF01888B), width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                TextField(
                                  controller: _mobileController,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: state.user.mobile,
                                    labelText: 'Mobile',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        color: Color(0xFF01888B)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF01888B), width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                TextField(
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    labelText: 'Address',
                                    hintText: state.user.adress,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    fillColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        color: Color(0xFF01888B)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF01888B), width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                TextField(
                                  controller: _cnicController,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: state.user.cnic,
                                    labelText: 'CNIC',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        color: Color(0xFF01888B)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF01888B), width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                TextField(
                                  controller: _medicalHistoryController,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: state.user.medicalHistory,
                                    labelText: 'Medical History',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        color: Color(0xFF01888B)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF01888B), width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  maxLines: null,
                                ),
                              ],
                            )),
                        const SizedBox(height: 56),
                        FractionallySizedBox(
                          widthFactor:
                              0.8, // Make the button take full width available
                          child: FloatingActionButton.extended(
                            onPressed: () => _updateUserProfile(state),
                            backgroundColor: const Color(0xFF01888B),
                            label: Text(
                                "Update Profile"), // Use FloatingActionButton.extended for text with an icon
                            icon: Icon(Icons.update, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    )),
                  );
                }
                if (state is UserError) {
                  return const Center(
                    child: Text('Error fetching user data'),
                  );
                }
                if (state is UserSetting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const Center(
                  child: Text('Error fetching user data'),
                );
              }),
          extendBody: true,
          backgroundColor: Colors.white,
          bottomNavigationBar: BaseMenuBar(),
          drawer: CustomDrawer(user: snap)),
    );
  }
}

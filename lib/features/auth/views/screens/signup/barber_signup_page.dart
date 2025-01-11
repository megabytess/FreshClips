import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshclips_capstone/features/auth/views/screens/login/landing_page.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/image_picker.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/location_picker_page.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/rectange_image_picker.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BarberSignupPage extends StatefulWidget {
  const BarberSignupPage({super.key});

  @override
  State<BarberSignupPage> createState() => _BarberSignupPageState();
}

class _BarberSignupPageState extends State<BarberSignupPage> {
  bool obscureText = true;

  // text editing controllers
  final lastNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final locationController = TextEditingController();
  final skillsController = TextEditingController();
  final yearsOfExperienceController = TextEditingController();
  File? selectUserImage;
  File? verifyImage;
  LatLng? selectedLatLng;
  String? selectedAddress;

  void signupHairstylist() async {
    if (lastNameController.text.trim().isEmpty ||
        firstNameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneNumberController.text.trim().isEmpty ||
        selectedLatLng == null ||
        passwordController.text.trim().isEmpty ||
        skillsController.text.trim().isEmpty ||
        yearsOfExperienceController.text.trim().isEmpty ||
        selectUserImage == null ||
        verifyImage == null ||
        !RegExp(r"^[a-zA-Z]+(?:[' -][a-zA-Z]+)*$")
            .hasMatch(firstNameController.text) ||
        !RegExp(r"^[a-zA-Z]+(?:[' -][a-zA-Z]+)*$")
            .hasMatch(lastNameController.text) ||
        !emailController.text.contains('@') ||
        !emailController.text.contains('.com')) {
      // Show invalid input dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Invalid input',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.045,
            ),
          ),
          content: Text(
            'Please complete the form correctly and upload both images.',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text(
                'Exit',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      );
    } else {
      try {
        // Create the user in Firebase Authentication
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final userId = userCredential.user!.uid;

        // Upload the first image
        final userImageRef =
            FirebaseStorage.instance.ref().child('user_images/$userId.jpg');
        await userImageRef.putFile(selectUserImage!);
        final imageUrl = await userImageRef.getDownloadURL();

        // Upload the second image
        final verifyImageRef = FirebaseStorage.instance
            .ref()
            .child('verification_images/$userId.jpg');
        await verifyImageRef.putFile(verifyImage!);
        final verifyImageUrl = await verifyImageRef.getDownloadURL();

        // Save user data in Firestore
        await FirebaseFirestore.instance.collection('user').doc(userId).set({
          'lastName': lastNameController.text,
          'firstName': firstNameController.text,
          'username': usernameController.text,
          'email': emailController.text,
          'phoneNumber': phoneNumberController.text,
          'location': {
            'latitude': selectedLatLng!.latitude,
            'longitude': selectedLatLng!.longitude,
            'address': selectedAddress,
          },
          'skills': skillsController.text,
          'yearsOfExperience': yearsOfExperienceController.text,
          'imageUrl': imageUrl,
          'verifyImageUrl': verifyImageUrl,
          'accountStatus': 'Pending',
          'userType': "Hairstylist",
        });

        // Show success dialog
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Success',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'Account successfully created!',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);

                  // Navigate to LandingPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LandingPage(),
                    ),
                  );
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        );
      } catch (e) {
        // Handle errors
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Error',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.045,
              ),
            ),
            content: Text(
              'An error occurred: ${e.toString()}',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/images/landing_page/freshclips_logo.svg',
          height: screenHeight * 0.05,
          width: screenWidth * 0.05,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Sign Up to Showcase Your Skills as a Hairstylist!',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
              ),
              Gap(screenHeight * 0.03),
              Center(
                child: PickerImage(onImagePick: (File pickedImage) {
                  setState(() {
                    selectUserImage = pickedImage;
                  });
                }),
              ),
              Gap(screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.43,
                    height: screenHeight * 0.08,
                    child: TextFormField(
                      controller: lastNameController,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        color: const Color.fromARGB(255, 23, 23, 23),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: const Color.fromARGB(255, 186, 199, 206),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.03,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 23, 23, 23),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              screenWidth * 0.03,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 23, 23, 23),
                          ),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(screenWidth * 0.02),
                  SizedBox(
                    width: screenWidth * 0.43,
                    height: screenHeight * 0.08,
                    child: TextFormField(
                      controller: firstNameController,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        color: const Color.fromARGB(255, 23, 23, 23),
                      ),
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: const Color.fromARGB(255, 186, 199, 206),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.03,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 23, 23, 23),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              screenWidth * 0.03,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 23, 23, 23),
                          ),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: usernameController,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: const Color.fromARGB(255, 186, 199, 206),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.03,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        screenWidth * 0.03,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
              ),
              Gap(screenHeight * 0.01),
              TextFormField(
                controller: emailController,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: const Color.fromARGB(255, 186, 199, 206),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.03,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        screenWidth * 0.03,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
              ),
              Gap(screenHeight * 0.01),
              TextFormField(
                controller: phoneNumberController,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: const Color.fromARGB(255, 186, 199, 206),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.03,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        screenWidth * 0.03,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
              ),
              Gap(screenHeight * 0.01),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.05,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationPicker(
                          onLocationSelected: (LatLng location) async {
                            setState(() {
                              selectedLatLng = location;
                            });
                            // Reverse geocoding
                            try {
                              List<Placemark> placemarks =
                                  await placemarkFromCoordinates(
                                location.latitude,
                                location.longitude,
                              );
                              if (placemarks.isNotEmpty) {
                                Placemark place = placemarks.first;
                                setState(() {
                                  selectedAddress =
                                      "${place.street}, ${place.subLocality} ${place.locality}, ${place.administrativeArea}";
                                });
                              }
                            } catch (e) {
                              setState(
                                () {
                                  selectedAddress = "Error fetching address";
                                },
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 45, 65, 69),
                    foregroundColor: const Color.fromARGB(255, 248, 248, 248),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.01,
                    ),
                  ),
                  child: Text(
                    'Pick location',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.032,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (selectedAddress != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Text(
                    'Selected Location: $selectedAddress',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 23, 23, 23),
                    ),
                  ),
                ),
              Gap(screenHeight * 0.01),
              const Divider(
                color: Color.fromARGB(255, 209, 216, 221),
                thickness: 1,
              ),
              Gap(screenHeight * 0.01),
              TextFormField(
                controller: skillsController,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
                decoration: InputDecoration(
                  labelText: 'Skills/Specialization',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: const Color.fromARGB(255, 186, 199, 206),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.03,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        screenWidth * 0.03,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
              ),
              Gap(screenHeight * 0.01),
              TextFormField(
                controller: yearsOfExperienceController,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
                decoration: InputDecoration(
                  labelText: 'Years of Experience',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: const Color.fromARGB(255, 186, 199, 206),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.03,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        screenWidth * 0.03,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
              ),
              Gap(screenHeight * 0.01),
              Text(
                'Upload an ID to verify your identity.',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
              ),
              Center(
                child: RectanglePickerImage(onImagePick: (File pickedImage) {
                  setState(() {
                    verifyImage = pickedImage;
                  });
                }),
              ),
              Gap(screenHeight * 0.01),
              const Divider(
                color: Color.fromARGB(255, 209, 216, 221),
                thickness: 1,
              ),
              Gap(screenHeight * 0.01),
              TextFormField(
                controller: passwordController,
                obscureText: obscureText,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: const Color.fromARGB(255, 186, 199, 206),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.03,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        screenWidth * 0.03,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 23, 23, 23),
                    ),
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    child: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromARGB(255, 186, 199, 206),
                    ),
                  ),
                ),
              ),
              Gap(screenHeight * 0.02),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: FloatingActionButton(
                  onPressed: () {
                    signupHairstylist();
                  },
                  backgroundColor: const Color.fromARGB(255, 189, 49, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                  child: Text(
                    'Signup',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Gap(screenHeight * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}

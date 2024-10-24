import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshclips_capstone/features/auth/views/screens/login/landing_page.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/image_picker.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void signupHairstylist() async {
    if (lastNameController.text.trim().isEmpty ||
        firstNameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneNumberController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        skillsController.text.trim().isEmpty ||
        yearsOfExperienceController.text.trim().isEmpty ||
        selectUserImage == null ||
        !emailController.text.contains('@') ||
        !emailController.text.contains('.com') ||
        !RegExp(r'^[a-zA-Z]+$').hasMatch(firstNameController.text) ||
        !RegExp(r'^[a-zA-Z]+$').hasMatch(lastNameController.text)) {
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
            'Please complete the form correctly. Only use letters in the name fields.',
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

        // Get the userId from the created user
        final userId = userCredential.user!.uid;

        // Upload the user image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('$userId.jpg');
        await storageRef.putFile(selectUserImage!);

        // Get the download URL of the uploaded image
        final imageUrl = await storageRef.getDownloadURL();

        // Set the user data in Firestore
        await FirebaseFirestore.instance.collection('user').doc(userId).set({
          'lastName': lastNameController.text,
          'firstName': firstNameController.text,
          'username': usernameController.text,
          'email': emailController.text,
          'phoneNumber': phoneNumberController.text,
          'location': locationController.text,
          'password': passwordController.text,
          'skills': skillsController.text,
          'yearsOfExperience': yearsOfExperienceController.text,
          'imageUrl': imageUrl,
          'userType': "Hairstylist",
        });

        // Show success dialog and navigate back to landing page
        showDialog(
          // ignore: use_build_context_synchronously
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
                  // Close the dialog
                  Navigator.pop(ctx);

                  // Navigate to LandingPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LandingPage()),
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
      } on FirebaseAuthException catch (e) {
        // Handle Firebase Authentication errors
        String errorMessage = '';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else {
          errorMessage = 'An error occurred during signup. Please try again.';
        }

        // Show error dialog
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Signup Error',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(ctx).size.width * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              errorMessage,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(ctx).size.width * 0.04,
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
      } catch (e) {
        // Handle general errors
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Error',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(ctx).size.width * 0.045,
              ),
            ),
            content: Text(
              'An error occurred: ${e.toString()}',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(ctx).size.width * 0.04,
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
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
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
              TextFormField(
                controller: locationController,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
                decoration: InputDecoration(
                  labelText: 'Location',
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

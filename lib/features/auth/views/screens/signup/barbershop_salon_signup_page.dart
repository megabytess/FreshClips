import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/auth/views/screens/login/landing_page.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/image_picker.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/rectange_image_picker.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BarbershopSalonPage extends StatefulWidget {
  const BarbershopSalonPage({super.key});

  @override
  State<BarbershopSalonPage> createState() => _BarbershopSalonPageState();
}

class _BarbershopSalonPageState extends State<BarbershopSalonPage> {
  bool obscureText = true;

  // text editing controllers
  final shopNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final locationController = TextEditingController();
  File? verifyImage;
  File? selectUserImage;

  void signupBarbershopSalon() async {
    if (shopNameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneNumberController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        selectUserImage == null ||
        verifyImage == null ||
        !emailController.text.contains('@') ||
        !emailController.text.contains('.com') ||
        !RegExp(r'^[a-zA-Z]+$').hasMatch(shopNameController.text)) {
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

        final userId = userCredential.user!.uid;

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

        // Set the user data in Firestore
        await FirebaseFirestore.instance.collection('user').doc(userId).set({
          'shopName': shopNameController.text,
          'username': usernameController.text,
          'email': emailController.text,
          'phoneNumber': phoneNumberController.text,
          'location': locationController.text,
          'password': passwordController.text,
          'imageUrl': imageUrl,
          'verifyImageUrl': verifyImageUrl,
          'accountStatus': 'Pending',
          'userType': "Barbershop_Salon",
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
            children: [
              Text(
                'Sign Up Your Barbershop/Salon and Expand Your Reach!',
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
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.08,
                child: TextFormField(
                  controller: shopNameController,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    color: const Color.fromARGB(255, 23, 23, 23),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Shop Name',
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
                  labelText: 'Shop Location',
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
                controller: passwordController, //password textfield
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
              Gap(screenHeight * 0.03),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: FloatingActionButton(
                  onPressed: () {
                    signupBarbershopSalon();
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

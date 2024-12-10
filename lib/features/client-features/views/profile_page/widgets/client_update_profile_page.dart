import 'dart:io' as io;
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/client-features/controllers/client_controller.dart';
import 'package:freshclips_capstone/features/client-features/models/client_model.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/edit_profile_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ClientUpdateProfilePage extends StatefulWidget {
  const ClientUpdateProfilePage({
    super.key,
    required this.email,
    required this.client,
  });
  final String email;
  final Client client;

  @override
  State<ClientUpdateProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ClientUpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController usernameController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  late TextEditingController locationController = TextEditingController();

  ClientController clientController = ClientController();
  ProfileController profileController = ProfileController();

  io.File? _imageFile;

  @override
  void initState() {
    super.initState();

    // Fetch or load the client data from the controller here
    fetchClientData();
  }

  Future<void> fetchClientData() async {
    clientController.fetchClientData(widget.email);

    setState(() {
      firstNameController.text = widget.client.firstName;
      lastNameController.text = widget.client.lastName;
      emailController.text = widget.client.email;
      phoneNumberController.text = widget.client.phoneNumber;
      usernameController.text = widget.client.username;
      // locationController.text = widget.client.location;
    });
  }

  // Function to pick an image from the user's gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = io.File(pickedFile.path);
      });
    }
  }

  // Function to upload image to Firebase Storage
  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');

      await storageRef.putFile(imageFile);
      String imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Update profile',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: clientController,
        builder: (context, snapshot) {
          // If hairstylist data is null or controller is loading, show loading or error message
          if (clientController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 49, 71),
                ),
              ),
            );
          }

          if (clientController.client == null) {
            return const Center(child: Text('Hairstylist data not available'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Image
                    Center(
                      child: ClipOval(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: screenWidth * 0.35,
                            height: screenWidth * 0.35,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 186, 199, 206),
                            ),
                            child: (_imageFile != null)
                                ? Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                  )
                                : (clientController.client?.imageUrl != null &&
                                        clientController
                                            .client!.imageUrl.isNotEmpty)
                                    ? Image.network(
                                        clientController.client!.imageUrl)
                                    : const Icon(Icons.person, size: 50),
                          ),
                        ),
                      ),
                    ),
                    Gap(screenHeight * 0.02),

                    // First Name
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    Gap(screenHeight * 0.02),

                    // Last Name
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    Gap(screenHeight * 0.02),

                    // Username
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    Gap(screenHeight * 0.02),

                    // Phone number
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    Gap(screenHeight * 0.02),

                    // Location
                    TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),

                    Gap(screenHeight * 0.04),

                    // Submit Button
                    SizedBox(
                      height: screenHeight * 0.07,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String imageUrl = widget.client
                                .imageUrl; // Use existing image URL initially

                            // Check if a new image was picked
                            if (_imageFile != null) {
                              // Upload the new image and get its URL
                              imageUrl =
                                  await uploadImageToStorage(_imageFile!);
                            }
                            // Save changes logic here
                            final updatedData = Client(
                              id: widget.client.id,
                              email: emailController.text,
                              phoneNumber: phoneNumberController.text,
                              imageUrl: imageUrl,
                              password: widget.client.password,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              username: usernameController.text,
                              location: clientController.client!.location,
                            );

                            // Convert to Map<String, dynamic>
                            final updatedDataMap = updatedData.toMap();

                            profileController.updateUserProfile(
                                widget.email, updatedDataMap);

                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 189, 49, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Save changes',
                          style: GoogleFonts.poppins(
                            color: Colors.white, // Text color
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/location_picker_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/edit_profile_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/hairstylist_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/hairstylist_model.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage(
      {super.key, required this.email, required this.hairstylist});
  final String email;
  final Hairstylist hairstylist;

  @override
  State<UpdateProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController usernameController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  late TextEditingController skillsController = TextEditingController();
  late TextEditingController yearsOfExperienceController =
      TextEditingController();

  HairstylistController hairstylistController = HairstylistController();
  ProfileController profileController = ProfileController();

  File? _imageFile;
  LatLng? selectedLatLng;
  String? selectedAddress;

  @override
  void initState() {
    super.initState();

    // Fetch or load the hairstylist data from the controller here
    fetchHairstylistData();
  }

  Future<void> fetchHairstylistData() async {
    hairstylistController.getHairstylist(widget.email);

    setState(() {
      firstNameController.text = widget.hairstylist.firstName;
      lastNameController.text = widget.hairstylist.lastName;
      emailController.text = widget.hairstylist.email;
      phoneNumberController.text = widget.hairstylist.phoneNumber;
      usernameController.text = widget.hairstylist.username;

      skillsController.text = widget.hairstylist.skills;
      yearsOfExperienceController.text =
          widget.hairstylist.yearsOfExperience.toString();
    });
  }

  // Function to pick an image from the user's gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
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
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 45, 65, 69),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: hairstylistController,
        builder: (context, snapshot) {
          if (hairstylistController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 49, 71),
                ),
              ),
            );
          }

          if (hairstylistController.hairstylist == null) {
            return const Center(
                child: Text('hairstylist salon data not available'));
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
                                : (hairstylistController
                                                .hairstylist?.imageUrl !=
                                            null &&
                                        hairstylistController
                                            .hairstylist!.imageUrl.isNotEmpty)
                                    ? Image.network(hairstylistController
                                        .hairstylist!.imageUrl)
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
                          color: const Color.fromARGB(255, 45, 65, 69),
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
                          color: const Color.fromARGB(255, 45, 65, 69),
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
                          color: const Color.fromARGB(255, 45, 65, 69),
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
                                    setState(() {
                                      selectedAddress =
                                          "Error fetching address";
                                    });
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 45, 65, 69),
                          foregroundColor:
                              const Color.fromARGB(255, 248, 248, 248),
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
                            color: const Color.fromARGB(255, 248, 248, 248),
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
                            color: const Color.fromARGB(255, 45, 65, 69),
                          ),
                        ),
                      ),
                    Gap(screenHeight * 0.02),

                    // Skills
                    TextFormField(
                      controller: skillsController,
                      decoration: InputDecoration(
                        labelText: 'Skills',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    Gap(screenHeight * 0.02),

                    // Years of Experience
                    TextFormField(
                      controller: yearsOfExperienceController,
                      decoration: InputDecoration(
                        labelText: 'Years of Experience',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your years of experience';
                        }
                        return null;
                      },
                    ),
                    Gap(screenHeight * 0.04),

                    // Submit Button
                    SizedBox(
                      height: screenHeight * 0.07,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String imageUrl = widget.hairstylist
                                .imageUrl; // Use existing image URL initially

                            // Check if a new image was picked
                            if (_imageFile != null) {
                              // Upload the new image and get its URL
                              imageUrl =
                                  await uploadImageToStorage(_imageFile!);
                            }
                            // Save changes logic here
                            final updatedData = Hairstylist(
                              id: widget.hairstylist.id,
                              email: emailController.text,
                              phoneNumber: phoneNumberController.text,
                              imageUrl: imageUrl,
                              password: widget.hairstylist.password,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              username: usernameController.text,
                              location: selectedLatLng != null
                                  ? {
                                      'latitude': selectedLatLng!.latitude,
                                      'longitude': selectedLatLng!.longitude,
                                      'address': selectedAddress,
                                    }
                                  : widget.hairstylist.location,
                              skills: skillsController.text,
                              yearsOfExperience:
                                  int.parse(yearsOfExperienceController.text),
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

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/location_picker_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/barbershop_salon_model.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/edit_profile_controller.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class BSUpdateProfilePage extends StatefulWidget {
  const BSUpdateProfilePage(
      {super.key, required this.email, required this.barbershopsalon});
  final String email;
  final BarbershopSalon barbershopsalon;

  @override
  State<BSUpdateProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<BSUpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController shopNameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController usernameController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  late TextEditingController locationController = TextEditingController();

  BarbershopSalonController barbershopsalonController =
      BarbershopSalonController();
  ProfileController profileController = ProfileController();

  File? _imageFile;
  LatLng? selectedLatLng;
  String? selectedAddress;
  @override
  void initState() {
    super.initState();

    // Fetch or load the barbershop salon data from the controller here
    fetchBarbershopSalonData();
  }

  Future<void> fetchBarbershopSalonData() async {
    barbershopsalonController.getBarbershopSalon(widget.email);

    setState(() {
      shopNameController.text = widget.barbershopsalon.shopName;
      emailController.text = widget.barbershopsalon.email;
      phoneNumberController.text = widget.barbershopsalon.phoneNumber;
      usernameController.text = widget.barbershopsalon.username;
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
        animation: barbershopsalonController,
        builder: (context, snapshot) {
          // If barbershop salon data is null or controller is loading, show loading or error message
          if (barbershopsalonController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 49, 71),
                ),
              ),
            );
          }

          if (barbershopsalonController.barbershopsalon == null) {
            return const Center(
                child: Text('Barbershop salon data not available'));
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
                                : (barbershopsalonController
                                                .barbershopsalon?.imageUrl !=
                                            null &&
                                        barbershopsalonController
                                            .barbershopsalon!
                                            .imageUrl
                                            .isNotEmpty)
                                    ? Image.network(barbershopsalonController
                                        .barbershopsalon!.imageUrl)
                                    : const Icon(Icons.person, size: 50),
                          ),
                        ),
                      ),
                    ),
                    Gap(screenHeight * 0.02),

                    // Shop Name
                    TextFormField(
                      controller: shopNameController,
                      decoration: InputDecoration(
                        labelText: 'Shop name',
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
                          return 'Please enter your shop name';
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
                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
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

                    // Phonenumber
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: const Color.fromARGB(255, 45, 65, 69),
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
                            String imageUrl = widget.barbershopsalon
                                .imageUrl; // Use existing image URL initially

                            // Check if a new image was picked
                            if (_imageFile != null) {
                              // Upload the new image and get its URL
                              imageUrl =
                                  await uploadImageToStorage(_imageFile!);
                            }

                            // Save changes logic here
                            final updatedData = BarbershopSalon(
                              id: widget.barbershopsalon.id,
                              email: emailController.text,
                              phoneNumber: phoneNumberController.text,
                              imageUrl: imageUrl,
                              password: widget.barbershopsalon.password,
                              shopName: shopNameController.text,
                              username: usernameController.text,
                              location: selectedLatLng != null
                                  ? {
                                      'latitude': selectedLatLng!.latitude,
                                      'longitude': selectedLatLng!.longitude,
                                      'address': selectedAddress,
                                    }
                                  : widget.barbershopsalon.location,
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
                            color: const Color.fromARGB(255, 248, 248, 248),
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

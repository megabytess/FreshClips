import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/admin-features/controller/admin_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminCheckPendingPage extends StatefulWidget {
  const AdminCheckPendingPage({
    super.key,
    required this.email,
  });
  final String email;

  @override
  AdminCheckPendingPageState createState() => AdminCheckPendingPageState();
}

class AdminCheckPendingPageState extends State<AdminCheckPendingPage> {
  final AdminVerifyController adminVerifyController = AdminVerifyController();
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Pending Account',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: AdminVerifyController().pendingAccountsDetails(widget.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 189, 49, 71),
              ),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found.'));
          } else {
            final users = snapshot.data!;
            if (users.isEmpty) {
              return const Center(child: Text('No user data found.'));
            }
            final userData = users;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  top: screenHeight * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: screenWidth * 0.15,
                          backgroundImage: userData[0]['imageUrl'] != null
                              ? NetworkImage(userData[0]['imageUrl'])
                              : null,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                userData[0]['username'] ?? 'No Username',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 18, 18, 18),
                                ),
                              ),
                              Text(
                                userData[0]['userType'] ?? 'No Usertype',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(screenHeight * 0.02),
                    Text(
                      'Email: ${userData[0]['email'] ?? 'No Email'}',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 18, 18, 18),
                      ),
                    ),
                    Gap(screenHeight * 0.01),
                    Text(
                      'Account Status: ${userData[0]['accountStatus'] ?? 'Pending'}',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 18, 18, 18),
                      ),
                    ),
                    Gap(screenHeight * 0.02),
                    Text(
                      'Verification ID:',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 18, 18, 18),
                      ),
                    ),
                    Gap(screenHeight * 0.01),
                    Container(
                      width: double.infinity,
                      height: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        image: DecorationImage(
                          image: userData[0]['verifyImageUrl'] != null
                              ? NetworkImage(userData[0]['verifyImageUrl'])
                              : const AssetImage(
                                      'assets/images/placeholder.png')
                                  as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      'Another Verification ID:',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 18, 18, 18),
                      ),
                    ),
                    Gap(screenHeight * 0.01),
                    Container(
                      width: double.infinity,
                      height: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        image: DecorationImage(
                          image: userData[0]['newVerifyImageDocRef'] != null
                              ? NetworkImage(
                                  userData[0]['newVerifyImageDocRef'])
                              : const AssetImage('') as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Gap(screenHeight * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.43,
                          height: screenHeight * 0.06,
                          child: ElevatedButton(
                            onPressed: () async {
                              adminVerifyController
                                  .approveAccount(widget.email);

                              // Show success dialog
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final screenWidth =
                                      MediaQuery.of(context).size.width;
                                  // final screenHeight =
                                  //     MediaQuery.of(context).size.height;

                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.03),
                                    ),
                                    title: Text(
                                      'Success',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: Text(
                                      'The account has been successfully approved!',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'OK',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 189, 49, 71),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 189, 49, 71),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.05,
                              ),
                              child: Text(
                                'Approve',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      const Color.fromARGB(255, 248, 248, 249),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.43,
                          height: screenHeight * 0.06,
                          child: OutlinedButton(
                            onPressed: () {
                              adminVerifyController.rejectAccount(
                                  email: widget.email,
                                  reason: reasonController.text);

                              // Show success dialog
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final screenWidth =
                                      MediaQuery.of(context).size.width;

                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.03),
                                    ),
                                    title: Text(
                                      'You Rejected the Account',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Kindly provide a reason for rejecting the account.',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: screenWidth * 0.04),
                                        TextField(
                                          controller: reasonController,
                                          decoration: InputDecoration(
                                            labelText: 'Reason',
                                            labelStyle: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.035,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenWidth * 0.02),
                                            ),
                                          ),
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          if (reasonController
                                              .text.isNotEmpty) {
                                            // Call the function to update the account status with the reason
                                            adminVerifyController.rejectAccount(
                                              email: widget.email,
                                              reason: reasonController.text,
                                            );
                                            Navigator.pop(
                                                context); // Close dialog
                                            Navigator.pop(
                                                context); // Navigate back
                                          } else {
                                            // Show a snack bar or alert for empty reason
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Please provide a reason for rejecting the account.',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        screenWidth * 0.035,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text(
                                          'Submit',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 18, 18, 18),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color.fromARGB(255, 18, 18, 18),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.05,
                              ),
                              child: Text(
                                'Reject',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 18, 18, 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

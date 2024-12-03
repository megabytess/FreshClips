import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/admin-features/controller/admin_controller.dart';
import 'package:freshclips_capstone/features/admin-features/screens/admin_check_pending_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminVerifyPage extends StatefulWidget {
  const AdminVerifyPage({
    super.key,
    required this.email,
  });
  final String email;

  @override
  State<AdminVerifyPage> createState() => _AdminVerifyPageState();
}

class _AdminVerifyPageState extends State<AdminVerifyPage> {
  final AdminVerifyController adminVerifyController = AdminVerifyController();

  @override
  void initState() {
    super.initState();
    adminVerifyController.getPendingAccounts(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pending Accounts',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 18, 18, 18),
              ),
            ),
            Gap(screenHeight * 0.02),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: Stream.fromFuture(
                    adminVerifyController.getPendingAccounts(widget.email)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 189, 49, 71),
                      ),
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 189, 49, 71),
                        ),
                      ),
                    );
                  }
                  final pendingUsers = snapshot.data ?? [];
                  if (pendingUsers.isEmpty) {
                    return Center(
                      child: Text(
                        'No pending accounts found.',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: screenWidth * 0.02,
                      mainAxisSpacing: screenHeight * 0.02,
                      childAspectRatio: 1,
                    ),
                    itemCount: pendingUsers.length,
                    itemBuilder: (context, index) {
                      final user = pendingUsers[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdminCheckPendingPage(email: user['email']),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 248, 248, 248),
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.04),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: screenWidth * 0.08,
                                backgroundImage: NetworkImage(
                                  user['imageUrl'] ?? '',
                                ),
                              ),
                              Gap(screenHeight * 0.01),
                              Text(
                                '@${user['username'] ?? 'No username'}',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 48, 65, 69),
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

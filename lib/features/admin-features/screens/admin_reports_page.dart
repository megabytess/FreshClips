import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/admin-features/controller/admin_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key, required this.email});
  final String email;

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  final AdminVerifyController adminVerifyController = AdminVerifyController();

  @override
  void initState() {
    super.initState();
    adminVerifyController.fetchReportedAccounts();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reported accounts',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(screenHeight * 0.01),
            StreamBuilder<List<Map<dynamic, dynamic>>>(
              stream: Stream.fromFuture(
                  adminVerifyController.fetchReportedAccounts()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 189, 49, 71),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No reported accounts found.'),
                  );
                }

                final reportedAccounts = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: reportedAccounts.length,
                    itemBuilder: (context, index) {
                      final account = reportedAccounts[index];
                      final timestamp = account['timeReported'] as Timestamp?;
                      final formattedDateTime = timestamp != null
                          ? DateFormat('MMM d, yyyy - h:mm a')
                              .format(timestamp.toDate())
                          : 'Unknown time';

                      return Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.02,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account['reportedAccountEmail'] ?? 'No Email',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                              Gap(screenHeight * 0.01),
                              Text(
                                account['reason'] ?? 'No Reason',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                              Gap(screenHeight * 0.01),
                              Text(
                                formattedDateTime,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.025,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

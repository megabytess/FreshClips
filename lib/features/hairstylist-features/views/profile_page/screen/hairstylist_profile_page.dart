import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabbar_page/flutter_tabbar_page.dart';
import 'package:freshclips_capstone/core/booking_system/01_booking_template_page.dart';
import 'package:freshclips_capstone/features/admin-features/screens/admin_bs_details_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/message_page/screens/bs_chatroom_mesage_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/hairstylist_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_info_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_review_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_timeline_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairtstylist_portfolio_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HairstylistProfilePage extends StatefulWidget {
  const HairstylistProfilePage({
    super.key,
    required this.email,
    required this.isClient,
    required this.clientEmail,
  });

  final String email;
  final bool isClient;
  final String clientEmail;

  @override
  State<HairstylistProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<HairstylistProfilePage> {
  List<PageTabItemModel> listPages = <PageTabItemModel>[];

  final TabPageController _controller = TabPageController();
  late final HairstylistController hairstylistController =
      HairstylistController();
  late final WorkingHoursController workingHoursController =
      WorkingHoursController(email: widget.email, context: context);
  List<Map<String, dynamic>> availabilityData = [];
  bool isLoading = true;
  String? selectedStoreHours;
  String? currentUserEmail;
  late final TextEditingController reviewController;
  String hairstylistStatus = "Loading...";

  double averageRating = 0.0;
  late RatingsReviewController ratingsReviewController;

  @override
  void initState() {
    listPages.add(PageTabItemModel(
      title: "Info",
      page: HairstylistInfoPage(
        email: widget.email,
        isClient: true,
        userEmail: widget.email,
      ),
    ));
    listPages.add(PageTabItemModel(
      title: "Timeline",
      page: HairstylistTimelinePage(
        email: widget.email,
      ),
    ));
    listPages.add(PageTabItemModel(
      title: "Review",
      page: HairstylistReviewPage(
        clientEmail: widget.clientEmail,
        isClient: widget.isClient,
        email: widget.email,
      ),
    ));
    listPages.add(
      PageTabItemModel(
          title: "Portfolio",
          page: HairstylistPortfolioPage(
            email: widget.email,
            isClient: true,
          )),
    );
    hairstylistController.getHairstylist(widget.email);
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    hairstylistController.loadStatus();

    // Fetch the working hours data
    workingHoursController;
    fetchWorkingHours();
    reviewController = TextEditingController();
    ratingsReviewController = RatingsReviewController(
      clientEmail: widget.clientEmail,
      reviewController: reviewController,
    );
    getAverageRating();
    getHairstylistStatus(widget.email).then((status) {
      setState(() {
        hairstylistStatus = status;
      });
    });
    super.initState();
  }

  Future<String> getHairstylistStatus(String email) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final currentTime = DateTime.now();
      final currentDate =
          DateTime(currentTime.year, currentTime.month, currentTime.day);

      final formattedDate = DateFormat('EEEE, MMMM d, yyyy')
          .format(currentDate); // "Monday, December 9, 2024"
      print(formattedDate);

      final querySnapshot = await firestore
          .collection('availability')
          .where('email', isEqualTo: email)
          .get();

      // DEcember 9, 2024 schedule

      print('email: $email');
      if (querySnapshot.docs.isNotEmpty) {
        // final workingHoursData = querySnapshot.docs.first.data();
        print('not empty querySnapshot');

        for (var doc in querySnapshot.docs) {
          final workingHoursData = doc.data()['workingHours'];

          // Check if the day exists in the workingHours map
          if (workingHoursData != null &&
              workingHoursData.containsKey(formattedDate)) {
            final dayData = workingHoursData[formattedDate];

            // Retrieve openingTime and closingTime as timestamps
            final openingTimeTimestamp = dayData['openingTime'] as Timestamp;
            final closingTimeTimestamp = dayData['closingTime'] as Timestamp;

            // Convert timestamps to DateTime
            final openingTime = openingTimeTimestamp.toDate();
            final closingTime = closingTimeTimestamp.toDate();

            // Check if current time is between openingTime and closingTime
            if (currentTime.isAfter(openingTime) &&
                currentTime.isBefore(closingTime)) {
              return 'AVAILABLE';
            } else {
              return 'NOT AVAILABLE';
            }
          }
        }

        return 'No working hours for today';
      } else {
        print('empty');
      }
    } catch (e) {
      print("Error fetching shop status: $e");
      return "No working hours for today";
    }
    return "SHOP CLOSED"; // Default return statement
  }

  String formatTime(DateTime? dateTime) {
    if (null == dateTime) {
      return 'Not Set';
    }
    return DateFormat('h:mm a').format(dateTime);
  }

  void fetchWorkingHours() async {
    try {
      // Call the fetchWorkingHours method from your controller
      List<WorkingHours> workingHoursList =
          await workingHoursController.fetchWorkingHours(widget.email);

      if (workingHoursList.isNotEmpty) {
        setState(() {
          availabilityData = workingHoursList
              .map((workingHour) => {
                    'day': workingHour.day,
                    'status': workingHour.status,
                    'openingTime': workingHour.openingTime,
                    'closingTime': workingHour.closingTime,
                  })
              .toList();

          if (availabilityData.isNotEmpty) {
            selectedStoreHours =
                availabilityData[0]['status'] ? 'SHOP OPEN' : 'SHOP CLOSED';
          }

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false; // No data available
        });
      }
    } catch (e) {
      print('Error fetching working hours: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch and display the average rating
  void getAverageRating() async {
    final ratingsReviewController = RatingsReviewController(
        clientEmail: widget.email, reviewController: TextEditingController());
    double avgRating =
        await ratingsReviewController.computeAverageRating(widget.clientEmail);
    setState(() {
      averageRating = avgRating;
    });
  }

// GenerateChatRoomId
  String generateChatRoomId(String senderEmail, String receiverEmail) {
    List<String> emails = [senderEmail, receiverEmail];
    emails.sort();
    return emails.join('_');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: hairstylistController,
      builder: (context, child) {
        if (hairstylistController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 189, 49, 71),
              ),
            ),
          );
        }

        final hairstylist = hairstylistController.hairstylist;
        if (hairstylist == null) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 189, 49, 71),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: widget.isClient && currentUserEmail != widget.email
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              : null,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01,
                    ),
                    child: ClipOval(
                      child: Container(
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 186, 199, 206),
                        ),
                        child: Image.network(
                          hairstylistController.hairstylist!.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${hairstylistController.hairstylist!.firstName} ${hairstylistController.hairstylist!.lastName}',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 49, 65, 69),
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/profile_page/star.svg',
                            width: screenWidth * 0.045,
                            height: screenWidth * 0.045,
                          ),
                          Gap(screenHeight * 0.004),
                          FutureBuilder<double>(
                            future: ratingsReviewController
                                .computeAverageRating(widget.email),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 189, 49, 71),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error loading rating',
                                  style: GoogleFonts.poppins(
                                    color:
                                        const Color.fromARGB(255, 49, 65, 69),
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              } else {
                                double rating = snapshot.data ?? 0.0;
                                return Text(
                                  rating.toStringAsFixed(1),
                                  style: GoogleFonts.poppins(
                                    color:
                                        const Color.fromARGB(255, 49, 65, 69),
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Gap(screenHeight * 0.001),
                      Text(
                        hairstylistStatus,
                        style: GoogleFonts.poppins(
                          color: hairstylistStatus == "AVAILABLE"
                              ? Colors.green
                              : Colors.red,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(screenHeight * 0.001),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                  horizontal: screenWidth * 0.05,
                                ),
                                height: screenHeight * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Schedule",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromARGB(
                                            255, 49, 65, 69),
                                      ),
                                    ),
                                    const Divider(),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: availabilityData.length,
                                        itemBuilder: (context, index) {
                                          var dayData = availabilityData[index];

                                          String openingTime = formatTime(
                                              dayData['openingTime']);
                                          String closingTime = formatTime(
                                              dayData['closingTime']);

                                          // Get the day, status, opening time, and closing time values
                                          final String day = dayData['day'] ??
                                              'No day specified';

                                          return ListTile(
                                            title: Text(
                                              day,
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromARGB(
                                                    255, 49, 65, 69),
                                              ),
                                            ),
                                            subtitle: Text(
                                              // Display status and times, with a user-friendly message if times are empty
                                              '${dayData['status'] == true ? 'AVAILABLE' : 'NOT AVAILABLE'} | $openingTime - $closingTime',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 49, 65, 69),
                                              ),
                                            ),
                                            enabled: false, // Non-clickable
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hairstylist Schedule',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 49, 65, 69),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                      Gap(screenHeight * 0.01),
                      if (currentUserEmail != widget.email)
                        Row(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.05,
                              child: OutlinedButton(
                                onPressed: () {
                                  String chatRoomId = generateChatRoomId(
                                      widget.clientEmail, widget.email);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BSChatroomMessagePage(
                                          clientEmail: widget.clientEmail,
                                          userEmail: widget.email,
                                          chatRoomId: chatRoomId,
                                          receiverEmail: widget.email,
                                        );
                                      },
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 48, 65, 59),
                                    width: 1.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: Text(
                                  'Message',
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        const Color.fromARGB(255, 48, 65, 59),
                                  ),
                                ),
                              ),
                            ),
                            Gap(screenWidth * 0.03),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingTemplatePage(
                                      clientEmail: widget.email,
                                      userEmail: widget.email,
                                      shopName: barbershopsalonController
                                              .barbershopsalon?.shopName ??
                                          '',
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 189, 49, 71),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 12.0),
                              ),
                              child: Text(
                                'Book now',
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              Gap(screenHeight * 0.02),
              Expanded(
                child: TabBarPage(
                  controller: _controller,
                  pages: listPages,
                  isSwipable: true,
                  tabBackgroundColor: Colors.transparent,
                  tabitemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _controller.onTabTap(index);
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width /
                            listPages.length,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Center(
                              child: Text(
                                listPages[index].title ?? "",
                                style: GoogleFonts.poppins(
                                  fontWeight: _controller.currentIndex == index
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: _controller.currentIndex == index
                                      ? const Color.fromARGB(255, 49, 65, 69)
                                      : const Color.fromARGB(30, 18, 18, 18),
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ),
                            Container(
                              height: 4,
                              width: screenWidth * 0.18,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.10),
                                gradient: _controller.currentIndex == index
                                    ? const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 189, 49, 71),
                                          Color.fromARGB(255, 255, 106, 0),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : const LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabbar_page/flutter_tabbar_page.dart';
import 'package:freshclips_capstone/core/booking_system/01_booking_template_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_working_hours_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/message_page/screens/bs_chatroom_mesage_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_barbers_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_info_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_reviews_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_timeline_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BSProfilePage extends StatefulWidget {
  const BSProfilePage({
    super.key,
    required this.isClient,
    required this.email,
    required this.clientEmail,
  });

  final bool isClient;
  final String email;
  final String clientEmail;

  @override
  State<BSProfilePage> createState() => _BSProfilePageState();
}

class _BSProfilePageState extends State<BSProfilePage> {
  List<PageTabItemModel> listPages = <PageTabItemModel>[];
  final TabPageController tabPageController = TabPageController();
  final BarbershopSalonController barbershopsalonController =
      BarbershopSalonController();

  late final TextEditingController reviewController;
  List<Map<String, dynamic>> availabilityData = [];
  bool isLoading = false;
  String? selectedStoreHours;
  String? currentUserEmail;
  User? currentUser;
  double averageRating = 0.0;
  late RatingsReviewController ratingsReviewController;
  String shopStatus = "Loading...";
  late BSAvailabilityController availabilityController;

  @override
  void initState() {
    super.initState();
    reviewController = TextEditingController();
    ratingsReviewController = RatingsReviewController(
      clientEmail: widget.clientEmail,
      reviewController: reviewController,
    );
    availabilityController =
        BSAvailabilityController(email: widget.email, context: context);

    listPages.add(
      PageTabItemModel(
        title: "Info",
        page: BSInfoPage(email: widget.email, isClient: true),
      ),
    );
    listPages.add(
      PageTabItemModel(
        title: "Timeline",
        page: BSTimelinePage(
          email: widget.email,
        ),
      ),
    );
    listPages.add(
      PageTabItemModel(
        title: "Review",
        page: BSReviewPage(
          clientEmail: widget.email,
          isClient: true,
          email: widget.email,
        ),
      ),
    );
    listPages.add(
      PageTabItemModel(
        title: "Barbers",
        page: BSBarbersPage(
          userEmail: widget.email,
          isClient: true,
          clientEmail: widget.clientEmail,
        ),
      ),
    );

    barbershopsalonController.getBarbershopSalon(widget.email);
    fetchWorkingHours();
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    getAverageRating();
    fetchShopStatus();
    print('Email in initState: ${widget.email}');
  }

  String formatTime(DateTime? dateTime) {
    if (null == dateTime) {
      return 'Not Set';
    }
    return DateFormat('h:mm a').format(dateTime);
  }

  void fetchWorkingHours() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<WorkingHours> fetchedData =
          await availabilityController.fetchWorkingHoursBS(widget.email);

      setState(() {
        availabilityData = fetchedData.map((workingHour) {
          DateTime parsedDate;
          try {
            parsedDate =
                DateFormat('EEEE, MMMM dd, yyyy').parse(workingHour.day);
          } catch (e) {
            print('Error parsing date: $e');
            parsedDate = DateTime.now();
          }

          return {
            'day': workingHour.day,
            'status': workingHour.status,
            'date': parsedDate.toIso8601String(),
            'openingTime': workingHour.openingTime,
            'closingTime': workingHour.closingTime,
          };
        }).toList();

        availabilityData.sort((a, b) {
          DateTime dateA = DateTime.parse(a['date']);
          DateTime dateB = DateTime.parse(b['date']);
          return dateA.compareTo(dateB);
        });

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching working hours: $e');
    }
  }

  void getAverageRating() async {
    final ratingsReviewController = RatingsReviewController(
        clientEmail: widget.email, reviewController: TextEditingController());
    double avgRating =
        await ratingsReviewController.computeAverageRating(widget.clientEmail);
    setState(() {
      averageRating = avgRating;
    });
  }

  void fetchShopStatus() async {
    final status = await getShopStatus(widget.email);

    setState(() {
      shopStatus = status;
    });
  }

  Future<String> getShopStatus(String email) async {
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

            // Check if 'status' is true or false for the current day
            // final status = dayData['status'];

            // Retrieve openingTime and closingTime as timestamps
            final openingTimeTimestamp = dayData['openingTime'] as Timestamp;
            final closingTimeTimestamp = dayData['closingTime'] as Timestamp;

            // Convert timestamps to DateTime
            final openingTime = openingTimeTimestamp.toDate();
            final closingTime = closingTimeTimestamp.toDate();

            // Check if current time is between openingTime and closingTime
            if (currentTime.isAfter(openingTime) &&
                currentTime.isBefore(closingTime)) {
              return 'SHOP OPEN';
            } else {
              return 'SHOP CLOSED';
            }
          }
        }

        return 'No working hours for today';
      } else {
        print('empty');
      }
    } catch (e) {
      print("Error fetching shop status: $e");
      return "No available working hours";
    }
    return "SHOP CLOSED"; // Default return
  }

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
      animation: barbershopsalonController,
      builder: (context, snapshot) {
        if (barbershopsalonController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 189, 49, 71),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 248, 248, 248),
          appBar: (widget.isClient && currentUserEmail != widget.email)
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
                        child: (barbershopsalonController
                                        .barbershopsalon?.imageUrl !=
                                    null &&
                                barbershopsalonController
                                    .barbershopsalon!.imageUrl.isNotEmpty)
                            ? Image.network(
                                barbershopsalonController
                                    .barbershopsalon!.imageUrl,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.person, size: 50),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barbershopsalonController.barbershopsalon!.shopName,
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 48, 65, 69),
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
                          StreamBuilder<double>(
                            stream: ratingsReviewController
                                .computeAverageRating(widget.email)
                                .asStream(),
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
                                        const Color.fromARGB(255, 48, 65, 69),
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
                                        const Color.fromARGB(255, 48, 65, 69),
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Text(
                        shopStatus,
                        style: GoogleFonts.poppins(
                          color: shopStatus == "SHOP OPEN"
                              ? Colors.green
                              : Colors.red,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                                      "Available Dates",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromARGB(
                                            255, 48, 65, 69),
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

                                          return ListTile(
                                            title: Text(
                                              dayData['day'],
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromARGB(
                                                    255, 48, 65, 69),
                                              ),
                                            ),
                                            subtitle: Text(
                                              '${dayData['status'] == true ? 'Shop Open' : 'Shop Closed'} | $openingTime - $closingTime',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 48, 65, 69),
                                              ),
                                            ),
                                            enabled: false,
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
                              'Shop availability',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 48, 65, 69),
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
                                          .barbershopsalon!.shopName,
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
                            )
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              Gap(screenHeight * 0.01),
              Flexible(
                child: TabBarPage(
                  controller: tabPageController,
                  pages: listPages,
                  isSwipable: true,
                  tabBackgroundColor: Colors.transparent,
                  tabitemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        tabPageController.onTabTap(index);
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
                                  fontWeight:
                                      tabPageController.currentIndex == index
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                  color: tabPageController.currentIndex == index
                                      ? const Color.fromARGB(255, 48, 65, 69)
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
                                gradient:
                                    tabPageController.currentIndex == index
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

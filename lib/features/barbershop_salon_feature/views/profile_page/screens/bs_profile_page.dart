import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabbar_page/flutter_tabbar_page.dart';
import 'package:freshclips_capstone/core/booking_system/01_booking_template_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_barbers_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_info_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_reviews_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_timeline_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late final WorkingHoursController workingHoursController =
      WorkingHoursController(email: widget.email, context: context);
  late final TextEditingController reviewController;
  List<Map<String, String?>> availabilityData = [];
  bool isLoading = false;
  String? selectedStoreHours;
  String? currentUserEmail;

  double averageRating = 0.0;
  late RatingsReviewController ratingsReviewController;

  @override
  void initState() {
    super.initState();
    reviewController = TextEditingController();
    ratingsReviewController = RatingsReviewController(
      clientEmail: widget.clientEmail,
      reviewController: reviewController,
    );

    listPages.add(
      PageTabItemModel(
        title: "Info",
        page: BSInfoPage(email: widget.email, isClient: true),
      ),
    );
    listPages.add(
      PageTabItemModel(
        title: "Timeline",
        page: const BSTimelinePage(),
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
        ),
      ),
    );
    barbershopsalonController.getBarbershopSalon(widget.email);
    barbershopsalonController.loadStatus();

    workingHoursController;
    fetchWorkingHours();
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    getAverageRating();
  }

  void fetchWorkingHours() async {
    try {
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
            selectedStoreHours = availabilityData[0]['status'];
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

  void getAverageRating() async {
    final ratingsReviewController = RatingsReviewController(
        clientEmail: widget.email, reviewController: TextEditingController());
    double avgRating =
        await ratingsReviewController.computeAverageRating(widget.clientEmail);
    setState(() {
      averageRating = avgRating;
    });
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
                          color: const Color.fromARGB(255, 18, 18, 18),
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
                                    color: Colors.black,
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
                                        const Color.fromARGB(255, 18, 18, 18),
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
                      widget.isClient && currentUserEmail != widget.email
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  barbershopsalonController.selectedStatus,
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.032,
                                    fontWeight: FontWeight.w700,
                                    color: barbershopsalonController
                                                .selectedStatus ==
                                            'SHOP OPEN'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02,
                                        horizontal: screenWidth * 0.03,
                                      ),
                                      height: screenHeight * 0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Select Status',
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            title: Text(
                                              'SHOP OPEN',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                            onTap: () {
                                              barbershopsalonController
                                                  .updateStatus('SHOP OPEN');
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text(
                                              'SHOP CLOSED',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                            onTap: () {
                                              barbershopsalonController
                                                  .updateStatus('SHOP CLOSED');
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    barbershopsalonController.selectedStatus,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.032,
                                      fontWeight: FontWeight.w700,
                                      color: barbershopsalonController
                                                  .selectedStatus ==
                                              'SHOP OPEN'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
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
                                      "Shop Hours",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Divider(),
                                    Flexible(
                                      child: ListView.builder(
                                        itemCount: availabilityData.length,
                                        itemBuilder: (context, index) {
                                          // Retrieve the WorkingHours object for the current day
                                          Map<String, String> dayData =
                                              availabilityData[index]
                                                  .cast<String, String>();

                                          // Get the day, status, opening time, and closing time values
                                          final String day = dayData['day'] ??
                                              'No day specified';
                                          final String status =
                                              dayData['status'] ??
                                                  'Status not available';
                                          final String openingTime =
                                              dayData['openingTime']
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? dayData['openingTime']!
                                                  : 'No opening time specified';
                                          final String closingTime =
                                              dayData['closingTime']
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? dayData['closingTime']!
                                                  : 'No closing time specified';

                                          return ListTile(
                                            title: Text(
                                              day,
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                            subtitle: Text(
                                              // Display status and times, with a user-friendly message if times are empty
                                              '$status | $openingTime - $closingTime',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
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
                                color: const Color.fromARGB(255, 18, 18, 18),
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
                                  // Add your button action here
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
                                      // accountName: barbershopsalonController
                                      //     .barbershopsalon!.shopName,
                                      userEmail: widget.email,
                                      // userType:
                                      //     widget.isClient ? 'Client' : 'Owner',
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
                                      ? const Color.fromARGB(255, 18, 18, 18)
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

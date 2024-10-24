import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabbar_page/flutter_tabbar_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/hairstylist_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_info_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_review_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_timeline_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairtstylist_portfolio_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HairstylistProfilePage extends StatefulWidget {
  const HairstylistProfilePage({super.key, required this.email});

  final String email;

  @override
  State<HairstylistProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<HairstylistProfilePage> {
  List<PageTabItemModel> listPages = <PageTabItemModel>[];
  final TabPageController _controller = TabPageController();
  final HairstylistController hairstylistController = HairstylistController();
  late final WorkingHoursController workingHoursController =
      WorkingHoursController(email: widget.email, context: context);
  List<Map<String, String>> availabilityData = [];
  bool isLoading = true;
  String? selectedStoreHours;

  @override
  void initState() {
    listPages.add(PageTabItemModel(
      title: "Info",
      page: HairstylistInfoPage(
        email: widget.email,
      ),
    ));
    listPages.add(PageTabItemModel(
      title: "Timeline",
      page: const HairstylistTimelinePage(),
    ));
    listPages.add(PageTabItemModel(
      title: "Review",
      page: const HairstylistReviewPage(),
    ));
    listPages.add(
      PageTabItemModel(
          title: "Portfolio",
          page: HairstylistPortfolioPage(
            email: widget.email,
          )),
    );

    hairstylistController.getHairstylist(widget.email);
    hairstylistController.loadStatus();

    // Fetch the working hours data
    workingHoursController;
    fetchWorkingHours();
    super.initState();
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
                  })
              .toList();

          if (availabilityData.isNotEmpty) {
            selectedStoreHours =
                availabilityData[0]['status']; // Default to the first option
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
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

        // Null check for hairstylist data
        final hairstylist = hairstylistController.hairstylist;
        if (hairstylist == null) {
          return const Center(
            child: Text('No hairstylist data available'),
          );
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 248, 248, 248),
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
                        child: (hairstylistController.hairstylist?.imageUrl !=
                                null)
                            ? Image.network(
                                hairstylistController.hairstylist!.imageUrl,
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
                        '${hairstylist.firstName} ${hairstylist.lastName}',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 18, 18, 18),
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '4.8', // Example rating
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 18, 18, 18),
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Gap(screenHeight * 0.002),
                          SvgPicture.asset(
                            'assets/images/profile_page/star.svg',
                            width: screenWidth * 0.045,
                            height: screenWidth * 0.045,
                          ),
                        ],
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
                                  horizontal: screenWidth * 0.03,
                                ),
                                height: screenHeight * 0.3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        hairstylistController
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
                                        hairstylistController
                                            .updateStatus('SHOP CLOSED');
                                        Navigator.pop(
                                            context); // Close the modal
                                      },
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
                              hairstylistController.selectedStatus,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.032,
                                fontWeight: FontWeight.w700,
                                color: hairstylistController.selectedStatus ==
                                        'SHOP OPEN'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            // const Icon(Icons.arrow_drop_down),
                          ],
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
                                      "Shop Hours",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Divider(),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: availabilityData.length,
                                        itemBuilder: (context, index) {
                                          final hours = availabilityData[index];
                                          return ListTile(
                                            title: Text(
                                              hours['day']!,
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                            subtitle: Text(
                                              hours['status']!,
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                            // Remove the onTap to make it non-clickable
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
                    ],
                  ),
                ],
              ),
              Gap(screenHeight * 0.01),
              TabBarPage(
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
                      width:
                          MediaQuery.of(context).size.width / listPages.length,
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
            ],
          ),
        );
      },
    );
  }
}

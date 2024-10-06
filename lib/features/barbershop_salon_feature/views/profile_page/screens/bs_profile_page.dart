import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabbar_page/flutter_tabbar_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_barbers_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_info_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_reviews_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_timeline_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSProfilePage extends StatefulWidget {
  const BSProfilePage({super.key});

  @override
  State<BSProfilePage> createState() => _BSProfilePageState();
}

class _BSProfilePageState extends State<BSProfilePage> {
  List<PageTabItemModel> listPages = <PageTabItemModel>[];
  final TabPageController _controller = TabPageController();

  @override
  void initState() {
    super.initState();
    listPages.add(
      PageTabItemModel(
        title: "Info",
        page: const BSInfoPage(),
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
        page: const BSReviewPage(),
      ),
    );
    listPages.add(
      PageTabItemModel(
        title: "Barbers",
        page: const BSBarbersPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  // Profile Picture
                  child: Container(
                    width: screenWidth * 0.25,
                    height: screenWidth * 0.25,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 186, 199, 206),
                    ),
                    child: Image.asset(
                      'assets/images/icons/launcher_icon.png',
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // Profile Name
                    'Sample Barbershop',
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 18, 18, 18),
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        // Profile Rating
                        '4.8',
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
                  Text(
                    'OPEN NOW', // Status (Maybe change to open/close.. or add a switch)
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Mon-Fri  9:00 AM - 6:00 PM', // Working Hours
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 18, 18, 18),
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(screenHeight * 0.01),
                ],
              ),
            ],
          ),
          Gap(
            screenHeight * 0.01,
          ),
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
                  width: MediaQuery.of(context).size.width / listPages.length,
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
                              fontSize: screenWidth * 0.035),
                        ),
                      ),
                      Container(
                        // Tab Indicator
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
  }
}

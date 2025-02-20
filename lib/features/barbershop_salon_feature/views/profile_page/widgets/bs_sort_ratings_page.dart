import 'package:flutter/material.dart';
import 'package:flutter_tabbar_page/flutter_tabbar_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/tabBar_ratings/1_star_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/tabBar_ratings/2_star_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/tabBar_ratings/3_star_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/tabBar_ratings/4_star_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/tabBar_ratings/5_star_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSSortRatingPage extends StatefulWidget {
  const BSSortRatingPage(
      {super.key, required this.email, required this.clientEmail});
  final String email;
  final String clientEmail;

  @override
  State<BSSortRatingPage> createState() => _BSSortRatingPageState();
}

class _BSSortRatingPageState extends State<BSSortRatingPage> {
  final TabPageController tabPageController = TabPageController();
  List<PageTabItemModel> listPages = <PageTabItemModel>[];

  @override
  void initState() {
    super.initState();

    listPages.add(
      PageTabItemModel(
        title: "5",
        page: FiveStarPage(
          email: widget.email,
          clientEmail: widget.clientEmail,
        ),
      ),
    );
    listPages.add(
      PageTabItemModel(
        title: "4",
        page: FourStarPage(
          email: widget.email,
          clientEmail: widget.clientEmail,
        ),
      ),
    );
    listPages.add(
      PageTabItemModel(
        title: "3",
        page: ThreeStarPage(
          email: widget.email,
          clientEmail: widget.clientEmail,
        ),
      ),
    );
    listPages.add(
      PageTabItemModel(
        title: "2",
        page: TwoStarPage(
          email: widget.email,
          clientEmail: widget.clientEmail,
        ),
      ),
    );
    listPages.add(
      PageTabItemModel(
        title: "1",
        page: OneStarPage(
          email: widget.email,
          clientEmail: widget.clientEmail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Ratings & Reviews',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 65, 69),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: TabBarPage(
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
              width: MediaQuery.of(context).size.width / listPages.length,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          listPages[index].title ?? "",
                          style: GoogleFonts.poppins(
                            fontWeight: tabPageController.currentIndex == index
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: tabPageController.currentIndex == index
                                ? const Color.fromARGB(255, 48, 65, 69)
                                : const Color.fromARGB(30, 18, 18, 18),
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                        Gap(screenWidth * 0.01),
                        Icon(
                          Icons.star_rate_rounded,
                          color: tabPageController.currentIndex == index
                              ? const Color.fromARGB(255, 255, 166, 0)
                              : const Color.fromARGB(100, 255, 166, 0),
                          size: screenWidth * 0.06,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 4,
                    width: screenWidth * 0.18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.10),
                      gradient: tabPageController.currentIndex == index
                          ? const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 189, 49, 71),
                                Color.fromARGB(255, 255, 106, 0),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : const LinearGradient(
                              colors: [Colors.transparent, Colors.transparent],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

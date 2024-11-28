import 'package:flutter/material.dart';
import 'package:flutter_tabbar_page/flutter_tabbar_page.dart';
import 'package:freshclips_capstone/features/client-features/views/bottomnav_bar/tab_bar_page.dart/client_approved_page.dart';
import 'package:freshclips_capstone/features/client-features/views/bottomnav_bar/tab_bar_page.dart/client_declined_page.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientTabBarPage extends StatefulWidget {
  const ClientTabBarPage({
    super.key,
    required this.clientEmail,
  });
  final String clientEmail;

  @override
  State<ClientTabBarPage> createState() => _ClientTabBarPageState();
}

class _ClientTabBarPageState extends State<ClientTabBarPage> {
  List<PageTabItemModel> listPages = <PageTabItemModel>[];
  final TabPageController _controller = TabPageController();

  @override
  void initState() {
    super.initState();

    listPages.add(
      PageTabItemModel(
        title: "Approved",
        page: ClientApprovedPage(
          clientEmail: widget.clientEmail,
        ),
      ),
    );

    listPages.add(
      PageTabItemModel(
        title: "Declined",
        page: ClientDeclinedPage(
          clientEmail: widget.clientEmail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return TabBarPage(
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
                        fontSize: screenWidth * 0.033),
                  ),
                ),
                Container(
                  // Tab Indicator
                  height: 4,
                  width: screenWidth * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.10),
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
                            colors: [Colors.transparent, Colors.transparent],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

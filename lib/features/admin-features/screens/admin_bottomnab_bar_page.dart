import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshclips_capstone/features/admin-features/screens/admin_reports_page.dart';
import 'package:freshclips_capstone/features/admin-features/screens/admin_users_page.dart';
import 'package:freshclips_capstone/features/admin-features/screens/admin_verify_page.dart';
import 'package:freshclips_capstone/features/auth/views/screens/login/landing_page.dart';
import 'package:google_fonts/google_fonts.dart';

class AdmingBottomNavbar extends StatefulWidget {
  const AdmingBottomNavbar({super.key, required this.email});
  final String email;

  @override
  State<AdmingBottomNavbar> createState() => _AdmingBottomNavbarState();
}

class _AdmingBottomNavbarState extends State<AdmingBottomNavbar> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AdminVerifyPage(
        email: widget.email,
      ),
      AdminUsersPage(
        email: widget.email,
      ),
      AdminReportsPage(
        email: widget.email,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(
          'assets/images/landing_page/freshclips_logo.svg',
          height: screenHeight * 0.05,
          width: screenWidth * 0.05,
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.15,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(screenWidth * 0.03),
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/icons/drawer_pic.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(screenWidth * 0.03),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.07,
                    left: screenWidth * 0.07,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'FRESH',
                                style: TextStyle(
                                  fontFamily: 'Wetzilla-eZap6',
                                  fontSize: screenHeight * 0.052,
                                  fontWeight: FontWeight.w800,
                                  color:
                                      const Color.fromARGB(255, 248, 248, 248),
                                ),
                              ),
                              TextSpan(
                                text: ' CLIPS',
                                style: TextStyle(
                                  fontFamily: 'Asterone DEMO',
                                  fontSize: screenHeight * 0.040,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      const Color.fromARGB(255, 248, 248, 248),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                top: screenHeight * 0.77,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LandingPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.034,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 248, 248, 248),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.verified_user_rounded,
              size: 24,
              color: _selectedIndex == 0
                  ? const Color.fromARGB(255, 189, 49, 71)
                  : const Color.fromARGB(50, 23, 23, 23),
            ),
            label: 'Verify',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_alt_rounded,
              size: 24,
              color: _selectedIndex == 1
                  ? const Color.fromARGB(255, 189, 49, 71)
                  : const Color.fromARGB(50, 23, 23, 23),
            ),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.report_rounded,
              size: 24,
              color: _selectedIndex == 2
                  ? const Color.fromARGB(255, 189, 49, 71)
                  : const Color.fromARGB(50, 23, 23, 23),
            ),
            label: 'Reports',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        showUnselectedLabels: true,
        selectedItemColor: const Color.fromARGB(255, 189, 49, 71),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/auth/views/screens/login/landing_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_appointment_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/bottomnav_bar/settings_drawer/manage_availability/bs_manage_availability_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/bottomnav_bar/settings_drawer/profile_details/bs_profile_details_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/home_page/screens/bs_home_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/message_page/screens/bs_message_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_profile_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSBottomNavBarPage extends StatefulWidget {
  const BSBottomNavBarPage({
    super.key,
    required this.email,
    required this.userEmail,
  });

  final String email;
  final String userEmail;
  final bool isClient = true;

  @override
  State<BSBottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BSBottomNavBarPage> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BSHomePage(
        email: widget.email,
      ),
      BSAppointmentPage(
        userEmail: widget.userEmail,
        clientEmail: widget.email,
        isClient: widget.isClient,
      ),
      BSMessagePage(
        userEmail: widget.userEmail,
        clientEmail: widget.email,
      ),
      BSProfilePage(
        isClient: false,
        email: widget.email,
        clientEmail: widget.email,
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
                    top: screenHeight * 0.06,
                    left: screenWidth * 0.05,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'FRESH',
                            style: TextStyle(
                              fontFamily: 'Wetzilla-eZap6',
                              fontSize: screenHeight * 0.052,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromARGB(255, 248, 248, 248),
                            ),
                          ),
                          TextSpan(
                            text: ' CLIPS',
                            style: TextStyle(
                              fontFamily: 'Asterone DEMO',
                              fontSize: screenHeight * 0.040,
                              fontWeight: FontWeight.w700,
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
            Gap(screenHeight * 0.01),
            ListTile(
              leading: Icon(
                Icons.person_rounded,
                color: const Color.fromARGB(255, 48, 65, 69),
                size: screenWidth * 0.07,
              ),
              title: Text(
                'Profile details',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.04,
                color: const Color.fromARGB(255, 48, 65, 69),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BSProfileDetailsPage(
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
            Gap(screenHeight * 0.01),
            ListTile(
              leading: Icon(
                Icons.calendar_month_rounded,
                color: const Color.fromARGB(255, 48, 65, 69),
                size: screenWidth * 0.07,
              ),
              title: Text(
                'Manage availability',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.04,
                color: const Color.fromARGB(255, 48, 65, 69),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BSManageAvailabilityPage(email: widget.email),
                  ),
                );
              },
            ),
            Gap(screenHeight * 0.62),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                    SizedBox(width: screenWidth * 0.001),
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
            )
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/bottomnav_bar_page/home_fill.svg',
              height: screenHeight * 0.03,
              width: screenWidth * 0.03,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0
                    ? const Color.fromARGB(255, 189, 49, 71)
                    : const Color.fromARGB(50, 23, 23, 23),
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/bottomnav_bar_page/calendar_fill.svg',
              height: screenHeight * 0.03,
              width: screenWidth * 0.03,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1
                    ? const Color.fromARGB(255, 189, 49, 71)
                    : const Color.fromARGB(50, 23, 23, 23),
                BlendMode.srcIn,
              ),
            ),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/bottomnav_bar_page/message_fill.svg',
              height: screenHeight * 0.03,
              width: screenWidth * 0.03,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 2
                    ? const Color.fromARGB(255, 189, 49, 71)
                    : const Color.fromARGB(50, 23, 23, 23),
                BlendMode.srcIn,
              ),
            ),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/bottomnav_bar_page/user_fill.svg',
              height: screenHeight * 0.03,
              width: screenWidth * 0.03,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 3
                    ? const Color.fromARGB(255, 189, 49, 71)
                    : const Color.fromARGB(50, 23, 23, 23),
                BlendMode.srcIn,
              ),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 189, 49, 71),
        unselectedItemColor: const Color.fromARGB(50, 23, 23, 23),
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: screenWidth * 0.03,
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: screenWidth * 0.035,
          fontWeight: FontWeight.w400,
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/auth/views/screens/login/landing_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/appointment_page/screens/hairstylist_appointment_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/bottomnav_bar/settings_drawer/settings_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/home_page/screens/hairstylist_home_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/message_page/screen/hairstylist_message_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_profile_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({
    super.key,
    required this.email,
    required this.userId,
    required this.clientEmail,
  });
  final String email;
  final String userId;
  final String clientEmail;

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _selectedIndex = 0;

  // List of screens for each tab
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HairstylistHomePage(),
      HairstylistAppointmentPage(
        userEmail: widget.email,
        clientEmail: widget.clientEmail,
        isClient: true,
      ),
      HairstylistMessagePage(),
      HairstylistProfilePage(
        email: widget.email,
        isClient: false,
        clientEmail: widget.clientEmail,
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
            ListTile(
              leading: SvgPicture.asset(
                'assets/images/bottomnav_bar_page/home_fill.svg',
                width: screenWidth * 0.06,
                colorFilter: const ColorFilter.mode(
                    Color.fromARGB(255, 48, 65, 69), BlendMode.srcIn),
              ),
              title: Text(
                'Home',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 18, 18, 18),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.04,
                color: const Color.fromARGB(255, 18, 18, 18),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/images/bottomnav_bar_page/calendar_fill.svg',
                width: screenWidth * 0.06,
                colorFilter: const ColorFilter.mode(
                    Color.fromARGB(255, 48, 65, 69), BlendMode.srcIn),
              ),
              title: Text(
                'Calendar',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 18, 18, 18),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.04,
                color: const Color.fromARGB(255, 18, 18, 18),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/images/bottomnav_bar_page/message_fill.svg',
                width: screenWidth * 0.06,
                colorFilter: const ColorFilter.mode(
                    Color.fromARGB(255, 48, 65, 69), BlendMode.srcIn),
              ),
              title: Text(
                'Message',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 18, 18, 18),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.04,
                color: const Color.fromARGB(255, 18, 18, 18),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person_rounded,
                size: screenWidth * 0.076,
                color: const Color.fromARGB(255, 48, 65, 69),
              ),
              title: Text(
                'Profile',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 18, 18, 18),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.04,
                color: const Color.fromARGB(255, 18, 18, 18),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 3;
                });
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 189, 189, 189),
              thickness: 1.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            ListTile(
              leading: Icon(
                Icons.settings_rounded,
                color: const Color.fromARGB(255, 48, 65, 69),
                size: screenWidth * 0.07,
              ),
              title: Text(
                'Settings',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 18, 18, 18),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.04,
                color: const Color.fromARGB(255, 18, 18, 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
            Gap(screenHeight * 0.45),
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

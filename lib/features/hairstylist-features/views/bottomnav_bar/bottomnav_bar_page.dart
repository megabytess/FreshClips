import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/appointment_page/screens/appointment_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/home_page/screens/home_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/message_page/screen/message_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _selectedIndex = 0;

  // List of screens for each tab
  final List<Widget> _pages = [
    const HomePage(),
    const AppointmentPage(),
    const MessagePage(),
    const ProfilePage(),
  ];

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset(
          'assets/images/icons/logo_icon.png',
          height: screenHeight * 0.20,
          width: screenWidth * 0.20,
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/bottomnav_bar_page/home_fill.svg',
              height: screenHeight * 0.04,
              width: screenWidth * 0.04,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0
                    ? const Color.fromARGB(255, 189, 49, 71)
                    : const Color.fromARGB(180, 23, 23, 23),
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/bottomnav_bar_page/calendar_fill.svg',
              height: screenHeight * 0.04,
              width: screenWidth * 0.04,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1
                    ? const Color.fromARGB(255, 189, 49, 71)
                    : const Color.fromARGB(180, 23, 23, 23),
                BlendMode.srcIn,
              ),
            ),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/bottomnav_bar_page/message_fill.svg',
              height: screenHeight * 0.04,
              width: screenWidth * 0.04,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 2
                    ? const Color.fromARGB(255, 189, 49, 71)
                    : const Color.fromARGB(180, 23, 23, 23),
                BlendMode.srcIn,
              ),
            ),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/bottomnav_bar_page/user_fill.svg',
              height: screenHeight * 0.04,
              width: screenWidth * 0.04,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 3
                    ? const Color.fromARGB(255, 189, 49, 71)
                    : const Color.fromARGB(180, 23, 23, 23),
                BlendMode.srcIn,
              ),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 189, 49, 71),
        unselectedItemColor: const Color.fromARGB(180, 23, 23, 23),
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

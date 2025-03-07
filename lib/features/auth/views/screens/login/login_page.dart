import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshclips_capstone/features/admin-features/screens/admin_bottomnab_bar_page.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/declined_account_page.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/pending_account_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/bottomnav_bar/bs_bottomnav_bar.dart';
import 'package:freshclips_capstone/features/client-features/views/bottomnav_bar/client_bottomnav_bar.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/bottomnav_bar/bottomnav_bar_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  // Firebase Auth instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    emailController.text = '@gmail.com';
    passwordController.text = '123456789';
    super.initState();
  }

  // Method to sign in the user
  void loginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (emailController.text.trim() == 'superadmin@freshclips.com' &&
          passwordController.text.trim() == '123456789') {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => AdmingBottomNavbar(
                    email: emailController.text,
                  )),
        );
        return;
      }

      // Get the current user's UID
      String userId = userCredential.user!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (userDoc.exists) {
        String userType = userDoc.get('userType');
        String accountStatus = userDoc.get('accountStatus');

        print("Account Status: $accountStatus");
        print("User Type: $userType");

        if (userType == 'Hairstylist' && accountStatus == 'Approved') {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBarPage(
                email: emailController.text,
                userId: userId,
                clientEmail: emailController.text,
              ),
            ),
          );
        } else if (userType == 'Hairstylist' && accountStatus == 'Pending') {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => PendingAccountPage(),
            ),
          );
        } else if (userType == 'Hairstylist' && accountStatus == 'Declined') {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => DeclinedAccountPage(
                rejectionReason: userDoc.get('rejectionReason'),
                email: emailController.text,
              ),
            ),
          );
        } else if (userType == 'Barbershop_Salon' &&
            accountStatus == 'Approved') {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => BSBottomNavBarPage(
                      email: emailController.text,
                      userEmail: emailController.text,
                    )),
          );
        } else if (userType == 'Barbershop_Salon' &&
            accountStatus == 'Pending') {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => PendingAccountPage(),
            ),
          );
        } else if (userType == 'Barbershop_Salon' &&
            accountStatus == 'Declined') {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => DeclinedAccountPage(
                rejectionReason: userDoc.get('rejectionReason'),
                email: emailController.text,
              ),
            ),
          );
        } else if (userType == 'Client' && accountStatus == 'Approved') {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => ClientBottomNavBarPage(
                      email: emailController.text,
                      clientEmail: emailController.text,
                    )),
          );
        }
      } else {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('User data not found.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle login errors
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
        title: SvgPicture.asset(
          'assets/images/landing_page/freshclips_logo.svg',
          height: screenHeight * 0.05,
          width: screenWidth * 0.05,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
            ),
            child: Text(
              'Welcome back!\nStay Fresh, Stay Confident',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 48, 65, 69),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.03,
            ),
            child: TextFormField(
              controller: emailController,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: const Color.fromARGB(255, 48, 65, 69),
              ),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: const Color.fromARGB(255, 186, 199, 206),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 48, 65, 69),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 48, 65, 69),
                  ),
                  borderRadius: BorderRadius.circular(
                    screenWidth * 0.03,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
            ),
            child: TextFormField(
              controller: passwordController, // Password text field
              obscureText: _obscureText,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: const Color.fromARGB(255, 48, 65, 69),
              ),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: const Color.fromARGB(255, 186, 199, 206),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 48, 65, 69),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 48, 65, 69),
                  ),
                  borderRadius: BorderRadius.circular(
                    screenWidth * 0.03,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 186, 199, 206),
                  ),
                ),
              ),
            ),
          ),
          Gap(screenHeight * 0.02),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
            ),
          ),
          Gap(screenHeight * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
            ),
            child: SizedBox(
              width: double.infinity,
              height: screenHeight * 0.07,
              child: ElevatedButton(
                onPressed: () {
                  loginUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 189, 49, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

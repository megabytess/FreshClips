import 'package:flutter/material.dart';

class HairstylistAppointmentPage extends StatelessWidget {
  const HairstylistAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Container(
        child: Center(
          child: Text(
            'Appointment Page',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

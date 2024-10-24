// import 'package:flutter/material.dart';
// import 'package:freshclips_capstone/features/hairstylist-features/controllers/working_hours_controller.dart';
// import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EditWorkingHoursPage extends StatefulWidget {
//   final WorkingHoursController controller;

//   const EditWorkingHoursPage({super.key, required this.controller});

//   @override
//   State<EditWorkingHoursPage> createState() => _EditWorkingHoursPageState();
// }

// class _EditWorkingHoursPageState extends State<EditWorkingHoursPage> {
//   List<WorkingHours> workingHours = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchWorkingHours();
//   }

//   void fetchWorkingHours() async {
//     workingHours = await widget.controller.fetchWorkingHours();
//     setState(() {});
//   }

//   Future<void> editHours(WorkingHours hours) async {
//     TimeOfDay? startTime = await widget.controller.pickTime(
//         TimeOfDay(hour: hours.startTime.hour, minute: hours.startTime.minute));
//     if (startTime != null) {
//       hours.startTime = DateTime(
//         hours.startTime.year,
//         hours.startTime.month,
//         hours.startTime.day,
//         startTime.hour,
//         startTime.minute,
//       );
//     }

//     TimeOfDay? endTime = await widget.controller.pickTime(
//         TimeOfDay(hour: hours.endTime.hour, minute: hours.endTime.minute));
//     if (endTime != null) {
//       hours.endTime = DateTime(
//         hours.endTime.year,
//         hours.endTime.month,
//         hours.endTime.day,
//         endTime.hour,
//         endTime.minute,
//       );
//     }

//     await widget.controller.editWorkingHours(hours);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Working Hours', style: GoogleFonts.poppins()),
//       ),
//       body: ListView.builder(
//         itemCount: workingHours.length,
//         itemBuilder: (context, index) {
//           final hours = workingHours[index];

//           return ListTile(
//             title: Text(hours.day, style: GoogleFonts.poppins()),
//             subtitle: Text(
//                 '${TimeOfDay(hour: hours.startTime.hour, minute: hours.startTime.minute).format(context)} - ${TimeOfDay(hour: hours.endTime.hour, minute: hours.endTime.minute).format(context)}',
//                 style: GoogleFonts.poppins()),
//             trailing: IconButton(
//               icon: Icon(
//                 Icons.edit,
//                 size: screenWidth * 0.04,
//               ),
//               onPressed: () => editHours(hours),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

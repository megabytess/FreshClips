import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/admin-features/controller/admin_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

final AdminVerifyController adminVerifyController = AdminVerifyController();

class _AdminUsersPageState extends State<AdminUsersPage> {
  int currentIndex = 0;

  late final List<TabPageModel> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      TabPageModel(
        title: 'Clients',
        content: const Center(
          child: Text('Clients Page'),
        ),
      ),
      TabPageModel(
        title: 'Hairstylists',
        content: const Center(
          child: Text('Hairstylists Page'),
        ),
      ),
      TabPageModel(
        title: 'Shops',
        content: const Center(
          child: Text('Barbershop_Salon Page'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Column(
        children: [
          Flexible(
            child: TabBarPage(
              controller: this,
              pages: pages,
              isSwipable: true,
              tabBackgroundColor: Colors.transparent,
              tabitemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  child: SizedBox(
                    width: screenWidth / pages.length,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Center(
                          child: Text(
                            pages[index].title ?? "",
                            style: GoogleFonts.poppins(
                              fontWeight: currentIndex == index
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: currentIndex == index
                                  ? const Color.fromARGB(255, 18, 18, 18)
                                  : const Color.fromARGB(30, 18, 18, 18),
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ),
                        Container(
                          height: 4,
                          width: screenWidth * 0.18,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.10),
                            gradient: currentIndex == index
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
          ),
          Expanded(
            child: pages[currentIndex].content,
          ),
        ],
      ),
    );
  }
}

class TabPageModel {
  final String? title;
  final Widget content;

  TabPageModel({this.title, required this.content});
}

class TabBarPage extends StatelessWidget {
  final _AdminUsersPageState controller;
  final List<TabPageModel> pages;
  final bool isSwipable;
  final Color tabBackgroundColor;
  final Widget Function(BuildContext, int) tabitemBuilder;

  const TabBarPage({
    super.key,
    required this.controller,
    required this.pages,
    this.isSwipable = true,
    required this.tabBackgroundColor,
    required this.tabitemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tabBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          pages.length,
          (index) => tabitemBuilder(context, index),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_profile_page.dart';
import 'package:freshclips_capstone/features/client-features/controllers/search_controller.dart'
    as custom;
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_profile_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientMessagePage extends StatefulWidget {
  final String email;

  const ClientMessagePage({super.key, required this.email});

  @override
  ClientMessagePageState createState() => ClientMessagePageState();
}

class ClientMessagePageState extends State<ClientMessagePage> {
  final TextEditingController searchInputController = TextEditingController();
  final custom.SearchController searchController = custom.SearchController();
  List<Map<String, dynamic>> searchResults = [];

  void showSearchModal(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.08,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchInputController,
                decoration: InputDecoration(
                  hintText: 'Search user',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 18, 18, 18)),
                onChanged: (value) async {
                  if (value.isEmpty) {
                    setState(() {
                      searchResults = [];
                    });
                  } else {
                    final results = await searchController.searchProfile(value);

                    setState(() {
                      searchResults = results;
                    });
                  }
                },
              ),
              Gap(screenHeight * 0.02),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: Stream.fromFuture(
                    searchController.searchProfile(searchInputController.text),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Color.fromARGB(255, 189, 49, 71),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'An error occurred: ${snapshot.error}',
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: screenWidth * 0.04),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No results found',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      );
                    }

                    final searchResults = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final profile = searchResults[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(profile['imageUrl'] ?? ''),
                          ),
                          title: Text(profile['username'] ?? 'Unknown',
                              style: GoogleFonts.poppins()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile['email'] ?? '',
                                  style: GoogleFonts.poppins(fontSize: 12)),
                              Text(profile['userType'] ?? '',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          onTap: () {
                            if (profile['userType'] == 'Barbershop_Salon') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BSProfilePage(
                                    email: profile['email'],
                                    isClient: true,
                                    clientEmail: widget.email,
                                  ),
                                ),
                              );
                            } else if (profile['userType'] == 'Hairstylist') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HairstylistProfilePage(
                                    email: profile['email'],
                                    isClient: true,
                                    clientEmail: widget.email,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Only barbershop or hairstylist profiles are viewable")),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.07,
              child: TextButton(
                onPressed: () => showSearchModal(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: Colors.grey,
                    ),
                    const Gap(10),
                    Text(
                      'Search user',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(screenHeight * 0.02),
            Center(
              child: Text(
                '100% code. HUMANON INIG NOVEMBER 2024',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

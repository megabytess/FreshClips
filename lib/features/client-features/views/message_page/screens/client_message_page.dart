import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_profile_page.dart';
import 'package:freshclips_capstone/features/client-features/controllers/search_controller.dart'
    as custom_search;
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_profile_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientMessagePage extends StatefulWidget {
  const ClientMessagePage({super.key, required this.email});
  final String email;

  @override
  State<ClientMessagePage> createState() => _ClientMessagePageState();
}

class _ClientMessagePageState extends State<ClientMessagePage> {
  final TextEditingController searchInputController = TextEditingController();
  String searchQuery = '';
  bool isSearching = false; // Tracks if the search field has been tapped
  custom_search.SearchController searchController =
      custom_search.SearchController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          children: [
            // Search Bar
            SizedBox(
              height: screenHeight * 0.05,
              child: TextField(
                controller: searchInputController,
                onTap: () {
                  setState(() {
                    isSearching = true;
                    searchQuery = ''; // Empty query for fetching all users
                  });
                },
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
              ),
            ),
            Gap(screenHeight * 0.02),

            // Search Results
            Expanded(
              child:
                  isSearching // Display search results when search is activated
                      ? StreamBuilder<List<Map<String, dynamic>>>(
                          stream: Stream.fromFuture(
                              searchController.searchProfile(searchQuery)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 189, 49, 70),
                                  ),
                                ),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  'No results found',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }

                            final searchResults = snapshot.data!;
                            return ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                var profile = searchResults[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(profile['imageUrl'] ?? ''),
                                  ),
                                  title: Text(
                                    profile['username'] ?? 'Unknown',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profile['email'] ?? '',
                                        style:
                                            GoogleFonts.poppins(fontSize: 12),
                                      ),
                                      Text(
                                        profile['userType'] ?? '',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    if (profile['userType'] ==
                                        'Barbershop_Salon') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BSProfilePage(
                                            email: profile['email'],
                                            isClient: false,
                                            clientEmail: widget.email,
                                          ),
                                        ),
                                      );
                                    } else if (profile['userType'] ==
                                        'Hairstylist') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HairstylistProfilePage(
                                            email: profile['email'],
                                            isClient: false,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Only Barbershop and Hairstylist profiles are viewable"),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'Tap the search bar to find users',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

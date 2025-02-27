import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_profile_page.dart';
import 'package:freshclips_capstone/features/client-features/controllers/search_controller.dart'
    as custom;
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_profile_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientSearchFilterPage extends StatefulWidget {
  const ClientSearchFilterPage({
    super.key,
    required this.email,
    required this.isClient,
    required this.clientEmail,
  });

  final String email;
  final bool isClient;
  final String clientEmail;

  @override
  State<ClientSearchFilterPage> createState() => _ClientSearchFilterPageState();
}

class _ClientSearchFilterPageState extends State<ClientSearchFilterPage> {
  final TextEditingController searchInputController = TextEditingController();
  final custom.SearchController searchController = custom.SearchController();
  List<Map<String, dynamic>> searchResults = [];
  String selectedCategory = 'Hairstylist';
  final TextEditingController reviewController = TextEditingController();
  late final RatingsReviewController ratingsReviewController =
      RatingsReviewController(
    clientEmail: widget.clientEmail,
    reviewController: reviewController,
  );

  @override
  void initState() {
    super.initState();
    fetchInitialResults();
  }

  Future<void> fetchInitialResults() async {
    final results = await searchController.searchByUsername(
      '',
    );

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.03,
          right: screenWidth * 0.03,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Input Field
            SizedBox(
              height: screenHeight * 0.05,
              child: TextField(
                  controller: searchInputController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 20),
                    hintText: 'Search barbers or shops',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 48, 65, 69),
                    fontSize: screenWidth * 0.035,
                  ),
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      setState(() {
                        searchResults = [];
                      });
                    } else {
                      final results =
                          await searchController.searchByUsername(value);

                      setState(() {
                        searchResults = results;
                      });
                    }
                  }),
            ),
            Gap(screenHeight * 0.02),
            // Category Buttons (Hairstylist and Barbershop_Salon)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      selectedCategory = 'Hairstylist';
                    });

                    final results = await searchController.filterByUsertype(
                      searchInputController.text,
                      selectedCategory,
                    );

                    setState(() {
                      searchResults = results;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Hairstylist'
                        ? const Color.fromARGB(255, 45, 65, 69)
                        : Colors.transparent,
                    side: BorderSide(
                      color: selectedCategory == 'Hairstylist'
                          ? const Color.fromARGB(255, 45, 65, 69)
                          : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Hairstylist',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.03,
                      color: selectedCategory == 'Hairstylist'
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ),
                const Gap(10),
                OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      selectedCategory = 'Barbershop_Salon';
                    });

                    final results = await searchController.filterByUsertype(
                      searchInputController.text,
                      selectedCategory,
                    );

                    setState(() {
                      searchResults = results;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Barbershop_Salon'
                        ? const Color.fromARGB(255, 45, 65, 69)
                        : Colors.transparent,
                    side: BorderSide(
                      color: selectedCategory == 'Barbershop_Salon'
                          ? const Color.fromARGB(255, 45, 65, 69)
                          : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Barbershop/Salon',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.03,
                      color: selectedCategory == 'Barbershop_Salon'
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            Gap(screenHeight * 0.02),
            // Search Results List
            Expanded(
              child: searchResults.isEmpty
                  ? Center(
                      child: Text(
                        'No results found',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final profile = searchResults[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(profile['imageUrl'] ?? ''),
                          ),
                          title: Text(
                            profile['username'] ?? 'Unknown',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 48, 65, 69),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile['location']['address'] ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 48, 65, 69),
                                ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/profile_page/star.svg',
                                    width: screenWidth * 0.35,
                                    height: screenWidth * 0.035,
                                  ),
                                  Gap(screenHeight * 0.004),
                                  FutureBuilder<double>(
                                    future: ratingsReviewController
                                        .computeAverageRating(profile['email']),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Color.fromARGB(255, 189, 49, 71),
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error loading rating',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      } else {
                                        double rating = snapshot.data ?? 0.0;
                                        return Text(
                                          rating.toStringAsFixed(1),
                                          style: GoogleFonts.poppins(
                                            color: const Color.fromARGB(
                                                255, 18, 18, 18),
                                            fontSize: screenWidth * 0.032,
                                            // fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

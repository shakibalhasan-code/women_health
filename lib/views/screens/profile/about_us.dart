import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  // --- Helper function to launch URLs ---
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Optional: Show a snackbar or dialog to the user if launching fails
      print('Could not launch $urlString');
      // Consider showing a user-friendly message here
    }
  }

  // --- Helper function specific for phone ---
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(phoneUri)) {
      print('Could not launch $phoneUri');
      // Consider showing a user-friendly message here
    }
  }

  // --- Helper function specific for email ---
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (!await launchUrl(emailUri)) {
      print('Could not launch $emailUri');
      // Consider showing a user-friendly message here
    }
  }

  // --- Helper function specific for Maps (if needed, more complex) ---
  // Example for address - This often requires more platform-specific handling
  // or using a maps URL that works broadly. Google Maps URL is common.
  Future<void> _launchMaps(String addressQuery) async {
    // Simple approach using Google Maps search query
    // Encode the address for the URL
    final String encodedQuery = Uri.encodeComponent(addressQuery);
    final Uri mapsUri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$encodedQuery");

    if (!await launchUrl(mapsUri, mode: LaunchMode.externalApplication)) {
      print('Could not launch $mapsUri');
      // Fallback or error message
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle =
        TextStyle(fontSize: 14.sp, color: Colors.black87, height: 1.5);
    final boldBrandStyle = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 14.sp,
      height: 1.5,
    );
    final contactTitleStyle =
        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold);
    final contactListTileTitleStyle = TextStyle(fontSize: 14.sp);
    final contactListTileSubtitleStyle =
        TextStyle(fontSize: 12.sp, color: Colors.grey[600]); // For Address

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- About Us Text Section ---
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: bodyTextStyle,
                  children: [
                    TextSpan(
                      text: "Nirbhoya",
                      style: boldBrandStyle,
                    ),
                    const TextSpan(
                      text:
                          " is a youth-led initiative, founded by Rezwana Saima, Tonima Tanzilul, Jisan Khan, and Tayab Mridha, dedicated to transforming menstrual and reproductive health in Bangladesh. In a country where millions of women and girls, especially in remote and marginalized areas, face lack of awareness, resources, and access to menstrual and reproductive care and many cant afford basic hygiene products, we are bridging the gap through education, economic empowerment, and technology.\n\nOur work is rooted in three pillars: in-person awareness programs to break stigmas and educate communities, a social enterprise model that trains marginalized women to produce and distribute affordable menstrual hygiene products, and an innovative tech-based solution providing accessible, Bangla-supported menstrual and reproductive health services.\n\nAt ",
                    ),
                    TextSpan(
                      text: "Nirbhoya",
                      style: boldBrandStyle,
                    ),
                    const TextSpan(
                      text:
                          ", we believe menstrual health is a fundamental right, not a privilege. That's why Nirbhoya is working in empowering women, breaking stigmas, and building a healthier future for all women.",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),

              // --- Image Section ---
              Text("Our Team / Work", style: contactTitleStyle),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTeamImage('assets/images/person_1.jpg'),
                  _buildTeamImage('assets/images/person_2.jpg'),
                  _buildTeamImage('assets/images/person_3.jpg'),
                ],
              ),
              SizedBox(height: 25.h),

              // --- Contact Us Section ---
              Text("Contact With Us", style: contactTitleStyle),
              SizedBox(height: 10.h),

              // Email
              ListTile(
                leading:
                    const Icon(Icons.email_outlined, color: Colors.blueGrey),
                title: Text("Email", style: contactListTileTitleStyle),
                subtitle: Text("nirbhoya.info@gmail.com",
                    style: contactListTileSubtitleStyle), // Show email
                onTap: () => _launchEmail("nirbhoya.info@gmail.com"),
                dense: true, // Make it slightly smaller
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w), // Adjust padding
              ),

              // Phone
              ListTile(
                leading: const Icon(Icons.phone_outlined, color: Colors.green),
                title: Text("Phone", style: contactListTileTitleStyle),
                subtitle: Text("01729701084",
                    style: contactListTileSubtitleStyle), // Show phone
                onTap: () => _launchPhone("01729701084"),
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              ),

              // Address
              ListTile(
                leading: const Icon(Icons.location_on_outlined,
                    color: Colors.orange),
                title: Text("Address", style: contactListTileTitleStyle),
                subtitle: Text("7/D Shantibagh, Dhaka-1217",
                    style: contactListTileSubtitleStyle), // Show address
                onTap: () => _launchMaps("7/D Shantibagh, Dhaka-1217"),
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              ),

              // Facebook
              ListTile(
                // Using FontAwesome icon for Facebook
                leading: const FaIcon(FontAwesomeIcons.facebook,
                    color: Color(0xFF1877F2)), // Facebook blue
                title: Text("Facebook", style: contactListTileTitleStyle),
                subtitle: Text("Follow us on Facebook",
                    style: contactListTileSubtitleStyle), // Generic subtitle
                onTap: () => _launchURL(
                    "https://www.facebook.com/profile.php?id=61567515663269"),
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              ),

              // Instagram
              ListTile(
                // Using FontAwesome icon for Instagram
                leading: const FaIcon(FontAwesomeIcons.instagram,
                    color: Color(
                        0xFFE4405F)), // Instagram pink/purple gradient (approx)
                title: Text("Instagram", style: contactListTileTitleStyle),
                subtitle: Text("Follow us on Instagram",
                    style: contactListTileSubtitleStyle),
                onTap: () =>
                    _launchURL("https://www.instagram.com/nirbhoya_bd/"),
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build team images consistently
  Widget _buildTeamImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.asset(
        imagePath,
        height: 100.h,
        width: 100.w, // Adjust based on screen width if needed
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 100.h,
          width: 100.w,
          color: Colors.grey[300],
          child: Icon(Icons.person, color: Colors.grey[600], size: 40.sp),
        ),
      ),
    );
  }
}

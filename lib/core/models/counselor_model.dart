// counselor_model.dart
import 'dart:convert'; // Not strictly needed here, but often useful for models

class Counselor {
  final String id;
  final String name;
  final String email;
  final String phone;
  // final String? specialty; // Optional: Uncomment and add to constructor/fromJson if needed
  final int experience;
  final String education;
  final String? location;
  final DateTime? time; // Changed from dynamic to DateTime?
  final String bio;
  final String image; // Kept as String, fromJson will extract the URL
  final List<String> availability;
  final int ratings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Counselor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    // this.specialty, // Optional
    required this.experience,
    required this.education,
    this.location,
    this.time, // Updated type
    required this.bio,
    required this.image,
    required this.availability,
    required this.ratings,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Counselor.fromJson(Map<String, dynamic> json) {
    String imageUrl = ''; // Default to empty string
    if (json['image'] != null) {
      if (json['image'] is List) {
        final imageList = json['image'] as List;
        if (imageList.isNotEmpty && imageList.first is String) {
          imageUrl = imageList.first as String; // Take the first image URL
        }
      } else if (json['image'] is String) {
        // Fallback if API sometimes sends a string directly (less likely based on sample)
        imageUrl = json['image'] as String;
      }
    }

    DateTime? parsedTime;
    if (json['time'] != null && json['time'] is String) {
      final timeString = json['time'] as String;
      if (timeString.isNotEmpty) {
        try {
          parsedTime = DateTime.parse(timeString);
        } catch (e) {
          print('Error parsing time field: $timeString - $e');
          // parsedTime remains null if parsing fails
        }
      }
    }

    return Counselor(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      // specialty: json['specialty'] as String?, // Optional: Uncomment if 'specialty' field is added
      experience: json['experience'] as int,
      education: json['education'] as String,
      location: json['location'] as String?,
      time: parsedTime, // Use parsed DateTime or null
      bio: json['bio'] as String,
      image: imageUrl, // Use extracted image URL
      availability: (json['availability'] as List<dynamic>)
          .map<String>((item) => item.toString())
          .toList(),
      ratings: json['ratings'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
    );
  }
}

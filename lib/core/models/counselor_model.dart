// counselor_model.dart
class Counselor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int experience;
  final String education;
  final String? location;
  final dynamic time; // Could be a DateTime or String depending on format
  final String bio;
  final String image;
  final List<String> availability; // Corrected type to List<String>
  final int ratings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Counselor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.experience,
    required this.education,
    this.location,
    this.time,
    required this.bio,
    required this.image,
    required this.availability,
    required this.ratings,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Counselor.fromJson(Map<String, dynamic> json) {
    // Add a null check and default value for the image URL
    String imageUrl = json['image'] != null ? json['image'] as String : '';

    return Counselor(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      experience: json['experience'] as int,
      education: json['education'] as String,
      location: json['location'] as String?,
      time: json['time'], // Keep as dynamic, handle null if necessary
      bio: json['bio'] as String,
      image: imageUrl,
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

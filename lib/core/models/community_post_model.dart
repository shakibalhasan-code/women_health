import 'package:get/get.dart';

class CommunityPostModel {
  String? id;
  User? userId;
  String? title;
  String? category; // Will store category.name
  String? description;
  String? image; // Will store imageUrls[0]
  RxList<User> likes = <User>[].obs;

  List<dynamic>?
      comments; // Consider making this List<CommentModel> if you have a CommentModel
  List<dynamic>?
      followers; // Consider making this List<User> if followers are users
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  CommunityPostModel({
    this.id,
    this.userId,
    this.title,
    this.category,
    this.description,
    this.image,
    List<User>? likes,
    this.comments,
    this.followers,
    this.createdAt,
    this.updatedAt,
    this.v,
  }) {
    // Initialize RxList from the passed normal list
    if (likes != null) {
      this.likes.assignAll(likes);
    }
  }

  CommunityPostModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'] != null ? User.fromJson(json['userId']) : null;
    title = json['title'];

    // Category parsing: Extracts 'name' from the category object.
    // This logic from your original model is good and handles various cases.
    if (json['category'] != null) {
      if (json['category'] is Map<String, dynamic> &&
          json['category']['name'] != null) {
        category = json['category']['name'];
      } else if (json['category'] is String) {
        category = json['category'];
      }
    } else if (json['categoryName'] != null) {
      // Fallback for a flat categoryName
      category = json['categoryName'];
    }

    description = json['description'];

    // Image parsing: Use the first URL from 'imageUrls' list.
    // Fallback to 'images' list (0th element) or a single 'image' string if 'imageUrls' is not available/empty.
    if (json['imageUrls'] != null && json['imageUrls'] is List) {
      List<dynamic> imageUrlsList = json['imageUrls'];
      if (imageUrlsList.isNotEmpty && imageUrlsList[0] is String) {
        image = imageUrlsList[0] as String?;
      }
    }
    // Optional: Fallback if imageUrls[0] is not found (e.g., if API might change)
    if (image == null && json['images'] != null && json['images'] is List) {
      List<dynamic> imagesList = json['images'];
      if (imagesList.isNotEmpty && imagesList[0] is String) {
        // You might need to prepend a base URL if 'images' contains relative paths
        image = imagesList[0] as String?;
      }
    }
    // Further fallback to a single 'image' field if others are not suitable
    if (image == null && json['image'] != null && json['image'] is String) {
      image = json['image'] as String?;
    }

    // Likes parsing
    likes.clear(); // Clear previous values if any
    if (json['likes'] != null && json['likes'] is List) {
      (json['likes'] as List).forEach((v) {
        if (v is Map<String, dynamic>) {
          likes.add(User.fromJson(v));
        }
        // If likes can be just user IDs (strings), you'd handle that differently
        // else if (v is String) { /* likes.add(User(id: v)); or fetch user details */ }
      });
    }

    // Comments and Followers parsing (assuming they are lists of dynamic objects or simple types for now)
    // If they are lists of specific models (e.g., CommentModel, UserModel), parse them accordingly.
    comments =
        json['comments'] is List ? List<dynamic>.from(json['comments']) : [];
    followers =
        json['followers'] is List ? List<dynamic>.from(json['followers']) : [];

    createdAt =
        json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null;
    v = json['__v'];
  }

  int get totalLikes => likes.length;
  int get totalComments => comments?.length ?? 0;
  int get totalFollowers => followers?.length ?? 0; // Added for consistency

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    if (userId != null) {
      data['userId'] = userId!.toJson();
    }
    data['title'] = title;
    // When sending back to API, if it expects category as an object, adjust here.
    // For now, sending back the name string.
    data['category'] = category;
    data['description'] = description;
    data['image'] = image; // This will be the single URL
    data['likes'] = likes.map((v) => v.toJson()).toList();
    data['comments'] = comments;
    data['followers'] = followers;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['__v'] = v;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}

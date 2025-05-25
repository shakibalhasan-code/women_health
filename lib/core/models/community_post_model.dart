// core/models/community_post_model.dart
import 'package:get/get.dart';

class CommunityPostModel {
  String? id;
  User? userId;
  String? title;
  String? category; // Will store category.name
  String? description;
  String? image; // Will store imageUrls[0] or a fallback
  RxList<User> likes = <User>[].obs; // Use RxList for GetX reactivity

  List<dynamic>? comments; // Consider List<CommentModel>
  List<dynamic>? followers; // Consider List<User> or List<String> (IDs)
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
    List<User>? initialLikes, // Renamed for clarity
    this.comments,
    this.followers,
    this.createdAt,
    this.updatedAt,
    this.v,
  }) {
    if (initialLikes != null) {
      likes.assignAll(initialLikes);
    }
  }

  CommunityPostModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;

    if (json['userId'] != null && json['userId'] is Map<String, dynamic>) {
      userId = User.fromJson(json['userId'] as Map<String, dynamic>);
    } else {
      userId = null;
    }

    title = json['title'] as String?;

    if (json['category'] != null) {
      if (json['category'] is Map<String, dynamic>) {
        final categoryMap = json['category'] as Map<String, dynamic>;
        category = categoryMap['name'] as String?;
      } else if (json['category'] is String) {
        category = json['category'] as String?;
      }
    } else if (json['categoryName'] != null && json['categoryName'] is String) {
      category = json['categoryName'] as String?;
    }

    description = json['description'] as String?;

    if (json['imageUrls'] != null && json['imageUrls'] is List) {
      final imageUrlsList = json['imageUrls'] as List;
      if (imageUrlsList.isNotEmpty && imageUrlsList.first is String) {
        image = imageUrlsList.first as String?;
      }
    }
    if (image == null && json['images'] != null && json['images'] is List) {
      final imagesList = json['images'] as List;
      if (imagesList.isNotEmpty && imagesList.first is String) {
        // IMPORTANT: If imagesList.first is a relative path like "uploads/...",
        // you might need to prepend a base URL here if not using imageUrls.
        // For now, assuming imageUrls is preferred and contains full URLs.
        // String relativePath = imagesList.first as String;
        // image = "YOUR_BASE_IMAGE_URL" + relativePath; // Example
        image = imagesList.first as String?; // If it might be full URL
      }
    }
    if (image == null && json['image'] != null && json['image'] is String) {
      image = json['image'] as String?;
    }

    likes.clear();
    if (json['likes'] != null && json['likes'] is List) {
      final likesList = json['likes'] as List;
      for (var v in likesList) {
        if (v is Map<String, dynamic>) {
          likes.add(User.fromJson(v));
        }
      }
    }

    comments = json['comments'] is List
        ? List<dynamic>.from(json['comments'] as List)
        : [];
    followers = json['followers'] is List
        ? List<dynamic>.from(json['followers'] as List)
        : [];

    createdAt = (json['createdAt'] != null && json['createdAt'] is String)
        ? DateTime.tryParse(json['createdAt'] as String)
        : null;
    updatedAt = (json['updatedAt'] != null && json['updatedAt'] is String)
        ? DateTime.tryParse(json['updatedAt'] as String)
        : null;
    v = json['__v'] as int?;
  }

  int get totalLikes => likes.length;
  int get totalComments => comments?.length ?? 0;
  int get totalFollowers => followers?.length ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    if (userId != null) {
      data['userId'] = userId!.toJson();
    }
    data['title'] = title;
    data['category'] = category;
    data['description'] = description;
    data['image'] = image;
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
  // Add other fields like profilePic if your User model has them

  User({this.id, this.name, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    name = json['name'] as String?;
    email = json['email'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}

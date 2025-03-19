import 'package:get/get.dart';

class CommunityPostModel {
  String? id;
  User? userId;
  String? title;
  String? category;
  String? description;
  String? image;
  RxList<User> likes = <User>[].obs; // Ensure this is always an RxList<User>

  List<dynamic>? comments;
  List<dynamic>? followers;
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
    List<User>? likes, // Accept normal list
    this.comments,
    this.followers,
    this.createdAt,
    this.updatedAt,
    this.v,
  }) {
    this.likes.addAll(likes ?? <User>[]); // Convert normal list to RxList<User>
  }

  CommunityPostModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'] != null ? User.fromJson(json['userId']) : null;
    title = json['title'];
    category = json['category'];
    description = json['description'];
    image = json['image'];

    likes.clear(); // Clear previous list before adding new items
    if (json['likes'] != null) {
      (json['likes'] as List).forEach((v) {  // Correct List type
        likes.add(User.fromJson(v));
      });
    }

    comments = json['comments'] ?? [];
    followers = json['followers'] ?? [];
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    v = json['__v'];
  }
  int get totalLikes => likes.length;
  int get totalComments => comments?.length ?? 0;

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
    data['likes'] = likes.map((v) => v.toJson()).toList(); // Convert RxList<User> to normal list
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
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}
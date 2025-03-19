

// Model
class BlogPostModel {
  String? id;
  dynamic userId; // Can be null, so keep it dynamic
  String? title;
  Category? category;
  String? description;
  String? image;
  List<dynamic>? likes;
  List<dynamic>? comments;
  List<dynamic>? followers;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? categoryName;
  String? imageUrl;

  BlogPostModel({
    this.id,
    this.userId,
    this.title,
    this.category,
    this.description,
    this.image,
    this.likes,
    this.comments,
    this.followers,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.categoryName,
    this.imageUrl,
  });

  BlogPostModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId']; // Keep it dynamic for null handling
    title = json['title'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    description = json['description'];
    image = json['image'];
    likes = json['likes'];
    comments = json['comments'];
    followers = json['followers'];
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    v = json['__v'];
    categoryName = json['categoryName'];
    imageUrl = json['imageUrl'];
  }
}

class Category {
  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Category({this.id, this.name, this.createdAt, this.updatedAt, this.v});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    v = json['__v'];
  }
}
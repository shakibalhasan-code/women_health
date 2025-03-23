class ProfileModel {
  String? message;
  User? user;

  ProfileModel({this.message, this.user});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? partnerId;
  String? role;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? profileImageUrl;
  int? totalPosts;
  int? totalLikes;
  int? totalComments;
  int? totalFollowers;
  int? totalFollowing;
  List<dynamic>? followers;
  List<dynamic>? following;
  List<dynamic>? savedPosts;

  User({
    this.id,
    this.name,
    this.email,
    this.partnerId,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.followers,
    this.following,
    this.savedPosts,
    this.profileImageUrl,
    this.totalPosts,
    this.totalLikes,
    this.totalComments,
    this.totalFollowers,
    this.totalFollowing,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    partnerId = json['partnerId'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    followers = json['followers'];
    following = json['following'];
    savedPosts = json['savedPosts'];
    profileImageUrl = json['profileImageUrl'];
    totalPosts = json['totalPosts'];
    totalLikes = json['totalLikes'];
    totalComments = json['totalComments'];
    totalFollowers = json['totalFollowers'];
    totalFollowing = json['totalFollowing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['partnerId'] = partnerId;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    data['followers'] = followers;
    data['following'] = following;
    data['savedPosts'] = savedPosts;
    data['profileImageUrl'] = profileImageUrl;
    data['totalPosts'] = totalPosts;
    data['totalLikes'] = totalLikes;
    data['totalComments'] = totalComments;
    data['totalFollowers'] = totalFollowers;
    data['totalFollowing'] = totalFollowing;
    return data;
  }
}
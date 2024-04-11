
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/services/utils_service.dart';

import '../models/member_model.dart';
import '../models/post_model.dart';
import 'auth_service.dart';

class DBService {
  static final _firestore = FirebaseFirestore.instance;

  static String folder_users = "users";
  static String folder_posts = "posts";

  /// Member Related
  static Future storeMember(Member member) async {
    member.uid = AuthService.currentUserId();

    return _firestore
        .collection(folder_users)
        .doc(member.uid)
        .set(member.toJson());
  }

  static Future<Member> loadMember() async {
    String uid = AuthService.currentUserId();
    var value = await _firestore.collection(folder_users).doc(uid).get();
    Member member = Member.fromJson(value.data()!);
    return member;
  }

  static Future updateMember(Member member) async {
    String uid = AuthService.currentUserId();
    return _firestore.collection(folder_users).doc(uid).update(member.toJson());
  }

  static Future<Post> storePost(Post post) async {
    String postId = _firestore.collection(folder_posts).doc().id;
    await _firestore.collection(folder_posts).doc(postId).set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];

    var querySnapshot = await _firestore.collection(folder_posts).get();

    for (var result in querySnapshot.docs) {
      posts.add(Post.fromJson(result.data()));
    }
    return posts;
  }
}
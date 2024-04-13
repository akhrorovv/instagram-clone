import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/services/utils_service.dart';

import '../models/member_model.dart';
import '../models/post_model.dart';
import 'auth_service.dart';

class DBService {
  static final _firestore = FirebaseFirestore.instance;

  static String folder_users = "users";
  static String folder_posts = "posts";
  static String folder_feeds = "feeds";
  static String folder_following = "following";
  static String folder_followers = "followers";

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

    var querySnapshot1 = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_followers)
        .get();
    member.followers_count = querySnapshot1.docs.length;

    var querySnapshot2 = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_following)
        .get();
    member.following_count = querySnapshot2.docs.length;

    return member;
  }

  static Future updateMember(Member member) async {
    String uid = AuthService.currentUserId();
    return _firestore.collection(folder_users).doc(uid).update(member.toJson());
  }

  static Future<List<Member>> searchMembers(String keyword) async {
    List<Member> members = [];
    String uid = AuthService.currentUserId();

    var querySnapshot = await _firestore
        .collection(folder_users)
        .orderBy("email")
        .startAt([keyword]).get();
    print(querySnapshot.docs.length);

    for (var result in querySnapshot.docs) {
      Member newMember = Member.fromJson(result.data());
      if (newMember.uid != uid) {
        members.add(newMember);
      }
    }
    return members;
  }

  static Future<Member> followMember(Member someone) async {
    Member me = await loadMember();

    // I followed to someone
    await _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_following)
        .doc(someone.uid)
        .set(someone.toJson());

    // I am in someone`s followers
    await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_followers)
        .doc(me.uid)
        .set(me.toJson());

    return someone;
  }

  static Future<Member> unfollowMember(Member someone) async {
    Member me = await loadMember();

    // I un followed to someone
    await _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_following)
        .doc(someone.uid)
        .delete();

    // I am not in someone`s followers
    await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_followers)
        .doc(me.uid)
        .delete();

    return someone;
  }

  /// Post Related

  static Future<Post> storePost(Post post) async {
    Member me = await loadMember();
    post.uid = me.uid;
    post.fullname = me.fullname;
    post.img_user = me.img_url;
    post.date = Utils.currentDate();

    String postId = _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_posts)
        .doc()
        .id;
    post.id = postId;

    await _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_posts)
        .doc(postId)
        .set(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = AuthService.currentUserId();
    await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();

    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_posts)
        .get();

    querySnapshot.docs.forEach((result) {
      posts.add(Post.fromJson(result.data()));
    });
    return posts;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();
    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .get();

    for (var result in querySnapshot.docs) {
      Post post = Post.fromJson(result.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    }

    return posts;
  }

  static Future storePostsToMyFeed(Member someone) async {
    List<Post> posts = [];

    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_posts)
        .get();

    for (var result in querySnapshot.docs) {
      var post = Post.fromJson(result.data());
      post.liked = false;
      posts.add(post);
    }

    for (Post post in posts) {
      storeFeed(post);
    }
  }

  static Future removePostsFromMyFeed(Member someone) async {
    List<Post> posts = [];
    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_posts)
        .get();

    for (var result in querySnapshot.docs) {
      posts.add(Post.fromJson(result.data()));
    }

    for (Post post in posts) {
      removeFeed(post);
    }
  }

  static Future removeFeed(Post post) async {
    String uid = AuthService.currentUserId();

    return await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .delete();
  }
}

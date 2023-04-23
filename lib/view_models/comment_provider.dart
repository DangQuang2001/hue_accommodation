import 'package:flutter/material.dart';
import 'package:hue_accommodation/services/comment_api.dart';

class CommentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> listComment = [];
  List<Map<String, dynamic>> listReply = [];

  Future addComment(
      String postId, String sender, String content, String typeC) async {
    await CommentApi.addComment(postId, sender, content, typeC);
    getComment(postId, 10, 10);
  }

  Future createReplyComment(
      String commentId, String sender, String content, String typeC) async {
      await CommentApi.createReplyComment(commentId, sender, content, typeC);
      getReplyComment(commentId, 10, 10, listReply);
  }

  Future<void> getComment(String postId, int skip, int limit) async {
    final data = await CommentApi.getComment(postId, skip, limit);
    if (data != null) {
      listComment = data;
      notifyListeners();
    } else {
      listComment = [];
      notifyListeners();
    }
  }

  Future<void> getReplyComment(
      String id, int skip, int limit, List<Map<String, dynamic>> list) async {
    listReply = list;
    notifyListeners();
    final data = await CommentApi.getReplyComment(id, skip, limit, list);
    if (data != null) {
      listReply = data;
      notifyListeners();
    } else {
      listReply = [];
      notifyListeners();
    }
  }

  Future addReplyComment(
      String commentId, String sender, String content, String typeC) async {
      await CommentApi.addReplyComment(commentId, sender, content, typeC);
      getReplyComment(commentId, 10, 10, listReply);
  }
}

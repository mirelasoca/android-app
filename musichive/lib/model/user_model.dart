import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserModel {
  final String id;
  final String nickname;
  final String email;
  final String photoUrl;
  final List<String> followers;
  final List<String> following;
  final String chattingWith;
  final DateTime joined;
  final int posts;

  const UserModel({
    @required this.id,
    this.nickname,
    this.email,
    this.photoUrl,
    this.followers,
    this.following,
    this.chattingWith,
    this.joined,
    this.posts,
  });

  String get postTimeFormatted => DateFormat.yMMMMEEEEd().format(joined);
}

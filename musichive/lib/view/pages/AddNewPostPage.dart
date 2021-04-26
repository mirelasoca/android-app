import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';


class AddNewPostPage extends StatefulWidget {

  final String currentUserId;

  AddNewPostPage({Key key, @required this.currentUserId}) : super(key: key);
  @override
  State createState() => AddNewPostPageState(currentUserId: currentUserId);
}

class AddNewPostPageState extends State<AddNewPostPage> {

  AddNewPostPageState({Key key, @required this.currentUserId});
  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    return Text("add your stuff here");
  }
}
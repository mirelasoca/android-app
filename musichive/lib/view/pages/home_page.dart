import 'package:flutter/material.dart';
import 'package:musichive/helper/demo_values.dart';
import 'package:musichive/view/widgets/post_card.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key key}) : super(key: key);
  final String currentUserId;

  HomePage({Key key, @required this.currentUserId}) : super(key: key);
  @override
  State createState() => HomePageState(currentUserId: currentUserId);
}

class HomePageState extends State<HomePage> {
  HomePageState({Key key, @required this.currentUserId});
  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("musichive"),
      ),
      body: ListView.builder(
        itemCount: DemoValues.posts.length,
        itemBuilder: (BuildContext context, int index) {
          return PostCard(postData: DemoValues.posts[index]);
        },
      ),
    );
  }
}

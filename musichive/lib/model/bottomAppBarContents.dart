
//import 'dart:html';
import 'package:musichive/view/pages/chatlist.dart';

import 'package:musichive/view/pages/UserSearchPage.dart';
import 'package:musichive/view/pages/AddNewPostPage.dart';
import 'package:flutter/material.dart';
class bottommAppBarContents extends StatelessWidget {

//   @override
//   bottommAppBarContentsState createState() => bottommAppBarContentsState();
// }
//
// class bottommAppBarContentsState extends State<bottommAppBarContents> {
  Widget build (BuildContext context) {
    return Container(
        //width:10,
        height:50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          IconButton(
          icon: Icon(
            Icons.person_search,
          ),
            onPressed:() {
            //Wrapper.init();
            //showSearch(context: context, delegate: UserSearch());
             Navigator.push(context, MaterialPageRoute(builder: (context) => CloudFirestoreSearch()));

            }

          ),
        IconButton(icon: Icon(
          Icons.chat_bubble_outline_rounded,

        ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatList()));
            }
        ),
            IconButton(icon: Icon(
              Icons.library_add,

            ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewPostPage()));
                }
            )


    ],
        ),
       // body: Text("save"),



    );
  }

}
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musichive/view/pages/OtherUserProfile.dart';
import 'package:musichive/view/presentation/const.dart';

class CloudFirestoreSearch extends StatefulWidget {
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = "";
  List<String> names = [];
  List <DocumentSnapshot> filteredUsers =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
                names.clear();
                name.toLowerCase().split(" ").forEach((element) {
                  names.add(element.substring(0,1));
                });
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
            .collection('users')
            .where("searchKey", arrayContainsAny: names)
            .snapshots()
            : null,
        //FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if(name ==null || name =='')
            {
              return Text("Search...");
            }
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(child: CircularProgressIndicator());
            }
          else {
            filteredUsers.clear();
            snapshot.data.docs.forEach((doc) {
              if (doc.data()['nickname'].toString().toLowerCase().contains(name.toLowerCase()) &&(!filteredUsers.contains(doc)))
              {

                filteredUsers.add(doc);
                // LoginScreenState.gprefs.setString(
                //     'nickname', doc.data()['nickname']);

              }
              else if (filteredUsers.contains(doc) && (!doc.data()['nickname'].toString().toLowerCase().contains(name.toLowerCase())))
              {
                filteredUsers.remove(doc);
              }
            });
            if (filteredUsers.length ==0)
              {
                return Text("not found");

              }
            else
              {
                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) =>ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(userInfo: filteredUsers[index])));
                    },
                    leading: Material (
                    child :CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(
                              themeColor),
                        ),
                        width: 50.0,
                        height:50.0,
                        //padding: EdgeInsets.all(10.0),
                      ),
                      imageUrl: filteredUsers[index].data()['photoUrl'],
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,

                    ),
                        borderRadius:
                        BorderRadius.all(Radius.circular(45.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    //Icon( url:Wrapper.foundusers[index].data()['photoUrl']),
                    title:Text(filteredUsers[index].data()['nickname']),

                  ),
                );
              }

          }

        },
      ),
    );
  }

}
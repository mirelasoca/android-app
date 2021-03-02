import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:io';


import 'package:musichive/view/presentation/const.dart';

import 'package:musichive/widget/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musichive/view/pages/home_page.dart';
import 'package:cached_network_image/cached_network_image.dart';


import 'package:musichive/view/pages/chat.dart';
import 'package:musichive/view/pages/login.dart';
import 'package:musichive/view/presentation/const.dart';
import 'package:musichive/view/pages/settings.dart';
import 'package:musichive/widget/loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:musichive/model/choices.dart';
import 'package:musichive/view/pages/home_page.dart';
import '../../main.dart';
import 'login.dart';
class Wrapper {
   static List<QueryDocumentSnapshot>  foundusers;
  static List<String> names;
  static String temp;
  static init (){
    if( foundusers==null || temp ==null)
      {
        names =[];
        foundusers =[];
        temp ='';
      }
    else
      {
        names.clear();
        foundusers.clear();
        //temp = '';
      }

  }

}
class UserInformation extends StatelessWidget {
  List<QueryDocumentSnapshot> filtered_users =[];
  //List<SharedPreferences> myprefs;
  SharedPreferences mypref;
  //Wrapper.names = [];
 List<QueryDocumentSnapshot> get_filter()
  {
    return filtered_users;
  }

 // get element => null;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(includeMetadataChanges: true),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('Something went wrong');
          return null;
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
         print("Loading");
         //return null;
        }
        // if (snapshot.connectionState == ConnectionState.done) {
        //   return Text("Loading");
        // }
        snapshot.data.docs.forEach((element) {
          return Text(element.data()['nickname']);
          filtered_users.add(element);});
         //filtered_users =snapshot.data.docs;
        return null;

        //return new List(snapshot.data.docs.map((DocumentSnapshot document),(DocumentSnapshot doc)));
          //   {
          //   return new ListTile(
          //     title: new Text(document.data()['nickname']),
          //     //subtitle: new Text(document.data()['company']),
          //   );
          // }).toList(),
        //);



      },
    );
  }
}

class UserSearch extends SearchDelegate<String> {


  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(icon: Icon( Icons.clear), onPressed:() {
        query ="";
      }),

    ];
    //throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress:transitionAnimation,
        ),
        onPressed:() {
          close(context, null);
        }
    );
    //throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context)  {
    // TODO: implement buildResults
    //final ScrollController listScrollController = ScrollController();


    return ListView.builder(
        itemBuilder: (context, index) =>ListTile(
          //leading:Icon(needed.foundusers[index].data()['photoUrl']),
          //title: Text(needed.foundusers[index].data()['nickname']),
          title: TextField(
            onChanged: (val) {

            },
          )
        ));

    //AsyncSnapshot<QuerySnapshot> get snapshot => userStream;


    //return Text("results");
    //throw UnimplementedError();
  }
  Future<bool> handlesearch(Future<List<DocumentSnapshot>>  foundusers, String myq) async {

    QuerySnapshot result =
        await FirebaseFirestore.instance.collection('users').where('searchKey', isEqualTo: myq.substring(0, 1).toUpperCase()).get();
    //foundusers = [];
    //result.docs.forEach((element) {foundusers.add(element);});
    //return;
    //.forEach((element) { })
    //return documents;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions


    List<DocumentSnapshot> found = [];
     List<String> names =[];
     bool contains = false;
     
     //Wrapper.init();
    String temp = '%';
    //.get_shared_pref();
    //mypref = trial.get_shared_pref() as SharedPreferences;
    //needed.foundusers =[];
    //List<DocumentSnapshot> suggestedUsers;



        if(query.isNotEmpty) {
          //Wrapper.foundusers.clear();
          //Wrapper.names.clear();
          //info.build(context);
          //temp = query;
          // if((!query.startsWith(Wrapper.temp)) && (!Wrapper.temp.startsWith(query))&&(Wrapper.foundusers.isNotEmpty))
          // {
            //Wrapper.foundusers.clear();
            //Wrapper.names.clear();
            FirebaseFirestore.instance
                .collection('users').where('searchKey', isEqualTo: query.substring(0, 1).toLowerCase())
                .get().then((QuerySnapshot querySnapshot) =>
            {
              querySnapshot.docs.forEach((doc) {
                if (doc.data()['nickname'].toString().toLowerCase().contains(query.toLowerCase()) &&!(Wrapper.foundusers.contains(doc.data()['id'])))
                  {
                   // if(!Wrapper.foundusers.contains(doc))
                      //{
                        Wrapper.foundusers.add(doc);
                        LoginScreenState.gprefs.setString(
                            'nickname', doc.data()['nickname']);
                        if(Wrapper.foundusers.contains(doc))
                          {
                            contains = true;
                          }
                        else
                          {
                            contains = false;
                          }
                  }
                else if (Wrapper.foundusers.contains(doc.data()['id']) && (!doc.data()['nickname'].toString().toLowerCase().contains(query.toLowerCase())))
                      {
                        Wrapper.foundusers.remove(doc);
                      }


              })
            });
         //}
          Wrapper.temp = query;
        }
        else
        {
          Wrapper.foundusers.clear();
          return Text("search...");
        }



        if(Wrapper.foundusers.length==0)
            {
              return Text("Nothing found");
            }
          else
            {
              //return Text(Wrapper.names[0]);
              return ListView.builder(
                itemBuilder: (context, index) =>ListTile(
                  //: ,
                  leading:CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(
                            themeColor),
                      ),
                      width: 40.0,
                      height:40.0,
                      padding: EdgeInsets.all(10.0),
                    ),
                    imageUrl: Wrapper.foundusers[index].data()['photoUrl'],
                    width: 90.0,
                    height: 90.0,
                    fit: BoxFit.cover,
                  ),
                  //Icon( url:Wrapper.foundusers[index].data()['photoUrl']),
                  title:Text(Wrapper.foundusers[index].data()['nickname']),
                  //: Text(needed.foundusers[index].data()['nickname']),
                ),
                itemCount: Wrapper.foundusers.length,);
            }
         // needed.foundusers =trial.searchByName(query);
          //handlesearch(needed.foundusers, query);
          //  while(trial.searchByName(query).length==0) {
          //
          //    trial.searchByName(query);
             // trial.searchByName(query).then((QuerySnapshot result) {
             //   result.docs.forEach((element) {
             //     needed.foundusers.add(element);
             //   });
             // });
             //handlesearch(needed.foundusers, query);
             //return Text("waaiting");
           //}


              // return Text(trial.searchByName(query)[0].data()['nickname']);


          // return ListView.builder(
          //   itemBuilder: (context, index) =>ListTile(
          //     //leading:Icon(needed.foundusers[index].data()['photoUrl']),
          //     title:Text(query.to),
          //     //: Text(needed.foundusers[index].data()['nickname']),
          //   ),
          //   itemCount: found.length,);




    //return Text("suggestion");
    //throw UnimplementedError();
  }
  
}
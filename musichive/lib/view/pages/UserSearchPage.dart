
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musichive/view/pages/OtherUserProfile.dart';
//import 'package:musichive/view/pages/settings.dart';
import 'package:musichive/view/presentation/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
 List<String> status = ['remove',"requested", "follow", "cancel"] ;

 enum  currentStatus {
     remove,
   requested,
   follow,
   cancel
 }
class CloudFirestoreSearch extends StatefulWidget {

  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
   bool isLoading;
  String name = "";
  List<String> names = [];
  List <DocumentSnapshot> filteredUsers =[];
   static SharedPreferences prefs;
  static  String currentUser;
   List <String> new_list = [];
   static List <String> otherUser_list = [];
  @override
  void initState() {
      super.initState();
      isLoading = true;
      read_prefs();
    }
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
                    title:
                    Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                      Text(filteredUsers[index].data()['nickname']),
                        TextButton(child:   Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           crossAxisAlignment: CrossAxisAlignment.center,
                            children:
                        [ Icon(Icons.person_add_outlined),
                             Text(isLoading?   "loading":
                                 status[getStatus(filteredUsers[index].data()['id']).index]
                             )
                          ] ,

                        ) ,
                          onPressed: () {
                          updateStatus(filteredUsers[index].data()['id']);
              },
                        ) ,

                      ]
                    ),


                  ),
                );
              }

          }

        },
      ),
    );
  }
  void read_prefs() async {

    prefs = await SharedPreferences.getInstance();
    //return prefs;
    currentUser = prefs.getString('id') ?? '';
            this.setState(() {      
              isLoading = false;    
            });                     

  }
currentStatus getStatus (String userId)
 {
   //read_prefs();

   if(prefs== null) {
     read_prefs();
     return currentStatus.remove;
   }
   else {
            if (prefs.containsKey('following')) {
              if(prefs.getStringList('following').contains(userId))
                return currentStatus.remove;
              else
              if  (prefs.containsKey('requested'))
              {
                if(prefs.getStringList('requested').contains(userId))
                  return currentStatus.cancel;
                else
                  return currentStatus.follow;

              }
              else
              {
                updatedatabase('requested', []);
                return currentStatus.follow;
              }


            }
            else
              {
                updatedatabase('following', []);
                return currentStatus.follow;
              }





       //return currentStatus.requested;
     }
   }
   void updateRequestedUser (String userId, bool add) async
   {
     final QuerySnapshot result = await FirebaseFirestore.instance.collection('users').where('id' , isEqualTo: userId).get();
     final List<DocumentSnapshot> documents = result.docs;
     otherUser_list.clear();
     if(documents[0].data().containsKey('requests'))
      documents[0].data()['requests'].forEach((element) {otherUser_list.add(element.toString());});



     if(add) {
       otherUser_list.add(currentUser);
       FirebaseFirestore.instance.collection('users').doc(userId).update({
         'requests': otherUser_list
       });
     }
     else
       {
         otherUser_list.remove(currentUser);
         FirebaseFirestore.instance.collection('users').doc(userId).update({
           'requests': otherUser_list
         });

       }

   }
   void updatedatabase(String field, List <String> new_list)  async  {

     FirebaseFirestore.instance.collection('users').doc(currentUser).update({
       field: new_list
              }).then((data) async {
       await prefs.setStringList(field, new_list);
       setState(() {
         isLoading = false;
       });
     });

   }
   currentStatus updateStatus( String userId)
   {
     this.setState(() {
       isLoading = true;
     });
     if(prefs== null) {
       read_prefs();
       //return currentStatus.remove;
     } else {
       this.setState(() {
         isLoading = true;
       });
       currentStatus stat = getStatus(userId);
       switch (stat) {
         case currentStatus.follow:
           {
             new_list = prefs.getStringList('requested');
             new_list.add(userId);
             updatedatabase('requested', new_list);
             updateRequestedUser(userId, true);
             break;
           }
         case currentStatus.cancel:
           {
             new_list = prefs.getStringList('requested');
             new_list.remove(userId);
             updatedatabase('requested', new_list);
             updateRequestedUser(userId, false);
             break;
           }
         case currentStatus.remove:
           {
             new_list = prefs.getStringList('following');
             new_list.remove(userId);
             updatedatabase('following', new_list);
             break;
           }
          default:
            {
              break;
            }


       }

       this.setState(() {
         isLoading = true;
       });

       read_prefs();
       return currentStatus.requested;
     }
   }
 }

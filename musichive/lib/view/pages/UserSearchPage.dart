import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = filteredUsers[index];
                    return Card(
                      child: Row(
                        children: <Widget>[
                          Image.network(
                            data.data()['photoUrl'],
                            width: 150,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            data.data()['nickname'],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

          }

        },
      ),
    );
  }

}
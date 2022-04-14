import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ListforDonation extends StatefulWidget {
  @override
  _ListforDonationState createState() => _ListforDonationState();
}

class _ListforDonationState extends State<ListforDonation> {
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference donateQueries = FirebaseFirestore.instance.collection('Queries').doc('DonatePending').collection('DonatePending');
    return StreamBuilder<QuerySnapshot>(
        stream: donateQueries.snapshots(),
        builder:
            (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting||snapshot.hasData!=true){
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(backgroundColor: Colors.black,),
              ),
            );
          }
          else{
            return snapshot.data.docs.length==0?Center(child: Text('You have No Donation Query', style: TextStyle(fontSize: 24.0),)):ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Container(
                        color: Colors.grey,
                        child: Column(
                            children: <Widget>[
                              ListTile(
                                  leading: Icon(Icons.contact_page,
                                    size: 30.0,
                                  ),
                                  title: Text(snapshot.data.docs[index].get('Username'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  subtitle: Text(snapshot.data.docs[index].get('Number')),
                                  trailing: Text(snapshot.data.docs[index].get('Date'))
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                child: FlatButton(
                                  onPressed: () async {
                                    DocumentSnapshot documentSnapshot = await _firestore.collection('Queries').doc('DonatePending').collection('DonatePending').doc(snapshot.data.docs[index].reference.id).get();
                                    Map<String, dynamic> data = documentSnapshot.data();
                                    await _firestore.collection('Queries').doc('DonateSolved').collection('DonateSolved').doc().set({
                                      'Username': data['Username'],
                                      'Number': data['Number'],
                                      'Email': data['Email'],
                                      'timestampQueryGenerated': data['timestampQueryGenerated'],
                                      'timestampQuerySolved': FieldValue.serverTimestamp()
                                    });
                                    await _firestore.collection('Queries').doc('DonatePending').collection('DonatePending').doc(snapshot.data.docs[index].reference.id).delete();
                                  },
                                  minWidth: double.infinity,
                                  color: Colors.orange,
                                  child: Text('Solved'),
                                ),
                              )
                            ]
                        )
                    ),
                  );
                }
            );
          }
        }
    );
  }
}

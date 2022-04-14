import 'package:admin_app/DetailedReturnPendingOrders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReturnPendingOrders extends StatefulWidget {
  @override
  _ReturnPendingOrdersState createState() => _ReturnPendingOrdersState();
}

class _ReturnPendingOrdersState extends State<ReturnPendingOrders> {
  CollectionReference Orders=FirebaseFirestore.instance.collection('Orders').doc('Return Pending').collection('Return Pending');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Orders.orderBy('timestampReturnInitiated',descending: true).snapshots(),
        builder:
            (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasData != true) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Currently Return Pending Books: ${snapshot.data.docs.length}'),
              backgroundColor: Colors.blue,
            ),
            body: snapshot.data.docs.length==0?Center(child: Text('Your do not have any Return Orders!!!', style: TextStyle(fontSize: 20.0),)):ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DetailedReturnPendingOrders(
                            OrderID: snapshot.data.docs[index].get('OrderID'),
                            UserID: snapshot.data.docs[index].get('UserID'),
                            UserName: snapshot.data.docs[index].get('UserName'),
                            Number: snapshot.data.docs[index].get('Number'),
                            Address: snapshot.data.docs[index].get('Address'),
                            Price: snapshot.data.docs[index].get('Price'),
                            Quality: snapshot.data.docs[index].get('Quality'),
                            Quantity: snapshot.data.docs[index].get('Quantity'),
                            BookName: snapshot.data.docs[index].get('Name'),
                            Date: snapshot.data.docs[index].get('Date'),
                            imageURL: snapshot.data.docs[index].get('imageURL'),
                            ISBN: snapshot.data.docs[index].get('ISBN'),
                          )),
                        );
                      },
                      child: Container(
                        color: Colors.orange,
                        child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: ListTile(
                              title: Text('${snapshot.data.docs[index].get('UserName')}, ${snapshot.data.docs[index].get('Number')}'),
                              subtitle: Text(snapshot.data.docs[index].get('Name')),
                              trailing: Text(snapshot.data.docs[index].get('Date')),
                            )
                        ),
                      ),
                    ),
                  );
                }
            ),
          );
        }
    );
  }
}

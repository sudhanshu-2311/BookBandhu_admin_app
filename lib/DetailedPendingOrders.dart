import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class DetailedPendingOrders extends StatefulWidget {
  String OrderID;
  String UserID;
  String UserName;
  String Number;
  String Address;
  String Quality;
  String BookName;
  String Quantity;
  String imageURL;
  String Price;
  String Date;
  String ISBN;

  DetailedPendingOrders(
      {Key key, @required this.OrderID,@required this.UserID,@required this.UserName,@required this.Address,@required this.Number, @required this.Quantity,@required this.Quality,@required this.BookName,@required this.imageURL,@required this.Date,@required this.Price, @required this.ISBN})
      : super(key: key);
  @override
  _DetailedPendingOrdersState createState() => _DetailedPendingOrdersState();
}

class _DetailedPendingOrdersState extends State<DetailedPendingOrders> {
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('Order ID: ${widget.OrderID}'),
          ),
          body:
          Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    color: Colors.grey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Delivering to : ${widget.UserName}, ${widget.Number}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300
                              ),
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(widget.Address,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            )
                        ),
                      ],
                    )
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Your item are:',
                    style: TextStyle(
                        fontWeight: FontWeight.w300
                    ),
                  ),
                ),
                Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: Colors.green,
                          leading: CachedNetworkImage(
                            imageUrl: widget.imageURL,
                            placeholder: (context, url) =>
                                Center(child: Container(height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator())),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          title: Text(widget.BookName),
                          subtitle: Text(widget.Quality),
                          trailing: Text('${widget.Price}*${widget.Quantity}'),
                        ),
                      ),
              ]
          ),
          bottomNavigationBar: MaterialButton(
            color: Colors.orange,
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Successful Delivery'),
                      content: Text('Deliver done for this Order?'),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () async {
                              await _firestore.collection('Users').doc(
                                  widget.UserID).collection('Your Orders').doc(widget.ISBN+widget.Quality+widget.OrderID).update({
                                'Status': 'Delivered',
                                'timestampDelivered': FieldValue.serverTimestamp()
                              });
                         DocumentSnapshot snapshot= await _firestore.collection('Orders').doc('Pending').collection('Pending').doc(widget.ISBN+widget.Quality+widget.OrderID).get();
                              Map<String, dynamic> data =snapshot.data();
                              await _firestore.collection('Orders').doc('Delivered').collection('Delivered').doc(widget.ISBN+widget.Quality+widget.OrderID).set({
                                'ISBN': data['ISBN'],
                                'Name': data['Name'],
                                'Price': data['Price'],
                                'Quality': data['Quality'],
                                'Quantity': data['Quantity'],
                                'imageURL': data['imageURL'],
                                'Date': data['Date'],
                                'UserID': data['UserID'],
                                'Address': data['Address'],
                                'UserName': data['UserName'],
                                'Number': data['Number'],
                                'timestampDelivered': FieldValue.serverTimestamp(),
                                'OrderID': data['OrderID'],
                                'timestampOrdered': data['timestampOrdered']
                              });
                              await _firestore.collection('Orders').doc('Pending').collection('Pending').doc(widget.ISBN+widget.Quality+widget.OrderID).delete();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('Yes')
                        ),
                        TextButton(
                            onPressed: ()  {
                            Navigator.of(context).pop();
                            },
                            child: Text('No')
                        )
                      ],
                    );
                  }
              );
            },
            child: Text('Delivered'),
          ),
        );
  }
}


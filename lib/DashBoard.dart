import 'package:admin_app/PendingOrders.dart';
import 'package:admin_app/Queries.dart';
import 'package:admin_app/ReturnPendingOrders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}
class _DashBoardState extends State<DashBoard> {
  int Total=0;
  int TotalOrder=0;
  int TotalBooks=0;
  int UnsuccessfulOrders=0;
  int TotalQuery=0;
  @override
  void initState() {
  getTotalAmount();
  getTotalOrder();
  getTotalQuery();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh_sharp),
              onPressed: () async {
                int total=0;
                int totalBooks=0;
                QuerySnapshot documentTotal= await FirebaseFirestore.instance.collection('Orders').doc('Successful Order').collection('Successful Order').get();
                documentTotal.docs.forEach((document) {
                  Map<String, dynamic> data = document.data();
                  total = total + data['Price'];
                  totalBooks = totalBooks + data['Quantity'];
                });
                QuerySnapshot docuTotal= await FirebaseFirestore.instance.collection('Orders').doc('Cancelled').collection('Cancelled').get();
                QuerySnapshot documenTotal= await FirebaseFirestore.instance.collection('Orders').doc('Returned').collection('Returned').get();
                  if(total!=Total)
                    setState(() {
                      Total=total;
                    });
                  if(totalBooks!=TotalBooks)
                    setState(() {
                      TotalBooks=totalBooks;
                    });
                  if(TotalOrder!=documentTotal.docs.length)
                    setState(() {
                      TotalOrder=documentTotal.docs.length;
                    });
                  if(UnsuccessfulOrders!=docuTotal.docs.length+documenTotal.docs.length)
                    setState(() {
                      UnsuccessfulOrders=docuTotal.docs.length+documenTotal.docs.length;
                    });
              }
          ),
          Stack(
              children: <Widget>[
                MaterialButton(
                    onPressed: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Queries()),
                      );
                    },
                    child: Text('Query',
                      style:TextStyle(
                          fontSize: 20.0
                      ),
                    )
                ),
                Positioned(
                    top: 5.0,
                    right: 5.0,
                    child: CircleAvatar(
                      radius: 8.0,
                      backgroundColor: Colors.orange,
                      child: Center(
                              child: Text(TotalQuery.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0
                                ),
                              ),
                            )
                    )
                )
              ]
          )
        ],
      ),
      body: GridView.count(
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        crossAxisCount: 2,
        children: <Widget>[
          Padding(                                                              //Total Revenue
            padding: EdgeInsets.all(16.0),
            child: Container(
              color: Colors.blueAccent,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text('Total Revenue',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500
                        ),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text(Total.toString(),
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
          Padding(                                                                                 //Total Books Sold
            padding: EdgeInsets.all(16.0),
            child: Container(
              color: Colors.blueAccent,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text('Total Books Sold',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500
                        ),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text(TotalBooks.toString(),
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
          Padding(                                                                              //Total Successful Orders
            padding: EdgeInsets.all(16.0),
            child: Container(
              color: Colors.blueAccent,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text('Successful\n    Orders',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500
                        ),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text(TotalOrder.toString(),
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      )
                  )
                ],
              ),
            ),
          ),

          Padding(                                                              //Total Unsuccessful Order
            padding: EdgeInsets.all(16.0),
            child: Container(
              color: Colors.blueAccent,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text('Unsuccessful \n      Orders',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500
                        ),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text(UnsuccessfulOrders.toString(),
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: MaterialButton(
              color: Colors.green,
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          PendingOrders())
                  );
                },
                child: Text('Pending Orders')
            ),
          ),
          Expanded(
            flex: 1,
            child: MaterialButton(
                color: Colors.red,
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          ReturnPendingOrders())
                  );
                },
                child: Text('Return Orders')
            ),
          )
        ],
      ),
    );
  }
 Future<String> getTotalAmount() async{
    QuerySnapshot documentTotal= await FirebaseFirestore.instance.collection('Orders').doc('Successful Order').collection('Successful Order').get();
    documentTotal.docs.forEach((document) {
      Map<String, dynamic> data = document.data();
      setState(() {
        Total = Total + int.parse(data['Price']);
        TotalBooks=TotalBooks+int.parse(data['Quantity']);
      });
    });
    setState(() {
      TotalOrder= documentTotal.docs.length;
    });
  }
  Future<String> getTotalOrder() async{
    QuerySnapshot docuTotal= await FirebaseFirestore.instance.collection('Orders').doc('Cancelled').collection('Cancelled').get();
    QuerySnapshot documentTotal= await FirebaseFirestore.instance.collection('Orders').doc('Returned').collection('Returned').get();
    setState(() {
      UnsuccessfulOrders= docuTotal.docs.length+documentTotal.docs.length;
    });
  }
  Future<String> getTotalQuery() async{
    QuerySnapshot docuTotal= await FirebaseFirestore.instance.collection('Queries').doc('SellPending').collection('SellPending').get();
    QuerySnapshot documentTotal= await FirebaseFirestore.instance.collection('Queries').doc('DonatePending').collection('DonatePending').get();
    setState(() {
      TotalQuery= docuTotal.docs.length+documentTotal.docs.length;
    });
  }
}
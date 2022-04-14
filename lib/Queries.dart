import 'package:admin_app/ListforDonation.dart';
import 'package:admin_app/ListforSelling.dart';
import 'package:flutter/material.dart';

class Queries extends StatefulWidget {
  @override
  _QueriesState createState() => _QueriesState();
}

class _QueriesState extends State<Queries> {
  bool Selling= true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Queries'
        )
      ),
      body: Selling==true?ListforSelling():ListforDonation(),
      bottomNavigationBar:   Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: MaterialButton(
              color: Selling == true ? Colors.blue : Colors.white,
              textColor: Colors.black,
              onPressed: (){
                setState(() {
                  Selling=true;
                });
              },
              child: Text('Selling queries'),
            ),
          ),
          Expanded(
            flex: 1,
            child: MaterialButton(
              color: Selling == true ? Colors.white : Colors.blue,
              textColor: Colors.black,
              onPressed: (){
                setState(() {
                  Selling=false;
                });
              },
              child: Text('Donation queries'),
            ),
          )
        ],
      ),
    );
  }
}

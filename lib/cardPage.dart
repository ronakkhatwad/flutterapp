import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:http/http.dart' as http;

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

List<Card> cards = [];

class _CardPageState extends State<CardPage> {
  bool _isLoading = true;

  //getting data from API
  void getData() async {
    var url = Uri.parse('https://api.coincap.io/v2/assets');
    var response = await http.get(
      url,
    );
    List dataList = jsonDecode(response.body)['data'];
    for (int i = 0; i < dataList.length; i++) {
      setState(() {
        cards.insert(
          i,
          Card(
            dataList[i]['name'],
            dataList[i]['symbol'],
            dataList[i]['priceUsd'],
          ),
        );
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Stack of cards that can be swiped. Set width, height, etc here.
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // Important to keep as a stack to have overlay of cards.
      child: (_isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: cards,
            ),
    );
  }
}

class Card extends StatefulWidget {
  // Made to distinguish cards
  // Add your own applicable data here
  final String name;
  final String symbol;
  final String price;
  static const kTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color(0xff001D6E),
    fontFamily: 'Roboto',
    fontStyle: FontStyle.italic,
  );

  Card(this.name, this.symbol, this.price);

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  var color = Colors.white;
  bool _isVisible = false;
  var icon = Icon(
    Icons.thumb_down,
    color: Colors.white.withOpacity(0.5),
    size: 60,
  );
  @override
  Widget build(BuildContext context) {
    return Swipable(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: color,
            ),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Crypto Currency',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff001D6E),
                      fontFamily: 'Oleo Script Swash Caps',
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Name : ${widget.name}',
                    style: Card.kTextStyle,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Symbol : ${widget.symbol}',
                    style: Card.kTextStyle,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Price (USD) : ${widget.price}',
                    style: Card.kTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color(0xff7FB5FF).withOpacity(0.2),
              ),
              child: Center(
                child: icon,
              ),
            ),
          ),
        ],
      ),
      onSwipeStart: (value) {
        setState(() {
          //color = Color(0xff7FB5FF);
          _isVisible = true;
          //print(value.localPosition);
        });
      },
      onPositionChanged: (value) {
        if (value.delta.dx < 0) {
          setState(() {
            icon = Icon(
              Icons.thumb_down,
              color: Colors.blueAccent.withOpacity(0.5),
              size: 60,
            );
          });
        } else if (value.delta.dx > 0) {
          setState(() {
            icon = Icon(
              Icons.thumb_up,
              color: Colors.blueAccent.withOpacity(0.5),
              size: 60,
            );
          });
        } else if (value.delta.dy < 0) {
          setState(() {
            icon = Icon(
              Icons.open_in_browser,
              color: Colors.blueAccent.withOpacity(0.5),
              size: 60,
            );
          });
        }
      },
      onSwipeRight: (offset) {
        final snackBar = SnackBar(
          content: Text('Liked'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onSwipeLeft: (offset) {
        final snackBar = SnackBar(
          content: Text('Disliked'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onSwipeUp: (offset) {
        final snackBar = SnackBar(
          content: Text('Swiped Up!'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onSwipeCancel: (offset, value) {
        setState(() {
          _isVisible = false;
        });
      },
    );
  }
}

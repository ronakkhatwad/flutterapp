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
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
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

class Card extends StatelessWidget {
  // Made to distinguish cards
  // Add your own applicable data here
  final String name;
  final String symbol;
  final String price;
  static const kTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  Card(this.name, this.symbol, this.price);

  @override
  Widget build(BuildContext context) {
    return Swipable(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Color(0xffC4DDFF),
        ),
        child: Center(
          child: Column(
            children: [
              const Text(
                'Crypto Currency',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Name : $name',
                style: kTextStyle,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Symbol : $symbol',
                style: kTextStyle,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Price (USD) : $price',
                style: kTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

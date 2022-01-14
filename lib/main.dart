import 'package:anotherweatherapp/screens/menu/menu.dart';
import 'package:anotherweatherapp/screens/homepage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'screens/searchcitiespage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(// navigation bar color
    statusBarColor: Colors.black, // status bar color
  ));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Weather App",
    home: Menu(),

  ));
}


    // MaterialApp(
    //
    //   debugShowCheckedModeBanner: false,
    //   title: "Weather App",
    //   home: menu(),
    //
    // ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Homepage();
  }
}

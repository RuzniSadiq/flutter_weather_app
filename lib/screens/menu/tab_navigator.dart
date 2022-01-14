import 'package:flutter/material.dart';
import 'package:anotherweatherapp/screens/menu/menu.dart';
import 'package:anotherweatherapp/screens/searchcitiespage.dart';
import 'package:anotherweatherapp/screens/homepage.dart';
import 'package:anotherweatherapp/screens/locationpage.dart';
import 'package:anotherweatherapp/screens/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}





class TabNavigator extends StatefulWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  @override
  Widget build(BuildContext context) {
    Widget? child ;
    if(widget.tabItem == "Page1")
      child = Homepage();
    else if(widget.tabItem == "Page2")
      child = LocationPage();
    else if(widget.tabItem == "Page3")
      child = searchCities();

    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => child!
        );
      },
    );
  }
}

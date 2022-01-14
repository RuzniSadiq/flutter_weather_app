import 'package:anotherweatherapp/screens/menu/tab_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String _currentPage = "Page1";
  List<String> pageKeys = ["Page1", "Page2", "Page3"];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
  };
  int _selectedIndex = 0;


  void _selectTab(String tabItem, int index) {
    if(tabItem == _currentPage ){
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "Page1") {
            _selectTab("Page1", 1);

            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
            children:<Widget>[
              _buildOffstageNavigator("Page1"),
              _buildOffstageNavigator("Page2"),
              _buildOffstageNavigator("Page3"),
            ]
        ),
        bottomNavigationBar: BottomNavigationBar(
          //type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white,
          iconSize: 23,
          selectedFontSize: 20,
          unselectedFontSize: 10,
          showSelectedLabels: false,
          showUnselectedLabels: false,

          //selectedItemColor: Colors.blueAccent,
          onTap: (int index) { _selectTab(pageKeys[index], index); },
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Location',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: Colors.blue,
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );

  }











  Widget _buildOffstageNavigator(String tabItem, {bool keepState = false}) {
    if (!keepState) {
      return Visibility(
        visible: _currentPage == tabItem,
        child: TabNavigator(
          navigatorKey: _navigatorKeys[tabItem]!,
          tabItem: tabItem,
        ),
      );
    } else {
      return Offstage(
        offstage: _currentPage != tabItem,
        child: TabNavigator(
          navigatorKey: _navigatorKeys[tabItem]!,
          tabItem: tabItem,
        ),
      );
    }
  }
}


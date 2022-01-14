import 'package:anotherweatherapp/database/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anotherweatherapp/models/cities.dart';
import 'package:anotherweatherapp/screens/viewcitydetails.dart';
import 'package:anotherweatherapp/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

//state
class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  DatabaseHelper? helper;
  List allCities = [];
  List items = [];
  TextEditingController toSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    helper = DatabaseHelper();
    helper!.allCities().then((data) {
      allCities = data;
      items = allCities;
    });
  }

  //getting the value entered in the text field
  void filterSeach(String query) async {
    print("Searching");
    //assign all the cities
    var dummySearchList = allCities;
    if (query.isNotEmpty) {
      //providing empty data
      var dummyListData = [];
      //for each loop
      dummySearchList.forEach((item) {
        print("Searching");
        var citiez = City.fromMap(item);
        //match by the city name
        if (citiez.cityname!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      //set the state
      setState(() {
        items = [];
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items = [];
        items = allCities;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("back button");
        return false;
      },
      //returning scaffold
      // Scaffold will give you a default struture properties like appbar, body, etc
      child: Scaffold(
        //safe area to not go beyond safe area and keep in screen
        body: SafeArea(
          //container keeps objects in place like div
          child: Container(
              //expanding the container to the whole page initially it only had a portion in left
              width: double.infinity,
              //adding padding in this container for all sides
              //padding: EdgeInsets.all(24.0),
              //adding padding in this container for vertical horizontal only
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ),

              //assigning background color
              color: const Color(0xFF212121),
              //so we can place things above each other
              child: Stack(
                children: [
                  Column(
                    //making everything from let to right on the screen

                    children: [
                      //this container we have out logo

                      //inkwell is gesturedetector which gives a nice ripple effect
                      Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 32.0,
                              top: 32.0,
                              left: 20.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 60.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  children: const [
                                    Text(
                                      "Home",
                                      style: TextStyle(
                                          fontSize: 40,
                                          height: 1.2,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white70),
                                    ),
                                    Icon(
                                      Icons.home,
                                      color: Colors.white70,
                                      size: 30.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 82.0,
                          bottom: 50,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              //passing the entered value to the
                              //filter search method
                              filterSeach(value);
                            });
                          },
                          controller: toSearch,
                          decoration: const InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,

                            // enabledBorder: const OutlineInputBorder(
                            //   borderSide: const BorderSide(
                            //     color: Colors.white,
                            //
                            //
                            //   ),
                            //   borderRadius: BorderRadius.all(Radius.circular(15))
                            // ),
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.white38),
                            //labelText: 'Search',
                            labelStyle: TextStyle(color: Colors.white38),
                            //fillColor: Colors.orange, filled: true,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      //wrapping the listview in the expanded widget so
                      // it wont show an error and we can insert a list in the column
                      Expanded(
                        //creating a list so we can have a list here
                        child: FutureBuilder<List<City>>(
                            //providing empty data
                            initialData: [],
                            //calling the getcities method to display all cities
                            future: _dbHelper.getCities(),

                            //this is gonna give us context and snapshot
                            builder: (context, snapshot) {
                              return ListView.builder(

                                  itemCount: items.length,
                                  itemBuilder: (context, i) {
                                    print("All cities returned");
                                    final item = items[i];
                                    City cities = City.fromMap(items[i]);
                                    //using dismissible to delete cities on slide
                                    return Dismissible(
                                      background: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.0, bottom: 25.0),
                                        child: Container(
                                          height: 100.0,
                                          width: 100.0,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Text(
                                                    'Delete Item',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      key: UniqueKey(),
                                      //when we slide dismiss a city run this
                                      onDismissed: (direction) {
                                        City _newCity = City(
                                          cityname: cities.cityname,
                                          citycountry: cities.citycountry,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Row(
                                            children: const [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                  child: Text(
                                                      'Deleted Successfully!')),
                                            ],
                                          ),
                                          action: SnackBarAction(
                                              label: "UNDO",
                                              //if the undo label is pressed insert deleted city again
                                              onPressed: () async {
                                                await _dbHelper
                                                    .insertCity(_newCity);
                                                print("Successfully re-inserted city ${cities.cityname}");
                                                setState(() {});
                                              }
                                              // this is what you needed
                                              ),
                                        ));

                                        _dbHelper.deleteCity(cities.id);
                                        print("City has been deleted successfully - ${cities.cityname}");
                                        items.removeAt(i);
                                        setState(() {});

                                        //
                                        // });
                                      },
                                      child: GestureDetector(
                                        //detect on tap whenever we press on this task
                                        onTap: () async {
                                          //what we want to do is get the id from the snapshot above and
                                          //navigate to that card task page
                                          //                             Navigator.push(context, CupertinoPageRoute(builder: (context) => viewCityDetails.sh(text: cities.cityname))).then((value) {
                                          // setState(() {});});
                                          print(
                                              "${await _dbHelper.getCount(cities.cityname)}");
                                          _dbHelper
                                              .getCount(cities.cityname)
                                              .then((value) async => {
                                                    Navigator.of(context,
                                                            rootNavigator:
                                                                false)
                                                        .push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                viewCityDetails.shy(
                                                                    text: cities
                                                                        .cityname,
                                                                    num: value),
                                                            maintainState:
                                                                false)),
                                                  });

                                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>viewCityDetails.sh(text: cities.cityname))).then((value) {
                                          //   setState(() {});
                                          // });
                                        },

                                        child: TaskCardWidget(
                                          city: cities.cityname,
                                          citycountry: cities.citycountry,
                                        ),
                                      ),
                                    );
                                  });
                            }

                            //placing the taskcardwidget here so that need not place a whole lot of code here

                            ),

                        //placing the taskcardwidget here so that need not place a whole lot of code here
                      ),
                    ],
                  ),
                  //wrap the container inside the position widget so we can place it anywhere in the screen
                  //the floating action button or plus mark button
                ],
              )),
        ),
      ),
    );
  }
}

void doNothing(BuildContext context) {}

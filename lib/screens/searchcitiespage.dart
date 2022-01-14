import 'package:anotherweatherapp/database/database_helper.dart';
import 'package:anotherweatherapp/screens/viewcitydetails.dart';
import 'package:flutter/material.dart';
import 'viewcitydetails.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class searchCities extends StatefulWidget {
  @override
  _searchCitiesState createState() => _searchCitiesState();
}

class _searchCitiesState extends State<searchCities> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position? _currentPosition;
  var _currentAddress;
  late String lat;
  late String long;
  var city = new TextEditingController();
  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;
  var cityname;
  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        lat = position.latitude.toString();
        long = position.longitude.toString();
      });
    //PLEASE USE WEATHER API FROM https://openweathermap.org/api
      http.Response response = await http.get(Uri.parse
          ("http://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${long}&appid=f63eb40ff9d6ec5cb7baf16eead43759"));
      var results = jsonDecode(response.body);

      setState(() {
        this.temp = results['main']['temp'];
        this.description = results['weather'][0]['description'];
        this.currently = results['weather'][0]['main'];
        this.humidity = results['main']['humidity'];
        this.windspeed = results['wind']['speed'];
        this.cityname = results['name'];
      });
      print(lat);
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: Color(0xFF212121),
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
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Align(

                              alignment: Alignment.center,

                              child: Row(
                                children: const [
                                  Text(

                                    "Search Cities",
                                    style: TextStyle(
                                        fontSize: 40,
                                        height: 1.2,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white70
                                    ),




                                  ),
                                  Icon(Icons.location_city, color: Colors.white70, size: 30.0,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 82.0,
                        bottom: 50,

                      ),
                      child: TextField(
                        controller: city,
                        decoration: InputDecoration(

                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(
                                color: Colors.white),
                          ),

                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),

                          ),
                          hintText: 'Search City...',
                          hintStyle: const TextStyle( color: Colors.white38),
                          labelText: 'Search',
                          labelStyle: const TextStyle(color: Colors.white38),
                          //fillColor: Colors.orange, filled: true,
                          //prefixIcon: Icon(Icons.search, color: Colors.white70,),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white70),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => viewCityDetails.sh(
                              //         text: city.text,
                              //       ),
                              //     ));
                              _dbHelper.getCount(city.text).then((value) async => {
                                Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
                                    builder: (context) => viewCityDetails.shy(text: city.text, num: value), maintainState: false)),


                              });
                              print(city.text);
                            },
                          ),
                        ),


                        style: const TextStyle(color: Colors.white),
                      ),
                    ),


                  ],
                ),
                //wrap the container inside the position widget so we can place it anywhere in the screen
                //the floating action button or plus mark button

              ],
            )),
      ),
    );
  }
}

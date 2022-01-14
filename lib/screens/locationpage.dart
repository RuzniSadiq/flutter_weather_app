import 'package:flutter/material.dart';
import 'package:anotherweatherapp/database/database_helper.dart';
import 'package:anotherweatherapp/models/cities.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:anotherweatherapp/screens/showmoreweatherdetails.dart';

class LocationPage extends StatefulWidget {
  String? text;
  //const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  PermissionStatus? _status;
  Position? _currentPosition;
  var _currentAddress;
  late String lat;
  late String long;
  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;
  var country;
  var cityname;
  String? _cityname;

  @override
  void initState() {
    super.initState();
    this._getCurrentLocation();
    requestPermission();
  }

  //using this method we request for the user's permission to access location
  void requestPermission()async{
    var status = await Permission.locationWhenInUse.status;
    if(!status.isGranted){
      await Permission.locationWhenInUse.request();
    }
  }

  //using this method we get the current location of the user
  _getCurrentLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: true)
        .then((Position position) async {
      if (this.mounted) {
        setState(() {
          //extracting the latitude and logitude from the captured location
          _currentPosition = position;
          lat = position.latitude.toString();
          long = position.longitude.toString();
          print("Location captured successfully latitude - $lat, longitude - $long");
        });
      }
      //here we pass the lat and long captured from the user's location
      http.Response response = await http.get(Uri.parse
        ("http://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${long}&appid=f63eb40ff9d6ec5cb7baf16eead43759"));
      var results = jsonDecode(response.body);
      if (this.mounted) {
        setState(() {
          //we set the state/assign values to the variables created
          this.temp = results['main']['temp'];
          this.description = results['weather'][0]['description'];
          this.currently = results['weather'][0]['main'];
          this.humidity = results['main']['humidity'];
          this.windspeed = results['wind']['speed'];
          this.cityname = results['name'];
          this.country = results['sys']['country'];
        });
      }
    }).catchError((e) {
      print(e);
    });
  }
  @override
  Widget build(BuildContext context) {

    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return Scaffold(
      body: (temp != null &&
          description != null &&
          currently != null &&
          humidity != null &&
          windspeed != null)
          ? Container(
        height: double.infinity,
        width: double.infinity,

        child: Stack(children: <Widget>[
          Container(
            height: 420.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage((currently == "Thunderstorm")
                //font white
                    ? 'assets/images/svg/images/thunder.jpg'
                    : (currently == "Drizzle")
                //keep black
                    ? 'assets/images/svg/images/drizzle.jpg'
                    : (currently == "Rain")
                //white fonts
                    ? 'assets/images/svg/images/rain.jpg'
                    : (currently == "Snow")
                //black font
                    ? 'assets/images/svg/images/snow.jpg'

                    : (currently == "Mist")
                //keep black
                    ? 'assets/images/svg/images/mist.jpg'
                    : (currently == "Smoke")
                    ? 'assets/images/svg/images/mist.jpg'
                    : (currently == "Haze")
                    ? 'assets/images/svg/images/mist.jpg'
                    : (currently == "Dust")
                    ? 'assets/images/svg/images/mist.jpg'
                    : (currently == "Fog")
                    ? 'assets/images/svg/images/mist.jpg'
                    : (currently == "Sand")
                    ? 'assets/images/svg/images/mist.jpg'
                    : (currently == "Ash")
                    ? 'assets/images/svg/images/mist.jpg'
                    : (currently == "Squall")
                    ? 'assets/images/svg/images/mist.jpg'
                    : (currently == "Tornado")
                    ? 'assets/images/svg/images/mist.jpg'

                    : (currently == "Clear")
                //white fonts
                    ? 'assets/images/svg/images/clear.png'
                    : (currently == "Clouds")
                //white fonts only below stuff
                    ? 'assets/images/svg/images/clouds.png'

                    : 'assets/images/svg/images/clear.png'),
                fit: BoxFit.cover,

                //   colorFilter: ColorFilter.mode(
                //       //Colors.black.withOpacity(0.6), BlendMode.dstATop),

              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [


                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () async {
                            //print("Click the back button");
                            //Navigator.pop(context);

                            DatabaseHelper _dbHelper = DatabaseHelper();

                            City _newCity = City(
                              cityname: cityname,
                              citycountry: country,
                            );

                            _dbHelper.getCount(widget.text).then((value) async => {
                              print("$value"),
                              if(value==0) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(

                                  content: Row(
                                    children: const [
                                      Icon(Icons.add_task_sharp, color: Colors.greenAccent,),
                                      SizedBox(width:20),
                                      Expanded(child: Text('Added Successfully')),
                                    ],
                                  ),
                                )),
                                await _dbHelper.insertCity(_newCity),
                                print("New city has been inserted successfully"),
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(

                                  content: Row(
                                    children: const [
                                      Icon(Icons.info, color: Colors.greenAccent,),
                                      SizedBox(width:20),
                                      Expanded(child: Text('Added already!')),
                                    ],
                                  ),
                                )),
                              }
                            });



                            // await _dbHelper.insertCity(_newCity);
                            // print("New city has been inserted successfully");
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 0.0, left: 20.0),
                            child: Image(
                              image: AssetImage(
                                'assets/new.png',
                              ),
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.0, right: 20.0),
                          child: Text(

                            capitalize(cityname.toString()),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 35.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                fontFamily: 'JosefinSans'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 5.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        country.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontFamily: 'JosefinSans'),
                      ),
                    ),


                  ),


                  const SizedBox(height: 120),
                  (currently == "Thunderstorm" || currently == "Rain" || currently == "Clear" || currently == "Clouds")
                      ?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child:
                        Row(children: <Widget>[

                          const Icon(Icons.thermostat_rounded, color: Colors.white),
                          Text(
                            temp != null
                                ? temp.toString() + "\u00b0"
                                : "Loading",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              //fontWeight: FontWeight.w700,
                              fontFamily: 'JosefinSans',
                              letterSpacing: 3,
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Row(children: <Widget>[
                          // Icon(Icons.cloud_circle_sharp),
                          Image(
                            width: 50.0,
                            image: AssetImage(
                              (currently == "Thunderstorm")
                              //font white
                                  ? 'assets/images/png/weather_icons/11d@2x.png'
                                  : (currently == "Drizzle")
                              //keep black
                                  ? 'assets/images/png/weather_icons/10d@2x.png'
                                  : (currently == "Rain")
                              //white fonts
                                  ? 'assets/images/png/weather_icons/10d@2x.png'
                                  : (currently == "Snow")
                              //black font
                                  ? 'assets/images/png/weather_icons/13d@2x.png'

                                  : (currently == "Mist")
                              //keep black
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Smoke")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Haze")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Dust")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Fog")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Sand")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Ash")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Squall")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Tornado")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'

                                  : (currently == "Clear")
                              //white fonts
                                  ? 'assets/images/png/weather_icons/01d@2x.png'
                                  : (currently == "Clouds")
                              //white fonts only below stuff
                                  ? 'assets/images/png/weather_icons/02d@2x.png'

                                  : 'assets/images/png/weather_icons/01d@2x.png',

                              //   colorFilter: ColorFilter.mode(
                              //       //Colors.black.withOpacity(0.6), BlendMode.dstATop),



                            ),),
                          Text(
                            currently != null
                                ? currently.toString() + "\u00b0"
                                : "Loading",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                //fontWeight: FontWeight.w700,
                                fontFamily: 'JosefinSans'),
                          ),
                        ]),
                      ),
                    ],
                  ):

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child:
                        Row(children: <Widget>[

                          const Icon(Icons.thermostat_rounded),
                          Text(
                            temp != null
                                ? temp.toString() + "\u00b0"
                                : "Loading",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              //fontWeight: FontWeight.w700,
                              fontFamily: 'JosefinSans',
                              letterSpacing: 3,
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Row(children: <Widget>[
                          // Icon(Icons.cloud_circle_sharp),
                          Image(
                            width: 50.0,
                            image: AssetImage(
                              (currently == "Thunderstorm")
                              //font white
                                  ? 'assets/images/png/weather_icons/11d@2x.png'
                                  : (currently == "Drizzle")
                              //keep black
                                  ? 'assets/images/png/weather_icons/10d@2x.png'
                                  : (currently == "Rain")
                              //white fonts
                                  ? 'assets/images/png/weather_icons/10d@2x.png'
                                  : (currently == "Snow")
                              //black font
                                  ? 'assets/images/png/weather_icons/13d@2x.png'

                                  : (currently == "Mist")
                              //keep black
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Smoke")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Haze")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Dust")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Fog")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Sand")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Ash")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Squall")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'
                                  : (currently == "Tornado")
                                  ? 'assets/images/png/weather_icons/50d@2x.png'

                                  : (currently == "Clear")
                              //white fonts
                                  ? 'assets/images/png/weather_icons/01d@2x.png'
                                  : (currently == "Clouds")
                              //white fonts only below stuff
                                  ? 'assets/images/png/weather_icons/02d@2x.png'

                                  : 'assets/images/png/weather_icons/01d@2x.png',

                              //   colorFilter: ColorFilter.mode(
                              //       //Colors.black.withOpacity(0.6), BlendMode.dstATop),


                            ),),
                          Text(
                            currently != null
                                ? currently.toString() + "\u00b0"
                                : "Loading",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                //fontWeight: FontWeight.w700,
                                fontFamily: 'JosefinSans'),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 260.0),
            child: Container(

              height: 500.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ListView(
                  physics: const PageScrollPhysics(),
                  children: <Widget>[
                    GestureDetector(

                      onTap: () async {
                        //print("Click the back button");
                        Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
                            builder: (context) => showMoreWeatherDetails.sh(text: cityname), maintainState: false));








                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 230.0),
                        child: Container(
                          height: 50.0,
                          width: 160.0,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(8.0),
                            color: Color(0xFF5c5c8a),
                          ),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Text(
                                    "More",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerRight,

                                  child: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white,)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: ListTile(
                        leading: const FaIcon(
                            FontAwesomeIcons.thermometerHalf,
                            color: Colors.white),
                        title: const Text("Temperature",
                            style: TextStyle(
                                fontFamily: 'Syne',
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        trailing: Text(
                            temp != null
                                ? temp.toString() + "\u00b0"
                                : "Loading",
                            style: TextStyle(fontSize: 15, color: Colors.white,)),
                      ),
                    ),
                    ListTile(
                      leading: const FaIcon(FontAwesomeIcons.cloud,
                          color: Colors.white),
                      title: const Text("Weather",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Syne',
                              fontWeight: FontWeight.bold)),
                      trailing: Text(
                          description != null
                              ? description.toString() + "\u00b0"
                              : "Loading",
                          style: TextStyle(fontSize: 15,
                            color: Colors.white,)),
                    ),
                    ListTile(
                      leading:
                      const FaIcon(FontAwesomeIcons.sun, color: Colors.white),
                      title: const Text("Humidity",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Syne',
                              fontWeight: FontWeight.bold)),
                      trailing: Text(
                          humidity != null
                              ? humidity.toString() + "\u00b0"
                              : "Loading",
                          style: const TextStyle(fontSize: 15,  color: Colors.white,)),
                    ),
                    ListTile(
                      leading: const FaIcon(FontAwesomeIcons.wind,
                          color: Colors.white),
                      title: const Text("Wind Speed",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Syne',
                              fontWeight: FontWeight.bold)),
                      trailing: Text(
                          windspeed != null
                              ? windspeed.toString() + "\u00b0"
                              : "Loading",
                          style: const TextStyle(fontSize: 15,  color: Colors.white,)),
                    ),
                  ],
                ),
              ),
              decoration: const BoxDecoration(
                //color: Colors.red,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'assets/images/svg/vectors/main_page_vector_dark.png'))),
            ),
          ),

          //)
        ]),
      )
          : Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
            child: Column(
              children: const [

                Padding(
                  padding: EdgeInsets.only(top: 250.0),
                  child: Image(
                    width: 300.0,
                      image: AssetImage(
                    'assets/newy.gif',

                  )

                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    "Fetching data...",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
                //TextButton(onPressed: _askPermission, child: Text('Ask'))
              ],
            ),
          ),
    );
  }
}


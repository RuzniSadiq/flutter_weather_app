import 'package:anotherweatherapp/database/database_helper.dart';
import 'package:anotherweatherapp/models/cities.dart';
import 'package:anotherweatherapp/screens/showmoreweatherdetails.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class viewCityDetails extends StatefulWidget {
  String? text;
  int? num;

  //City? city;
  //viewCityDetails({required this.city});
  viewCityDetails.sh({required this.text});

  viewCityDetails.shy({required this.text, required this.num});

  //viewCityDetails({Key? key, required this.text}) : super(key: key);
  @override
  _viewCityDetailsState createState() => _viewCityDetailsState();
}

class _viewCityDetailsState extends State<viewCityDetails> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;
  var country;

  @override
  void initState() {
    super.initState();
    this.getweather();
  }

  //get weather method
  Future getweather() async {
    http.Response response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=${widget.text}&"
            "units=metric&appid=6d83b76574e05a53b20d75d3bae87c2e"));
    //checking if we are getting any response from the city entered
    if (response.statusCode == 200) {

      var results = jsonDecode(response.body);
      //setting the state/ assigning values to the variables
      setState(() {

        this.temp = results['main']['temp'];
        this.description = results['weather'][0]['description'];
        this.currently = results['weather'][0]['main'];
        this.humidity = results['main']['humidity'];
        this.windspeed = results['wind']['speed'];
        this.country = results['sys']['country'];
        print("Showing City Weather details - temperature - $temp");
        print("Showing City Weather details - description - $description");
        print("Showing City Weather details - weather - $currently");
        print("Showing City Weather details - humidity - $humidity");
        print("Showing City Weather details - windspeed - $windspeed");
        print("Showing City Weather details - country - $country");
      });
    } else {
      Navigator.pop(context);
      print('failed to fetch data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper _dbHelper = DatabaseHelper();
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return Scaffold(
        //resizeToAvoidBottomInset : false,
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

                             // await _dbHelper.getCount(widget.text).then((value) => {
                             //  print("$value");
                             //  }),
                              child:

                      (widget.num != 1)
                              ?InkWell(
                                onTap: () async {
                                  City _newCity = City(
                                    cityname: widget.text,
                                    citycountry: country,
                                  );

                                  //this method checks if city exists
                                  _dbHelper.getCount(widget.text).then((value) async => {

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
                                  print("New city has been inserted successfully ${widget.text}"),
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
                              ):const Padding(
                        padding: EdgeInsets.only(top: 0.0, left: 20.0),
                        child: Image(
                          image: AssetImage(
                            'assets/added.png',
                          ),
                          width: 30,
                        ),
                      ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0.0, right: 20.0),
                                child: Text(

                                  capitalize(widget.text.toString()),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
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
                              style: const TextStyle(
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
                              padding: EdgeInsets.only(top: 0.0),
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
                    //
                    width: double.infinity,

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
                                  builder: (context) => showMoreWeatherDetails.sh(text: widget.text), maintainState: false));








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
                                  style: const TextStyle(fontSize: 15, color: Colors.white,)),
                            ),
                          ),
                          ListTile(
                            leading: const FaIcon(FontAwesomeIcons.cloud,
                                color: Colors.white),
                            title: const Text("Weather",
                                style: const TextStyle(
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
        child: SingleChildScrollView(
          child: Column(
            children: const [

              Padding(
                padding: const EdgeInsets.only(top: 250.0),
                child: Image(
                    width: 300.0,
                    image: AssetImage(
                      'assets/newy.gif',

                    )

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
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
      ),
    );
  }
}

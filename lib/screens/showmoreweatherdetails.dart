import 'package:anotherweatherapp/database/database_helper.dart';
import 'package:anotherweatherapp/models/cities.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class showMoreWeatherDetails extends StatefulWidget {
  String? text;


  //City? city;
  //showMoreWeatherDetails({required this.city});
  showMoreWeatherDetails.sh({required this.text});


  //showMoreWeatherDetails({Key? key, required this.text}) : super(key: key);
  @override
  _showMoreWeatherDetailsState createState() => _showMoreWeatherDetailsState();
}

class _showMoreWeatherDetailsState extends State<showMoreWeatherDetails> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;
  var country;
  var perception;

  var atmosphericpressure;
  var mintem;
  var maxtem;
  var groundlevel;
  var sealevel;

  var sunrisetime;
  var sunsettime;

  var cloudliness;
  var winddirection;
  var rainvol1;
  var rainvol3;


  @override
  void initState() {
    super.initState();
    this.getweather();
    // if (widget.city != null) {
    //
    //   _cityname = widget.city!.cityname;
    //
    // }
  }

  Future getweather() async {
    http.Response response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=${widget.text}&units=metric&appid=6d83b76574e05a53b20d75d3bae87c2e"));
    if (response.statusCode == 200) {
      var results = jsonDecode(response.body);
      print("HEllo");
      print(widget.text);

      setState(() {
        this.temp = results['main']['temp'];
        this.description = results['weather'][0]['description'];
        this.currently = results['weather'][0]['main'];
        this.humidity = results['main']['humidity'];
        this.windspeed = results['wind']['speed'];
        this.country = results['sys']['country'];

        this.perception = results['main']['feels_like']; //human feel like
        this.atmosphericpressure = results['main']['pressure']; //atmospheric pressure
        this.mintem = results['main']['temp_min']; //atmospheric pressur
        this.maxtem = results['main']['temp_max']; //max tem atm
        this.sealevel = results['main']['sea_level'];
        this.groundlevel = results['main']['grnd_level'];
        this.sunrisetime = results['sys']['sunrise'];
        this.sunsettime = results['sys']['sunset'];
        this.cloudliness = results['clouds']['all'];
        this.winddirection = results['wind']['deg'];
        // this.rainvol1 = results['rain']['1h'];
        // this.rainvol3 = results['rain']['3h'];
      });
    } else {
      //throw Exception('failed to fetch data.');
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
          ? SafeArea(
            child: Container(
        height: double.infinity,
        width: double.infinity,

              child: Stack(children: <Widget>[

                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF212121),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top:160.0),
                      child: ListView(
                        physics: const PageScrollPhysics(),
                        children: <Widget>[
                          ListTile(
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
                          ListTile(
                            leading: const FaIcon(FontAwesomeIcons.directions,
                                color: Colors.white),
                            title: const Text("Wind Direction",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Syne',
                                    fontWeight: FontWeight.bold)),
                            trailing: Text(
                                winddirection != null
                                    ? winddirection.toString() + "\u00b0"
                                    : "Loading",
                                style: const TextStyle(fontSize: 15,  color: Colors.white,)),
                          ),








                          ListTile(
                            leading: const FaIcon(FontAwesomeIcons.solidHandPaper,
                                color: Colors.white),
                            title: const Text("Perception",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Syne',
                                    fontWeight: FontWeight.bold)),
                            trailing: Text(
                                perception != null
                                    ? perception.toString() + "\u00b0"
                                    : "Loading",
                                style: const TextStyle(fontSize: 15,  color: Colors.white,)),
                          ),

                          ListTile(
                            leading: const FaIcon(FontAwesomeIcons.wind,
                                color: Colors.white),
                            title: const Text("Atmospheric Pressure",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Syne',
                                    fontWeight: FontWeight.bold)),
                            trailing: Text(
                                atmosphericpressure != null
                                    ? atmosphericpressure.toString() + "\u00b0"
                                    : "Loading",
                                style: const TextStyle(fontSize: 15,  color: Colors.white,)),
                          ),
                          ListTile(
                            leading: const FaIcon(FontAwesomeIcons.temperatureLow,
                                color: Colors.white),
                            title: const Text("Minimum Temperature",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Syne',
                                    fontWeight: FontWeight.bold)),
                            trailing: Text(
                                mintem != null
                                    ? mintem.toString() + "\u00b0"
                                    : "Loading",
                                style: const TextStyle(fontSize: 15,  color: Colors.white,)),
                          ),
                          ListTile(
                            leading: const FaIcon(FontAwesomeIcons.temperatureHigh,
                                color: Colors.white),
                            title: const Text("Maximum Temperature",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Syne',
                                    fontWeight: FontWeight.bold)),
                            trailing: Text(
                                maxtem != null
                                    ? maxtem.toString() + "\u00b0"
                                    : "Loading",
                                style: const TextStyle(fontSize: 15,  color: Colors.white,)),
                          ),

                          ListTile(
                            leading: const FaIcon(FontAwesomeIcons.cloudMeatball,
                                color: Colors.white),
                            title: const Text("Cloudliness",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Syne',
                                    fontWeight: FontWeight.bold)),
                            trailing: Text(
                                cloudliness != null
                                    ? cloudliness.toString() + "\u00b0"
                                    : "Loading",
                                style: const TextStyle(fontSize: 15,  color: Colors.white,)),
                          ),





                        ],
                      ),
                    ),

                  ),

                  //)
                Padding(
                  padding:  const EdgeInsets.only(top: 50.0, left: 15.0),
                  child: Row(
                    children:  [
                      InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                      },
                          child: Icon(Icons.arrow_back, color: Colors.white70, size: 30.0,)),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text(

                          "Weather Details",
                          style: TextStyle(
                              fontSize: 30,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.white70
                          ),




                        ),
                      ),
                      Icon(Icons.wb_sunny, color: Colors.white70, size: 20.0,),


                    ],
                  ),
                ),
                ]),
            ),
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

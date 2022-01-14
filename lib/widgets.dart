import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class TaskCardWidget extends StatefulWidget {
  //const TaskCardWidget({Key? key}) : super(key: key);

  //adding the ? allows the variable to be nullable
  //the title variable is for the title
  final String? city;
  final String? citycountry;


  //constructor
  TaskCardWidget({this.city, this.citycountry});
  @override
  _TaskCardWidgetState createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;
  var country;

  @override
  void initState() {
    this.getweather();
    super.initState();

  }


  Future getweather() async {
    http.Response response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=${widget.city}&units=metric&appid=6d83b76574e05a53b20d75d3bae87c2e"));

      var results = jsonDecode(response.body);


    if (mounted) {
      setState(() {
        this.temp = results['main']['temp'];
        this.description = results['weather'][0]['description'];
        this.currently = results['weather'][0]['main'];
        this.humidity = results['main']['humidity'];
        this.windspeed = results['wind']['speed'];
        this.country = results['sys']['country'];
      });
    }

  }



  @override
  Widget build(BuildContext context) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return Container(

      //get infinite width
        width: double.infinity,
        height: 100.0,
        //changing the color of the task card widget
        padding: const EdgeInsets.only(

          top: 25.0,
          left: 24.0,

        ),
        //adding margins between each cards
        margin: const EdgeInsets.only(
          bottom: 30.0,
        ),
        decoration: BoxDecoration(
          //you cant have color and border decoration separately! they should be together
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage
              (image: AssetImage(
                (currently == "Thunderstorm")
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
                fit: BoxFit.cover)),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    //color: Color(0xFF002036FF),
                    //borderRadius: BorderRadius.circular(5.0),

                  ),
                  child: Text(

                    capitalize(widget.city.toString()),



                    style:
                    (currently == "Clouds")
                    ?TextStyle(


                      color: Color(0xFFbfbfbf),
                      fontSize: 22.0,
                      //backgroundColor: Colors.black,


                      fontWeight: FontWeight.w600,

                    ):
                    TextStyle(


                      color: Colors.white,
                      fontSize: 22.0,
                      //backgroundColor: Colors.black,


                      fontWeight: FontWeight.w600,

                    ),


                  ),
                ),
                  //if title is null then set name to unnamed


              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Flexible(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image(
                      width: 49.0,
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
                  ),
                ),


                Flexible(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        //if country is null then set name to loading
                        widget.citycountry ?? "Loading",


                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,

                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),




          ],
        ));
  }

}




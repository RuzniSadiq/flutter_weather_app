class City {
   int? id;
   String ? cityname;
   String ? citycountry;

   City({this.id, this.cityname, this.citycountry});

   City.fromMap(Map<String,dynamic> data){
    id = data['id'];
    cityname = data['cityname'];
    citycountry = data['citycountry'];
  }
  // a method that wil convert the object to a map
  //map of keytype string and value type dynamic meaning any type of value
  //this method will help create the map of the city object
  Map<String, dynamic> toMap(){
    //this method will return everything mapped storing everything in the correct field id in id field
    return{
      'id': id,
      'cityname': cityname,
      'citycountry': citycountry
    };
  }
}



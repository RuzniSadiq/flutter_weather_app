import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

import '../models/cities.dart';

//here wel create a method that wel use to create the database and tables
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();
  static Database? _db;
  //when the code is run if the table didnt exist it will create one else it wont
  Future<Database> database() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'weather.db'),
      onCreate: (db, version) async{
        // Run the CREATE TABLE statement on the database.
        await db.execute("CREATE TABLE city(id INTEGER PRIMARY KEY, cityname TEXT UNIQUE, citycountry TEXT)");

      },
      version: 1,
    );
  }

  //Use of async and await enables the use of ordinary try / catch blocks around asynchronous code
  Future<int> insertCity(City city) async {
    int cityId = 0;
    //opening up the database first
    //note the database() is the method we created above
    Database _db = await database();
    //perform some query nw
    //acessing the toMap method in the model class

    await _db.insert('city', city.toMap(),
  //conflict algorithm if the data conflicts we can abort the operation or replace or ignore it
        conflictAlgorithm: ConflictAlgorithm.replace).then((value)
    //its going to be the id of the city that we are submitting to the database
    {
      //set the city id to the value we get
      cityId = value;

    });
    return cityId;
  }
  //


  Future<List> allCities() async{
    Database db = await database();
    //db.rawQuery('select * from courses');
    return db.query('city');
  }

  // Future<List> checkAvaialbleCity(String cityname) async{
  //   Database db = await database();
  //   //db.rawQuery('select * from courses');
  //   return db.rawQuery('SELECT * FROM city WHERE cityname LIKE $cityname');
  // }

  //Delete city, delete from city where id matches the id we pass here
  Future<void> deleteCity(int? id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM city WHERE id = '$id'");
  }

  //check if city exists
 getCount(String? cityname) async {
    Database db = await database();
    var x = await db.rawQuery("SELECT COUNT (*) from city WHERE cityname = '$cityname'");
    int? count = Sqflite.firstIntValue(x);
    return count!;
  }



  Future<List<City>>? getCities() async {
    Database _db = await database();
    //We want to query the city table
    List<Map<String, dynamic>> cityMap = await _db.query('city');
    //return as a list generate the list
    //1st argument - length of the list from the city map
    //2nd argument - value itself
    return List.generate(cityMap.length, (index) {
      //creating a city model
      return City(
          id: cityMap[index]['id'],
          cityname: cityMap[index]['cityname'],
        citycountry: cityMap[index]['citycountry'],);

    });
  }
}

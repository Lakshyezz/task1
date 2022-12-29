import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task1/methods/api_methods.dart';
import 'package:task1/model/user_repo.dart';
import 'package:task1/sql_database/database_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];
  Database? _database;

  Future<List<dynamic>> getData() async {
    data = await ApiMethods().getDataFromApi();
    print(data);
    return data;
  }

  Future<Database?> openDB() async {
    _database = await DataBaseHandler()
        .openDB(); // connecting it to one in database folder
  }

  // Future<void> insertDB() async {
  //   _database = await openDB();
  //   UserRepo userRepo = new UserRepo();
  //   userRepo.createTable(_database);
  //   for (int i = 0; i < data.length; i++) {
  //     await _database?.insert('User', data);
  //   }
  // }

  @override
  void initState() {
    Future<List<dynamic>> getData() async {
      data = await ApiMethods().getDataFromApi();
      print(data);
      return data;
    }

    Future<void> insertDB() async {
      _database = await openDB();
      UserRepo userRepo = new UserRepo();
      userRepo.createTable(_database);
      dynamic res = await ApiMethods().getDataFromApi();
      for (int i = 0; i < data.length; i++) {
        await _database?.insert('User', res);
      }
      await _database?.close();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                TextField(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {},
                      title: Text(
                        "${data[index]['name']}",
                        style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(.7),
                            fontWeight: FontWeight.w500),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

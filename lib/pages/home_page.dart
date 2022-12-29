import 'dart:convert';

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
  List foundUsers = [];
  Database? _database;
  static String selectedUser = "";

  Future<dynamic> getData() async {
    final res = await ApiMethods().getDataFromApi();
    final decoded = jsonDecode(res);

    data = decoded;
    return data;
    // print(data[0]);
  }

  Future<Database?> openDB() async {
    _database = await DataBaseHandler().openDB();
    return _database;
  }

  Future<void> insertDB() async {
    _database = await openDB();
    UserRepo userRepo = new UserRepo();
    userRepo.createTable(_database);

    for (int i = 0; i < data.length; i++) {
      // await _database?.insert('User', data[i]);
    }
    await _database?.close();
  }

  Future<void> getFromUser() async {
    _database = await openDB();
    UserRepo userRepo = new UserRepo();
    await userRepo.getUsers(_database);
    await _database?.close();
  }

  @override
  void initState() {
    getData().then((value) {
      setState(() {});
    });

    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = data;
    } else {
      results = data
          .where((user) =>
              user['name'].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      print(results);
    }
    setState(() {
      foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    suffixIcon: Icon(Icons.search),
                    label: Text("Search"),
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                // InkWell(
                //     onTap: () async {
                //       // await getData();
                //     },
                //     child: Container(
                //       height: 80,
                //       width: 200,
                //       color: Colors.pink,
                //       child: Text('Pink Button'),
                //     )),
                // InkWell(
                //     onTap: () async {
                //       setState(() {});

                //       setState(() {});
                //     },
                //     child: Container(
                //       height: 80,
                //       width: 200,
                //       color: Colors.cyan,
                //       child: Text("Cyan Button"),
                //     )),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount:
                      foundUsers.length != 0 ? foundUsers.length : data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 80,
                      padding: const EdgeInsets.all(2),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          //<-- SEE HERE
                          side: BorderSide(width: 1),

                          borderRadius: BorderRadius.circular(4),
                        ),
                        onTap: () {
                          selectedUser = foundUsers[index]['name'];
                          final snackBar = SnackBar(
                            content: Text('Yay! ${selectedUser} found!'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {},
                            ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        title: Center(
                          child: Text(
                            "${foundUsers.length != 0 ? foundUsers[index]['name'] : data[index]['name']}",
                            style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(.7),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

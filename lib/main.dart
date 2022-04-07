import 'package:blog_app/Blog/AddBlog.dart';
import 'package:blog_app/Pages/HomePage.dart';
import 'package:blog_app/Pages/WelcomePage.dart';
import 'package:blog_app/Profile/MainProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = WelcomePage();
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async{
    String? token = await storage.read(key: "token");
    if(token != null){
      setState(() {
        page = HomePage();
         print(storage);
      });
    }
    else{
      setState(() {
        page = WelcomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: page,
    );
  }
}

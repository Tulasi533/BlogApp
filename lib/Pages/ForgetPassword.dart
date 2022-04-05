import 'dart:convert';

import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/Pages/HomePage.dart';
import 'package:blog_app/Pages/SignUpPage.dart';
import 'package:blog_app/Pages/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({ Key? key }) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? errorText;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.green
            ],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.repeated
          )
        ),
        child: Form(
          key: _globalkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Forget Password",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 20,),
                usernameTextField(),
                SizedBox(height: 20,),
                passwordTextField(),
                SizedBox(height: 40,),
                InkWell(
                  onTap: () async{
                    Map<String, String> data = {
                      "password": _passwordController.text
                    };

                    var response = await networkHandler.patch(
                      "/user/update/${_usernameController.text}", data);

                    if(response.statusCode == 200 || response.statusCode == 201){
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (context)=> WelcomePage()), 
                        (route) => false
                      );
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF00A86B)
                    ),
                    child: Center(
                      child: circular ? CircularProgressIndicator() : Text(
                        "Update Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  )
                ),
                
              ],
            ),
          )
        ),
      ),
    );
  }
  
  Widget usernameTextField()
  {
    return Column(
      children: [
        Text("Username"),
        TextFormField(
          controller: _usernameController,
          // validator: (value){
          //   if(value!.isEmpty)
          //   return "Username can't be Empty";
          //   // username unique or not
          //   return null;
          // },
          decoration: InputDecoration(
            errorText: validate ? null : errorText,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2
              )
            )
          ),
        )
      ],
    );
  }
  
  Widget passwordTextField()
  {
    return Column(
      children: [
        Text("Password"),
        TextFormField(
          controller: _passwordController,
          obscureText: vis,
          decoration: InputDecoration(
            errorText: validate ? null : errorText,
            suffixIcon: IconButton(
              icon: Icon(vis?Icons.visibility_off:Icons.visibility),
              onPressed: (){
                setState(() {
                  vis = !vis;
                });
              },
            ),
            helperText: "Password length should have >= 8",
            helperStyle: TextStyle(
              fontSize: 14,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2
              )
            )
          ),
        )
      ],
    );
  }
}
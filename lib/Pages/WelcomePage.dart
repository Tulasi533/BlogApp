import 'package:blog_app/Pages/SignInPage.dart';
import 'package:blog_app/Pages/SignUpPage.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin{
  late AnimationController _controller1;
  late Animation<Offset> animation1;
  late AnimationController _controller2;
  late Animation<Offset> animation2;
  
  

  @override
  void initState(){
    super.initState();

    // animation 1
    _controller1 = AnimationController(duration: Duration(milliseconds: 1000),vsync: this);
    animation1 = (Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeOut),
    )) as Animation<Offset>;

    // animation 2
    _controller2 = AnimationController(duration: Duration(milliseconds: 2500),vsync: this);
    animation2 = (Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.elasticInOut),
    )) as Animation<Offset>;
    _controller1.forward();
    _controller2.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            children: [
              SlideTransition(
                position: animation1,
                child: Text(
                  "QuickCoder",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/6,),
              SlideTransition(
                position: animation1,
                child: Text(
                  "Great stories for great people.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 38,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              boxContainer("assets/images/google_logo.png", "Sign up with Google", null),
              SizedBox(height: 20,),
              boxContainer("assets/images/facebook_logo.png", "Sign up with Facebook", null),
              SizedBox(height: 20,),
              boxContainer("assets/images/email_logo.png", "Sign up with Email", onEmailClick),
              SizedBox(height: 20,),
              SlideTransition(position: animation2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }

  onEmailClick() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SignUpPage(),
    ));
  }
  Widget boxContainer(String path, String text, onClick)
  {
    return SlideTransition(
      position: animation2,
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width-140,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Image.asset(path, height: 25, width: 25,),
                  SizedBox(width: 20,),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.black87
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
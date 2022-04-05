import 'package:blog_app/Blog/AddBlog.dart';
import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/Pages/WelcomePage.dart';
import 'package:blog_app/Screen/HomeScreen.dart';
import 'package:blog_app/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int currentState = 0;
  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  List<String> titleString = ["Home Page", "Profile Page"];
  final storage = FlutterSecureStorage();

  NetworkHandler networkHandler = NetworkHandler();
  String username = "";
  Widget profilePhoto = Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    )
                  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async
  {
    var response = await networkHandler.get("/profile/checkProfile");
    setState(() {
      username = response['username'];
    });
    if(response["status"] == true){
      setState(() {
        profilePhoto = CircleAvatar(
              radius: 50,
              backgroundImage: NetworkHandler().getImage(response['username']),
            );
      });
    }
    else{
      setState(() {
        profilePhoto = Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    )
                  );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  profilePhoto,
                  SizedBox(height: 10,),
                  Text("@$username")
                ],
              )
            ),
            ListTile(
              title: Text("All Post"),
              trailing: Icon(Icons.launch),
              onTap: () {}
            ),
            ListTile(
              title: Text("New Post"),
              trailing: Icon(Icons.add),
              onTap: () {}
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () {}
            ),
            ListTile(
              title: Text("Feedback"),
              trailing: Icon(Icons.feedback),
              onTap: () {}
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: logout
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(titleString[currentState]),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _key.currentState!.openDrawer(), 
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: Text(
          "+",
          style: TextStyle(
            fontSize: 40
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  }, 
                  color: currentState==0 ? Colors.white : Colors.white54,
                  icon: Icon(Icons.home), 
                  iconSize: 40
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentState = 1;
                    });
                  }, 
                  color: currentState==1 ? Colors.white : Colors.white54,
                  icon: Icon(Icons.person), 
                  iconSize: 40
                )
              ],
            )
          ),
        ),
      ),
      body: widgets[currentState]
    );
  }

  void logout() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> WelcomePage()), (route) => false);
  }
}
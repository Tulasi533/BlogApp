import 'package:blog_app/Blog/Blogs.dart';
import 'package:blog_app/Model/profileModel.dart';
import 'package:blog_app/NetworkHandler.dart';
import 'package:flutter/material.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({ Key? key }) : super(key: key);

  @override
  State<MainProfile> createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profileModel = ProfileModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();
  }
  void fetchData() async {
    var response = await networkHandler.get("/profile/getData");
    
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
    // String hi = profileModel.username ?? "Hello";
    // print(hi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        // leading: IconButton(
        //   onPressed: () {}, 
        //   icon: Icon(Icons.arrow_back),
        //   color: Colors.black,
        // ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.edit),
            color: Colors.black,
          )
        ],
      ),
      body: circular?Center(child: CircularProgressIndicator()):ListView(
        children: [
          head(),
          Divider(thickness: 0.8),
          otherDetails("About", profileModel.about.toString()),
          otherDetails("Name", profileModel.name.toString()),
          otherDetails("Profession", profileModel.profession.toString()),
          otherDetails("DOB", profileModel.DOB.toString()),
          Divider(thickness: 0.8),
          SizedBox(height: 20),
          Blogs(url: "/blogPost/getOwnBlog")
        ],
      ),
    );
  }

  Widget head(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkHandler().getImage(profileModel.username.toString()),
            ),
          ),
          Text(
            profileModel.username.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10),
          Text(profileModel.titleline.toString())
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 15
            ),
          )
        ],
      )
    );
  }
}
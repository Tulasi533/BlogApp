import 'dart:convert';

import 'package:blog_app/CustomWidget/OverlayCard.dart';
import 'package:blog_app/Model/addBlogModels.dart';
import 'package:blog_app/NetworkHandler.dart';
import 'package:blog_app/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({ Key? key }) : super(key: key);

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  final _globalkey = GlobalKey<FormState>();
  ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  IconData iconphoto = Icons.image;

  NetworkHandler networkHandler = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          FlatButton(
            onPressed: () {
              if(_imageFile!.path != null && _globalkey.currentState!.validate()){
                showModalBottomSheet(
                  context: context, 
                  builder: (builder) => OverlayCard(
                    imageFile: _imageFile, 
                    title: _title.text,
                  )
                );
              }
            }, 
            child: Text(
              "Preview",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue
              ),
            )
          )
        ],
      ),
      body: Form(
        key: _globalkey,
        child:ListView(
          children: [
            titleTextField(),
            bodyTextField(),
            SizedBox(height: 20),
            addButton()
          ]
        )
      ),
    );
  }

  Widget titleTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if(value!.isEmpty) {
            return "Title can't be empty";
          }
          else if(value.length > 100){
            return "Title length should be <= 100";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2
            )
          ),
          labelText: "Add Image and Title",
          prefixIcon: IconButton(
            icon: Icon(
              iconphoto,
              color: Colors.teal,
            ),
            onPressed: takeCoverPhoto,
          )
        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Widget bodyTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: _body,
        validator: (value) {
          if(value!.isEmpty) {
            return "Body can't be empty";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2
            )
          ),
          labelText: "Provide body of your Blog",
        ),
        maxLines: 15,
      ),
    );
  }

  Widget addButton() {
    return InkWell(
      onTap: () async{
        if(_imageFile != null && _globalkey.currentState!.validate()){
          AddBlogModel addBlogModel = AddBlogModel(body: _body.text, title: _title.text);
          var response = await networkHandler.post1("/blogPost/Add", addBlogModel.toJson());
          print(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {
            String id = json.decode(response.body)["data"];
            var imageResponse = await networkHandler.patchImage(
              "/blogPost/add/coverImage/$id", _imageFile!.path);
            print(imageResponse.statusCode);
            if(imageResponse.statusCode == 200 || imageResponse.statusCode == 201){
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => HomePage()), 
                (route) => false
              );
            }
          }
        }
      },
      child: Center(
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.teal
          ),
          child: Center(
            child: Text(
              "Add Blog",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
          ),
        )
      )
    );
  }

  void takeCoverPhoto() async{
    final coverPhoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = coverPhoto;
      iconphoto = Icons.check_box;
    });
  }
}
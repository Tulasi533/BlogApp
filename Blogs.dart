import 'package:blog_app/Blog/Blog.dart';
import 'package:blog_app/CustomWidget/BlogCard.dart';
import 'package:blog_app/Model/addBlogModels.dart';
import 'package:blog_app/Model/superModel.dart';
import 'package:blog_app/NetworkHandler.dart';
import 'package:flutter/material.dart';

class Blogs extends StatefulWidget {
  const Blogs({ Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel();
  List<AddBlogModel>? data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async{
    var response = await networkHandler.get(widget.url);
    superModel = SuperModel.fromJson(response);
    setState(() {
      data = superModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data!.length>0 ? Column(
      children: data!
      .map((item) => Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context)=> Blog(
                  addBlogModel: item,
                  networkHandler: networkHandler,
                ))
              );
            },
            child: BlogCard(
              addBlogModel: item, 
              networkHandler: networkHandler
            ),
          ),
          SizedBox(height: 10)
        ],
      )).toList(),
    ) : Center(child: Text("No Blogs Available"));
  }
}
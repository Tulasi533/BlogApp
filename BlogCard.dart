import 'dart:io';

import 'package:blog_app/Model/addBlogModels.dart';
import 'package:blog_app/NetworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BlogCard extends StatelessWidget {
  final AddBlogModel addBlogModel;
  final NetworkHandler networkHandler;
  const BlogCard({ Key? key, required this.addBlogModel, required this.networkHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: networkHandler.getImage(addBlogModel.id.toString()),
                  fit: BoxFit.fitWidth
                )
              ),
            ),
            Positioned(
              bottom: 2,
              child: Container(
                padding: EdgeInsets.all(8),
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text(
                  addBlogModel.title.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
              )
            )
          ],
        )
      )
    );
  }
}
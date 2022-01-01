import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImage extends StatefulWidget {
  final PageController pageController;
  String imageUrl;
  List<String> images;
  final int index;

  ViewImage({
    Key? key,
    required this.imageUrl,
    required this.images,
    this.index = 0,
  })  : pageController = PageController(initialPage: index),
        super(key: key);

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  List<String> sliderData = [
    "https://images.unsplash.com/photo-1542826438-bd32f43d626f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1024&q=80",
    "https://images.unsplash.com/photo-1579306194872-64d3b7bac4c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1024&q=80",
    "https://images.unsplash.com/photo-1605466237773-ed648bb87197?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80",
    "https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1026&q=80",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image"),
      ),
      body: Container(
        // decoration: const BoxDecoration(color: Colors.black),
        child: InteractiveViewer(
          child: PhotoViewGallery.builder(
              reverse: true,
              pageController: widget.pageController,
              itemCount: widget.images.length,
              // onDoubleTap: _handleDoubleTap,
              builder: (context, index) {
                final imageUrl = widget.images[index];
                debugPrint("*********************" + imageUrl);
                return PhotoViewGalleryPageOptions(
                  // imageProvider: NetworkImage(imageUrl),
                  imageProvider: FileImage(File(imageUrl)),

                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 4,
                  // child: Image.network(
                  // File(urlImage),
                  // fit: BoxFit.contain,
                  // height: double.infinity,
                  // width: double.infinity,
                  // alignment: Alignment.center,
                );
              }
              // Image.file(
              //   File(widget.imageUrl),
              //   fit: BoxFit.contain,
              //   height: double.infinity,
              //   width: double.infinity,
              //   alignment: Alignment.center,
              // ),
              ),
        ),
      ),
    );
  }
}

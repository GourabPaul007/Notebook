import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/message_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImage extends ConsumerStatefulWidget {
  final PageController pageController;
  // String imageUrl;
  // List<String> images;
  final int index;

  ViewImage({
    Key? key,
    // required this.imageUrl,
    // required this.images,
    this.index = 0,
  })  : pageController = PageController(initialPage: index),
        super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewImageState();
}

class _ViewImageState extends ConsumerState<ViewImage> {
  @override
  Widget build(BuildContext context) {
    final messageService = ref.watch(messageServiceProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(ref.watch(messageServiceProvider).images.elementAt(widget.index).title),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        // decoration: const BoxDecoration(color: Colors.black),
        child: InteractiveViewer(
          child: PhotoViewGallery.builder(
              reverse: true,
              pageController: widget.pageController,
              itemCount: ref.watch(messageServiceProvider).images.length,
              // onDoubleTap: _handleDoubleTap,
              builder: (context, index) {
                final imageUrl = ref.watch(messageServiceProvider).images[index].body;
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

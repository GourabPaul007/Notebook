import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool showAppBar = true;
  late String imageName;

  @override
  void initState() {
    String imageTitle = ref.read(messageServiceProvider).getTappedImage(widget.index).title;
    String imageUrl = ref.read(messageServiceProvider).getTappedImage(widget.index).body;
    imageName = imageTitle == "" ? imageUrl.substring(imageUrl.lastIndexOf("/") + 1) : imageTitle;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final messageService = ref.watch(messageServiceProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: showAppBar ? true : false,
        // title: showAppBar ? Text(ref.watch(messageServiceProvider).images.elementAt(widget.index).title) : null,
        // leading: showAppBar
        //     ? IconButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //         icon: const Icon(
        //           Icons.arrow_back_rounded,
        //           color: Colors.white,
        //         ),
        //       )
        //     : null,
        title: showAppBar
            ? Text(
                imageName,
                softWrap: true,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              )
            : null,
        backgroundColor: showAppBar ? Colors.black45 : Colors.transparent,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      body: InteractiveViewer(
        child: PhotoViewGallery.builder(
            reverse: true,
            pageController: widget.pageController,
            itemCount: ref.watch(messageServiceProvider).images.length,
            onPageChanged: (index) {
              String imageTitle = ref.watch(messageServiceProvider).images[index].title;
              String imageUrl = ref.watch(messageServiceProvider).images[index].body;
              setState(() {
                imageName = imageTitle == "" ? imageUrl.substring(imageUrl.lastIndexOf("/") + 1) : imageTitle;
                showAppBar = true;
              });
            },
            builder: (context, index) {
              final imageUrl = ref.watch(messageServiceProvider).images[index].body;
              debugPrint("*********************" + imageUrl);
              return PhotoViewGalleryPageOptions(
                  imageProvider: FileImage(File(imageUrl)),
                  initialScale: PhotoViewComputedScale.contained * 9 / 10,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 4,
                  onTapDown: (_, __, ___) {
                    setState(() {
                      showAppBar = !showAppBar;
                    });
                  });
            }),
      ),
    );
  }
}

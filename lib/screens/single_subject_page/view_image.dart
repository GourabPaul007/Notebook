import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/message_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImage extends ConsumerStatefulWidget {
  final PageController pageController;
  final int index;

  ViewImage({
    Key? key,
    this.index = 0,
  })  : pageController = PageController(initialPage: index),
        super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewImageState();
}

class _ViewImageState extends ConsumerState<ViewImage> with SingleTickerProviderStateMixin {
  bool _showAppBar = true;
  late String imageName;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    String imageTitle = ref.read(messageServiceProvider).getTappedImage(widget.index).title;
    String imageUrl = ref.read(messageServiceProvider).getTappedImage(widget.index).path;
    imageName = imageTitle == "" ? imageUrl.substring(imageUrl.lastIndexOf("/") + 1) : imageTitle;
  }

  @override
  Widget build(BuildContext context) {
    // final messageService = ref.watch(messageServiceProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SlidingAppBar(
        controller: _controller,
        visible: _showAppBar,
        child: AppBar(
          title: Text(
            imageName,
            softWrap: true,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          backgroundColor: Colors.black,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      body: InteractiveViewer(
        child: PhotoViewGallery.builder(
          reverse: true,
          pageController: widget.pageController,
          itemCount: ref.watch(messageServiceProvider).images.length,
          onPageChanged: (index) {
            String imageTitle = ref.watch(messageServiceProvider).images[index].title;
            String imageUrl = ref.watch(messageServiceProvider).images[index].path;
            setState(() {
              imageName = imageTitle == "" ? imageUrl.substring(imageUrl.lastIndexOf("/") + 1) : imageTitle;
              _showAppBar = true;
            });
          },
          builder: (context, index) {
            final imageUrl = ref.watch(messageServiceProvider).images[index].path;
            return PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(imageUrl)),
                initialScale: PhotoViewComputedScale.covered,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 4,
                onTapDown: (_, __, ___) {
                  setState(() {
                    _showAppBar = !_showAppBar;
                  });
                });
          },
        ),
      ),
    );
  }
}

class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SlidingAppBar({
    Key? key,
    required this.child,
    required this.controller,
    required this.visible,
  }) : super(key: key);

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}

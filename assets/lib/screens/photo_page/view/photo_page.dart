import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:leychenko_pixabay_test_app/services/api/api.dart';
import 'package:leychenko_pixabay_test_app/services/theme/theme.dart';
import 'package:gap/gap.dart';

import '../block/photo_page_bloc.dart';

class PhotoPageScreen extends StatefulWidget {
  final String index;

  const PhotoPageScreen({super.key, required this.index});

  @override
  PhotoPageScreenState createState() => PhotoPageScreenState();
}

class PhotoPageScreenState extends State<PhotoPageScreen> {
  final PhotoPageBloc photoPageBloc = PhotoPageBloc();
  late ImageProvider imageProvider;

  @override
  void initState() {
    super.initState();
    photoPageBloc.photoModel =
        GetIt.I<ApiPhotos>().listPhotos[int.parse(widget.index)];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            decoration: BoxDecoration(
              color: appTheme.appBarTheme.backgroundColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text("PHOTO")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () => photoPageBloc.sharePhoto(context),
              icon: const Icon(Icons.share)),
          const Gap(10)
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                const Gap(10),
                Expanded(
                  child: LayoutBuilder(builder:
                      (_, BoxConstraints constraints) {
                    Size imgBoxSize = photoPageBloc.initImageBoxSize(
                        constraints.maxWidth, constraints.maxHeight);
                    return Column(
                      children: [
                        Hero(
                          tag: widget.index,
                          child: CachedNetworkImage(
                              imageUrl:
                                  photoPageBloc.photoModel.largeImageURL,
                              placeholder: (context, url) {
                                return Container(
                                  width: imgBoxSize.width,
                                  height: imgBoxSize.height,
                                  color: Colors.black12,
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 9.0,
                                  )),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return const Icon(Icons.error);
                              },
                              imageBuilder: (context, imageProvider) {
                                this.imageProvider = imageProvider;
                                return Container(
                                  width: imgBoxSize.width,
                                  height: imgBoxSize.height,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                decoration: BoxDecoration(
                  color: appTheme.appBarTheme.backgroundColor!.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        color: Colors.white,
                        onPressed: () {},
                        icon: const Icon(Icons.fullscreen)),
                    IconButton(
                        color: Colors.white,
                        onPressed: () {},
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        color: Colors.white,
                        onPressed: () {},
                        icon: const Icon(Icons.cut))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

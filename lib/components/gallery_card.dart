import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:novelai_manager/model/gallery_data.dart';
import 'package:novelai_manager/util/db_util.dart';

class GalleryCard extends StatelessWidget {
  final GalleryData galleryData;
  final Function(GalleryData) onTap;

  const GalleryCard({
    super.key,
    required this.galleryData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    //何らかの原因でプロンプトデータがnullだった時にクラッシュしないために
    //空っぽのリストを生成しておく
    var imageList = List<ImageData>.empty();
    if (galleryData.promptData != null) {
      imageList = galleryData.promptData!.generatedImageList;
    }

    return SizedBox(
      width: 256,
      child: Card(
        child: InkWell(
          onTap: () {
            onTap(galleryData);
          },
          child: Column(
            children: [
              SizedBox(
                width: 256,
                height: 256,
                child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1,
                  ),
                  items: imageList.map((value) {
                    return SizedBox(
                      width: 256,
                      height: 256,
                      child: FutureBuilder(
                        future: DBUtil.getImageFullPath(value.imagePath),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Text("読み込み中");
                          } else {
                            if (snapshot.data == "") {
                              return const Text("画像が存在しません");
                            } else {
                              return Ink.image(
                                image: FileImage(File(snapshot.data!)),
                                fit: BoxFit.cover,
                              );
                            }
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text(
                      galleryData.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

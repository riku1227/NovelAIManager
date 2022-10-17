import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:novelai_manager/model/schema/gallery_schema.dart';
import 'package:novelai_manager/util/db_util.dart';

/// ギャラリーの画像とタイトルを表示するウィジェット
/// 画像が複数枚あるときはスライド出来るようになっている
class GalleryCard extends StatelessWidget {
  //ギャラリーデータ
  final GalleryData galleryData;
  //カードをタップ/クリックした時のコールバック
  final Function(GalleryData) onTap;

  //コンストラクタ
  const GalleryCard({
    super.key,
    required this.galleryData,
    required this.onTap,
  });

  /// 画像ウィジェット単体を作成する
  Widget buildImageWidget(ImageData imageData) {
    return FutureBuilder(
      future: DBUtil.getImageFullPath(imageData.imagePath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            //Ink.imageにすることで画像にもリップルエフェクトとかが付くようになる
            return Ink.image(
              image: FileImage(
                File(snapshot.data!),
              ),
              fit: BoxFit.cover,
            );
          }
        } else {
          return const Text("読み込み中...");
        }
      },
    );
  }

  /// カードに入れる画像を表示するウィジェットを作成する
  Widget buildCardImageWidget(List<ImageData> imageList) {
    if (imageList.isEmpty) {
      return const Text("画像が登録されていません");
    }

    /// 画像が2枚以上登録されている場合はカルーセル(スライドできる)画像を返す
    /// 1枚しか登録されていない場合は普通の画像を返す
    if (imageList.length >= 2) {
      return CarouselSlider(
        options: CarouselOptions(viewportFraction: 1),
        items: imageList.map((value) {
          return SizedBox(
            width: 256,
            height: 256,
            child: buildImageWidget(value),
          );
        }).toList(),
      );
    } else {
      return buildImageWidget(imageList[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    //プロントデータがnullだった時にクラッシュしないように空のリストを作っておく
    var imageList = List<ImageData>.empty();
    if (galleryData.promptData != null) {
      imageList = galleryData.promptData!.generatedImageList;
    }

    return SizedBox(
      width: 256,
      child: Card(
        //InkWellでクリックしたときにリップルエフェクトとかが出るようになる
        child: InkWell(
          onTap: () {
            //コールバックを呼び出す
            onTap(galleryData);
          },
          child: Column(
            children: [
              SizedBox(
                width: 256,
                height: 256,
                child: buildCardImageWidget(imageList),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

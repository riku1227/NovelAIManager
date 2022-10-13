import 'package:flutter/material.dart';
import 'package:novelai_manager/components/gallery_card.dart';
import 'package:novelai_manager/model/gallery_data.dart';
import 'package:novelai_manager/page/prompt_info_page.dart';

class GalleryGridView extends StatefulWidget {
  List<GalleryData> galleryDataList = List.empty();

  GalleryGridView({Key? key, required this.galleryDataList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GalleryGridViewState();
  }
}

class _GalleryGridViewState extends State<GalleryGridView> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.galleryDataList.map((value) {
        return GalleryCard(
          galleryData: value,
          onTap: (value) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PromptInfoPage(
                galleryData: value,
              );
            }));
          },
        );
      }).toList(),
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class GalleryCard extends StatelessWidget {
  final String title;
  const GalleryCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      child: Card(
        child: Column(
          children: [
            SizedBox(
              width: 256,
              height: 256,
              child: CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1,
                ),
                items: [
                  SizedBox(
                    width: 256,
                    height: 256,
                    child: Image.network(
                      "https://placehold.jp/512x768.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

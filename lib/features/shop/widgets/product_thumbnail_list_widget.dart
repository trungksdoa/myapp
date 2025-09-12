import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProductThumbnailListWidget extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final double padding;
  final Function(int) onImageSelected;

  const ProductThumbnailListWidget({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.padding,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(vertical: padding),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: padding),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onImageSelected(index),
            child: Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: currentIndex == index
                      ? Colors.blue
                      : Colors.grey[300]!,
                  width: currentIndex == index ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Ionicons.image_outline,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

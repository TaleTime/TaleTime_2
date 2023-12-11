import "dart:math";

import "package:flutter/material.dart";
import "package:taletime/main.dart";

class StoryImage extends StatelessWidget {
  const StoryImage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final imageSize = min(screenHeight, screenWidth) * 0.6;

    return StreamBuilder(
      stream: audioHandler.mediaItem,
      builder: (context, mediaItem) {
        return Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.transparent,
          ),
          child: Image(
              fit: BoxFit.cover,
              image: mediaItem.data?.artUri != null
                  ? NetworkImage(mediaItem.data!.artUri!.toString())
                  : const AssetImage("assets/logo.png")
                      as ImageProvider<Object>),
        );
      },
    );
  }
}

import "package:flutter/material.dart";
import "package:marquee/marquee.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/common/models/story.dart";

class StoryCard extends StatelessWidget {
  final Function()? onTap;
  final Story story;

  const StoryCard({super.key, this.onTap, required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 30),
        height: 180,
        width: 85,
        padding: const EdgeInsets.only(top: 15, left: 15, right: 10),
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: (story.imageUrl != null
                  ? NetworkImage(story.imageUrl!)
                  : const AssetImage("logo.png")) as ImageProvider<Object>,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.dstATop),
              fit: BoxFit.cover,
            )),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 0,
              right: 20,
              child: Container(
                height: 30,
                color: Colors.transparent,
                child: Marquee(
                  text: story.title ?? "",
                  blankSpace: 30,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  pauseAfterRound: const Duration(seconds: 2),
                ),
              ),
            ),
            Positioned(
              top: 35,
              left: 0,
              right: 45,
              child: Container(
                height: 30,
                color: Colors.transparent,
                child: Marquee(
                  text: "By ${story.author ?? ""}",
                  blankSpace: 20,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  pauseAfterRound: const Duration(seconds: 2),
                ),
              ),
            ),
            Positioned(
              top: 115,
              left: 92,
              right: 0,
              child: Container(
                height: 45,
                width: 15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 35,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

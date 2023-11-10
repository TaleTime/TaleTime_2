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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: story.imageUrl != null
                  ? NetworkImage(story.imageUrl!)
                  : const AssetImage("assets/logo.png")
                      as ImageProvider<Object>,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Container(
                      height: 30,
                      color: Colors.transparent,
                      child: Marquee(
                        text: story.title ?? "",
                        blankSpace: constraints.maxWidth,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        pauseAfterRound: const Duration(seconds: 2),
                        startPadding: 15,
                      ),
                    ),
                    Container(
                      height: 30,
                      color: Colors.transparent,
                      child: Marquee(
                        text: "By ${story.author ?? ""}",
                        blankSpace: constraints.maxWidth,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        pauseAfterRound: const Duration(seconds: 2),
                        startPadding: 15,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(2.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
              ],
            ),
          ),
        );
      },
    );
  }
}

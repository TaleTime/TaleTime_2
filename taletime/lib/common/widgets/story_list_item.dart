import "package:flutter/material.dart";
import "package:taletime/common/models/story.dart";

class StoryActionButton {
  const StoryActionButton({
    required this.icon,
    required this.onTab,
  });

  final IconData icon;
  final Function() onTab;
}

class StoryListItem extends StatelessWidget {
  const StoryListItem({
    super.key,
    required this.story,
    this.buttons,
  });

  final Story story;

  final List<StoryActionButton>? buttons;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.teal.shade600,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  story.imageUrl != null
                      ? Image.network(
                          story.imageUrl!,
                          fit: BoxFit.cover,
                          width: 64,
                          height: 64,
                        )
                      : Image.asset("logo.png"),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      story.title ?? "Kein name",
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (story.author != null) ...[
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          story.author!,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                    if (story.author != null && story.rating != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "ꞏ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (story.rating != null) ...[
                      Text(
                        story.rating!,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (buttons != null)
                ...buttons!.map(
                  (btn) => IconButton(
                    onPressed: btn.onTab,
                    icon: Icon(btn.icon),
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

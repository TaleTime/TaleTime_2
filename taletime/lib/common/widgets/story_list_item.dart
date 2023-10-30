import "package:flutter/material.dart";

class StoryListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.green,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      "http://placekitten.com/128/128",
                      fit: BoxFit.contain,
                      width: 64,
                      height: 64,
                    ),
                    SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        "Eine tolle ganz ganz lange Geschichte, die noch viel länger und länger und länger werden kann.",
                        // "Eine kurze Geschichte",
                        // "Das Märchen von der kleinen Prinzessin",
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ]
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                    ),
                    Text("By Foo Bar"),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("ꞏ")
                    ),
                    Text("2,5"),
                    Icon(
                      Icons.star,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () { },
                icon: const Icon(Icons.heart_broken),
              ),
              IconButton(
                onPressed: () { },
                icon: const Icon(Icons.delete),
              ),
            ],
          )
        ],
      ),
    );
  }
}

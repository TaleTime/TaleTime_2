import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/icon_context_dialog.dart';

class AddStory extends StatefulWidget {
  const AddStory({Key? key}) : super(key: key);

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(children: [
        Positioned(
        top: 10,
        left: 8,
        right: 16,
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Add Story",
            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold,),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 23,
              color: kPrimaryColor,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                size: 23,
                color: kPrimaryColor,
              ),
            )
          ],
        ),
      ),
      Positioned(
        top: 80,
        left: 22,
        right: 28,
        height: screenHeight * 0.34,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42,
              child: TextField(
                style: TextStyle(color: kPrimaryColor),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 30),
                  filled: true,
                  fillColor: Colors.blueGrey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search stories...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
        Positioned(
          top: 150,
          left: 15,
          right: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * 0.8,
                child: ListView.builder(
                    primary: false,
                    itemCount: 10,
                    itemBuilder: (_,i){
                      return
                        GestureDetector(
                          onTap: (){},
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 85,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 75,
                                      margin: EdgeInsets.only(bottom: 9),
                                      padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11),
                                        color: Colors.teal.shade600,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.transparent,
                                            ),
                                            child: Image.network(assetLogo),
                                          ),
                                          SizedBox(width: 20,),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Text(
                                                      "4.5",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "Wonderful-story ${i}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  "By Taletime-story-teller",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(flex: 3, child: Container(),),
                                          Row(
                                            children: [
                                              IconContextDialog("Add Story...",
                                                  "Do you really want to add this story?",
                                                  Icons.playlist_add_outlined
                                              ),
                                              const SizedBox(
                                                width: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );

                    }),
              )
            ],
          ),
        ),
    ],
      )
    );
  }
}


import 'package:flutter/material.dart';

import 'constants.dart';
import 'delete_popup.dart';

class MyListView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyListViewState();
  }
}

class _MyListViewState extends State<MyListView>{

  late bool isLiked = false;
  final List<IconData> _icons = [
    Icons.favorite,
    Icons.favorite_border,
  ];

  @override
  Widget build (BuildContext context){
    return ListView.builder(
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
                                  IconButton(
                                    icon: isLiked == false ? Icon(_icons[1], size: 22, color: Colors.white,) : Icon(_icons[0], size: 22, color: Colors.white,),
                                    onPressed: () {
                                      if (!isLiked){
                                        setState(() {
                                          isLiked = true;
                                        });
                                      }else{
                                        setState(() {
                                          isLiked = false;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  DeletePopup(),
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

        });
  }
}
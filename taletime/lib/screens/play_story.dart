import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';

import 'package:taletime/utils/record_class.dart';

class PlayStory extends StatefulWidget {
  const PlayStory({Key? key}) : super(key: key);

  @override
  State<PlayStory> createState() => _PlayStoryState();
}

class _PlayStoryState extends State<PlayStory> {
  double changevoice = 0.0;

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  // Beispielwerte
  double _currentValue = 10;
  Story s1 = Story.test("Test 1");
  Story s2 = Story.test("Test 2");
  Story s3 = Story.test("Test 3");
  Story s4 = Story.test("Test 4");
  Story s5 = Story.test("Test 5");
  Story s6 = Story.test("Test 6");
  Story s7 = Story.test("Test 7");
  Story s8 = Story.test("Test 8");
  List<Story> list = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      list.add(s1);
      list.add(s2);
      list.add(s3);
      list.add(s4);
      list.add(s5);
      list.add(s6);
      list.add(s7);
      list.add(s8);
    });
  }

  @override
  Widget build(BuildContext context) {
    //ImageProvider imageProvider;
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Play Story"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    //alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("logo.png"),
                      radius: 75,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //alignment: Alignment.topCenter,
                          child: Text(
                            "MahmoudeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeRRRRRRRRRRRRRRRRRRRRR",
                            style: TextStyle(color: kPrimaryColor),
                            //overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: const Text("Orabi"),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.play_circle)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite_border)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50),
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: ListView.builder(
                primary: false,
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return Card(
                    color: kPrimaryColor,
                    child: ListTile(
                        leading: Text("$index"),
                        title: Text(list[index].title),
                        subtitle: Text("$index:00"),
                        onTap: () => this
                            ._globalKey
                            .currentState
                            ?.showBottomSheet((context) =>
                                _bottomdownWidget(context, list[index].title)),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [])),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Container _bottomdownWidget(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          color: kPrimaryColor,
                          child: Center(
                            child: Text(title),
                          ),
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                )),
            Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.replay_10),
                                )),
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.skip_previous_outlined),
                                )),
                            Expanded(
                                flex: 2,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: kPrimaryColor,
                                    size: 30,
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                    onPressed: () {},
                                    icon:
                                        const Icon(Icons.skip_next_outlined))),
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.forward_10_outlined),
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Slider(
                            min: 0,
                            max: 100,
                            value: _currentValue,
                            label: "$_currentValue",
                            onChanged: (value) {
                              setState(() => _currentValue = value);
                            })),
                    Expanded(flex: 1, child: Container()),
                  ],
                )),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(flex: 1, child: Container()),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.volume_up_outlined)),
                          ),
                          Expanded(
                              flex: 3,
                              child: Slider(
                                min: 0,
                                max: 100,
                                value: changevoice,
                                onChanged: (val) {
                                  setState(() {
                                    changevoice = val;
                                  });
                                },
                              ))
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

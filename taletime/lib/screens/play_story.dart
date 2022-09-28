import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taletime/screens/login.dart';

import 'package:taletime/utils/record_class.dart';

import '../utils/constants.dart';

class PlayStory extends StatefulWidget {
  const PlayStory({Key? key}) : super(key: key);

  @override
  State<PlayStory> createState() => _PlayStoryState();
}

class _PlayStoryState extends State<PlayStory> {
  double changeVoice = 0.0;
  double changeLimit = 0.0;

  String name = "Play Story";
  TextStyle textStyle = const TextStyle(fontSize: 20, color: Colors.white);
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  List<Story> list = [];

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(name, style: textStyle),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.audio_file)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            flex: 1,
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      color: const Color.fromARGB(255, 191, 221, 192),
                      alignment: Alignment.center,

                      // ignore: prefer_const_constructors
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(assetLogo),
                        radius: 75,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: const Text(
                              "Mahmoud",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.green),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: const Text(
                              "Orabi",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 191, 221, 192)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.play_circle,
                                        color: Colors.green,
                                      ))),
                              Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.favorite_border))),
                              Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.more_vert))),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ]),
          ),
          Expanded(
            flex: 1,
            child: Consumer(builder: (context, value, child) {
              return Container(
                child: Card(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                            leading: Text("$index"),
                            title: Text("${list[index].title} $index"),
                            trailing: Text("${list[index].tags}"),
                            onTap: () => this
                                ._globalKey
                                .currentState
                                ?.showBottomSheet(
                                    (context) => _bottomdownWidget(context)));
                      })),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Container _bottomdownWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      color: const Color.fromARGB(255, 97, 92, 92),
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
                          color: Colors.blue,
                          child: const Center(
                            child: Text(
                              "Part ",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
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
                                  icon: const Icon(Icons.forward_10_outlined),
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
                                  onPressed: () { },
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    size: 30,
                                    color: Colors.green,
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
                                  icon: const Icon(Icons.replay_10),
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Slider(
                            min: 0,
                            max: 10,
                            value: changeLimit,
                            onChanged: (ch) {
                              setState(() {
                                changeLimit = ch;
                              });
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
                                value: changeVoice,
                                onChanged: (val) {
                                  setState(() {
                                    changeVoice = val;
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
/**
 *  Expanded(
            flex: 1,
            child: Container(
              child: Center(
                child: MaterialButton(
                  color: Colors.green,
                  onPressed: () {
                    /*      Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const viereck();
                      },
                    )); */
                  },
                ),
              ),
            ),
          )
 */
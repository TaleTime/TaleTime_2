import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taletime/screens/login.dart';

import 'package:taletime/utils/record_class.dart';

class Playstory extends StatefulWidget {
  const Playstory({Key? key}) : super(key: key);

  @override
  State<Playstory> createState() => _PlaystoryState();
}

class _PlaystoryState extends State<Playstory> {
  double changevoice = 0.0;
  double changelimit = 0.0;

  String name = "PlayStory";
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
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              //hier damit ich nicht leer lasse
              return const LoginPage();
            })));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) {
                  //hier damit ich nicht leer lasse
                  return const LoginPage();
                })));
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
                        backgroundImage: const AssetImage("assert/logo.png"),
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
                                  onPressed: () {
                                    //     Navigator.of(context).push(
                                    //         MaterialPageRoute(builder: (context) {
                                    //       return;
                                    //    }));
                                  },
                                  icon: const Icon(Icons.forward_10_outlined),
                                )),
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {
                                    //   Navigator.of(context).push(
                                    //      MaterialPageRoute(builder: (context) {
                                    //    return;
                                    //  }));
                                  },
                                  icon:
                                      const Icon(Icons.skip_previous_outlined),
                                )),
                            Expanded(
                                flex: 2,
                                child: IconButton(
                                  onPressed: () {
                                    //  Navigator.of(context).push(
                                    //      MaterialPageRoute(builder: (context) {
                                    //    return;
                                    //  }));
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                    onPressed: () {
                                      //     Navigator.of(context).push(
                                      //         MaterialPageRoute(builder: (context) {
                                      //       return;
                                      //    }));
                                    },
                                    icon:
                                        const Icon(Icons.skip_next_outlined))),
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {
                                    //  Navigator.of(context).push(
                                    //     MaterialPageRoute(builder: (context) {
                                    //   return;
                                    //  }));
                                  },
                                  icon: const Icon(Icons.replay_10),
                                )),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Slider(
                            min: 0,
                            max: 10,
                            value: changelimit,
                            onChanged: (ch) {
                              setState(() {
                                changelimit = ch;
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
                                onPressed: () {
                                  //  Navigator.of(context)
                                  //      .push(MaterialPageRoute(builder: (context) {
                                  //     return;
                                  //    }));
                                },
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
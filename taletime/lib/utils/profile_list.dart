import 'package:flutter/material.dart';
import 'package:taletime/utils/profile_column_widget.dart';

import '../Screens/home.dart';

class ProfileList extends StatelessWidget {
  final profile;

  const ProfileList(this.profile);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 120,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home()));
        },
        child: SizedBox(
          height: 120,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 120,
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  itemExtent: 106.0,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.transparent,
                              ),
                              child: Image.asset(profile["image"]),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    profile["name"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0)),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.linear_scale,
                                        color: Colors.teal.shade600,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        profile["title"],
                                        style: const TextStyle(
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 7),
                            child: ProfileColumn().myColumn(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

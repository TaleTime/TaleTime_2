import 'package:flutter/material.dart';
import 'package:taletime/utils/navbar_widget_speaker.dart';
import 'package:taletime/utils/profile_column_widget.dart';

import 'navbar_widget.dart';

class ProfileList extends StatelessWidget {
  final profile;
  final profiles;

  const ProfileList(this.profile, this.profiles);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await Navigator.push(
              //context, MaterialPageRoute(builder: (context) => NavBarListener(profile, profiles)));
              context, MaterialPageRoute(builder: (context) => NavBarSpeaker(profile, profiles)));
        },
        child: Column(
            children: <Widget>[
              Container(
                height: 120,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      margin: EdgeInsets.only(bottom: 9),
                      padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: Colors.transparent,
                      ),
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
                              child: Image.network(profile["image"]),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
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
                                        //style: const TextStyle(
                                        //    color: Colors.black),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 7),
                            child: ProfileColumn(profile, profiles),
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
  }
}

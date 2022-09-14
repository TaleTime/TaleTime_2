import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/listfavorite.dart';

import '../utils/my_list_view.dart';

class FavoritePage extends StatefulWidget {
  final profile;

  const FavoritePage(this.profile, {Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState(this.profile);
}

class _FavoritePageState extends State<FavoritePage> {
  final profile;

  _FavoritePageState(this.profile);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 10,
              left: 8,
              right: 16,
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  "Favorites",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
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
                    child: MyListView(profile["favorites"]),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

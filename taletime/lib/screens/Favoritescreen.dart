import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/listfavorite.dart';

class screenfavorite extends StatefulWidget {
  const screenfavorite({Key? key}) : super(key: key);

  @override
  State<screenfavorite> createState() => _screenfavoriteState();
}

class _screenfavoriteState extends State<screenfavorite> {
  TextStyle textStyle = TextStyle(fontSize: 20, color: kPrimaryColor);
  Icon icondelete = Icon(Icons.delete);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite"),
      ),
      body: Column(
        children: [
          Consumer<listfavorite>(builder: ((context, value, child) {
            return Card(
              child: Container(
                color: Colors.grey[120],
                child: ListView.builder(
                    itemCount: value.storys.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: Text("${value.storys[i].image}"),
                        title: Text("${value.storys[i].title}"),
                        subtitle: Text("${value.storys[i].name}"),
                        trailing: IconButton(
                          onPressed: () {
                            value.removeStory(value.storys[i]);
                          },
                          icon: icondelete,
                        ),
                      );
                    }),
              ),
            );
          }))
        ],
      ),
    );
  }
}

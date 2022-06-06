import 'package:flutter/material.dart';
import 'package:taletime/screens/account.dart';
import 'package:taletime/utils/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    int _counter = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: MaterialButton(
            onPressed: () {},
            color: Colors.green[200],
            onLongPress: () {},
            elevation: 10,
            splashColor: Colors.black,
            child: Row(
              children: const [
                Icon(Icons.menu),
              ],
            )),
        title: const Center(
          child: Text(
            "Home",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => const Account())));
              },
              color: Colors.green[200],
              child: Row(
                children: const [Icon(Icons.person)],
              ))
        ],
      ),
      body: Column(
        children: const [],
      ),
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.green[150],
        child: Row(
          children: [
            Expanded(
                child: MaterialButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.play_circle),
                  Text(
                    ' jetzt hören',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              color: Colors.grey[150],
              elevation: 12,
              splashColor: Colors.blue[300],
            )),
            Expanded(
                child: MaterialButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.favorite),
                  Text(
                    ' Favoriten',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              color: Colors.grey[150],
              elevation: 12,
              splashColor: Colors.blue[300],
            )),
            Expanded(
                child: MaterialButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.search),
                  Text(
                    'Suchen',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              color: Colors.grey[150],
              elevation: 12,
              splashColor: Colors.blue[300],
            )),
          ],
        ),
      ),
    );
  }
}
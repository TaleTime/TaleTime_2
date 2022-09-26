import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController editingController = TextEditingController();
  TextEditingController editingController1 = TextEditingController();
  TextStyle textStyle = const TextStyle(fontSize: 18, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "ChangePassword",
          style: textStyle,
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              //   controller: ,
              decoration: InputDecoration(
                  label: Text("Gebe altes Password ein"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              //   controller: ,
              decoration: InputDecoration(
                  label: Text("Gebe das neue Password ein"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              //   controller: ,
              decoration: InputDecoration(
                  label: Text("Bestätige das Password nochmal "),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0))),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: MaterialButton(
              onPressed: () {},
              color: kPrimaryColor,
              child: const Text("Password ändern "),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileColumn{

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:

        break;
      case 1:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Remove profile...", style: TextStyle(color: Colors.teal.shade600),),
                content: const Text("Do you really want to delete this profile?"),
                actions: [
                  TextButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal.shade600)),
                    onPressed: () {
                      /*cards.removeLast();
                      setState(() {});*/
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal.shade600)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
        break;
    }
  }


  Column myColumn(BuildContext context){
    return Column(
      children: <Widget>[
        Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: Colors.teal.shade600),
            textTheme: const TextTheme().apply(bodyColor: Colors.white),
          ),
          child: PopupMenuButton<int>(
            color: Colors.white,
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.teal.shade600,),
                    const SizedBox(width: 8),
                    const Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.teal.shade600,),
                    const SizedBox(width: 8),
                    const Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }


}
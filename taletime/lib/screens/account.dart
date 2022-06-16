import 'package:firebase_auth/firebase_auth.dart';
import 'package:taletime/screens/profiles_page.dart';
import 'package:taletime/screens/welcome.dart';
import 'package:taletime/utils/constants.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? username = user?.displayName;
    String? email = user?.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Center(
          child: Text("Account"),
        ),
        //scrolledUnderElevation: 12,
        elevation: 12,
        shadowColor: Colors.grey[200],
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {},
            child: const Text('fertig'),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 75,
            color: Colors.grey[300],
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 4,
                  child: ListTile(
                    title: Text('$username, $email'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              height: 300,
              color: Colors.grey[300],
              child: Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.grey[250],
                        child: const Text("Abos verwalten"),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.grey[250],
                        child: const Text("Karte oder Code einlösen"),
                      )
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        child: const Text("Karte per Email senden "),
                        color: Colors.grey[250],
                      )
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        child: const Text("Guthaben zu Apple-ID hinzufügen "),
                        color: Colors.grey[250],
                      )
                    ],
                  )),
                ],
              )),
          const SizedBox(height: 15),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.grey[250],
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () {},
                  child: const Text(
                    "Mitteilung ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.grey[250],
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilesPage()));
                  },
                  child: const Text(
                    "Profil wechseln ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.grey[250],
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const WelcomePage()));
                  },
                  child: const Text(
                    "Abmelden ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container(color: Colors.grey[300]))
        ],
      ),
    );
  }
}

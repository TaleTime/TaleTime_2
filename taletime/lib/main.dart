import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/Screens/login.dart';
import 'package:taletime/Screens/signup.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TaleTimeApp(),
  ));
}

class TaleTimeApp extends StatelessWidget {
  const TaleTimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text(
                    "Willkommen bei TaleTime",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Das cloudfähige, geschichtenerzählende Vorlesetool für Spaß mit der ganzen Familie",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("assets/icon.png"))),
              ),
              Column(
                children: <Widget>[
                  // Login Button
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Anmelden",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  // Signup Button
                  const SizedBox(height: 20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()));
                    },
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Registrieren",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
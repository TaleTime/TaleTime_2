import 'package:flutter/material.dart';
import 'package:taletime/Screens/home.dart';
import 'package:taletime/screens/login.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/widgets/input_widget.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(children: <Widget>[
                SafeArea(
                    child: Column(children: [
                  const Text(
                    "Registrierung",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 100),
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icon.png"),
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Erstellen Sie ein kostenloses Konto",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]))
                ]))
              ]),
              Column(
                children: <Widget>[
                  //Textfelder für die Eingabe der Daten
                  SafeArea(
                      child: Column(
                    children: [
                      Container(
                          child: TextField(
                              decoration: Input().textInputDecoration(
                                  "Benutzername",
                                  "Geben Sie Ihren Benutzernamen ein",
                                  Icon(Icons.person, color: kPrimaryColor))),
                          decoration: Input().inputBoxDecorationShaddow()),
                      const SizedBox(height: 25),
                      Container(
                          child: TextField(
                              decoration: Input().textInputDecoration(
                                  "Email",
                                  "Geben Sie Ihre Email-Adresse ein",
                                  Icon(Icons.email_rounded,
                                      color: kPrimaryColor))),
                          decoration: Input().inputBoxDecorationShaddow()),
                      const SizedBox(height: 25),
                      Container(
                          child: TextField(
                              decoration: Input().textInputDecoration(
                                  "Passwort",
                                  "Geben Sie Ihr Passwort ein",
                                  Icon(Icons.lock, color: kPrimaryColor))),
                          decoration: Input().inputBoxDecorationShaddow()),
                      const SizedBox(height: 25),
                      Container(
                          child: TextField(
                              decoration: Input().textInputDecoration(
                                  "Passwort bestätigen",
                                  "Bestätigen Sie Ihr Passwort",
                                  Icon(Icons.lock, color: kPrimaryColor))),
                          decoration: Input().inputBoxDecorationShaddow())
                    ],
                  ))
                ],
              ),
              //Button für die Registrierung
              Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
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
                  )),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Sie haben bereits ein Konto?"),
                  TextButton(
                      child: Text('Anmelden',
                          style: TextStyle(color: kPrimaryColor)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

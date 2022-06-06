import 'package:flutter/material.dart';
import 'package:taletime/screens/home.dart';
import 'package:taletime/screens/signup.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/widgets/input_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text(
                      "Anmeldung",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Anmeldung zu Ihrem Konto",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      inputText(label: "Email", icon: const Icon(Icons.email)),
                      inputText(
                          label: "Passwort",
                          icon: const Icon(Icons.lock),
                          obscureText: true)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
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
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Anmelden",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Sie haben noch kein Konto?"),
                    TextButton(
                        child: const Text('Registrieren'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()));
                        }),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 100),
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/icon.png"),
                        fit: BoxFit.fitHeight),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

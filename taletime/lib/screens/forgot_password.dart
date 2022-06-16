import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/login.dart';
import 'package:taletime/utils/authentification_util.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(25, 150, 25, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'Passwort vergessen?',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Geben Sie die mit Ihrem Konto verbundene Email-Adresse ein.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Wir senden Ihnen einen Verifizierungscode, um Ihre Identität zu überprüfen.',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                  decoration: Decorations().textInputDecoration(
                                      "Email-Adresse",
                                      "Geben Sie Ihre Email-Adresse ein",
                                      Icon(Icons.email_rounded,
                                          color: kPrimaryColor)),
                                  validator: (email) => AuthentificationUtil()
                                      .validateEmail(email)),
                              decoration:
                                  Decorations().inputBoxDecorationShaddow(),
                            ),
                            const SizedBox(height: 40.0),
                            Container(
                              decoration:
                                  Decorations().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: Decorations().buttonStyle(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Code senden".toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()));
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                      text: "Wissen Sie Ihr Passwort? "),
                                  TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()),
                                        );
                                      },
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

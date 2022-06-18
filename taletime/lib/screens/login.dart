import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/screens/profiles_page.dart';
import 'package:taletime/utils/authentification_util.dart';
import 'package:taletime/screens/forgot_password.dart';
import 'package:taletime/screens/signup.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar:
          Decorations().appBarDecoration(title: "Anmeldung", context: context),
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
                      "Anmeldung zu Ihrem Konto",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 100),
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/logo.png"),
                            fit: BoxFit.fitHeight),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            Container(
                                child: TextFormField(
                                    controller: _emailController,
                                    decoration: Decorations()
                                        .textInputDecoration(
                                            "Email-Adresse",
                                            "Geben Sie Ihre Email-Adresse ein",
                                            Icon(Icons.mail,
                                                color: kPrimaryColor)),
                                    validator: (email) => AuthentificationUtil()
                                        .validateEmail(email)),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: Decorations().textInputDecoration(
                                    "Passwort",
                                    "Geben Sie Ihr Passwort ein",
                                    Icon(Icons.lock, color: kPrimaryColor),
                                  ),
                                  validator: (password) =>
                                      AuthentificationUtil()
                                          .validatePassword(password)),
                              decoration:
                                  Decorations().inputBoxDecorationShaddow(),
                            ),
                            const SizedBox(height: 15.0),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                              alignment: Alignment.topRight,
                              child: TextButton(
                                  child: Text('Passwort vergessen?',
                                      style: TextStyle(color: kPrimaryColor)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPasswordPage()));
                                  }),
                            ),
                          ])),
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
                      onPressed: () async {
                        // Funktion für Login mit Firebase
                        final isValidForm = _formKey.currentState!.validate();

                        if (isValidForm) {
                          try {
                            User? user = await AuthentificationUtil()
                                .loginUsingEmailPassword(
                                    email: _emailController.text
                                        .trim()
                                        .toLowerCase(),
                                    password: _passwordController.text.trim(),
                                    context: context);
                            if (user != null) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfilesPage()));
                            }
                          } on FirebaseAuthException catch (e) {
                            final SnackBar snackBar =
                                AuthentificationUtil().showLoginError(e);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
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
                        child: Text('Registrieren',
                            style: TextStyle(color: kPrimaryColor)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()));
                        }),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

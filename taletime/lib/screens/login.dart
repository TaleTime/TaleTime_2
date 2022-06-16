import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/utils/authentification_util.dart';
import 'package:taletime/screens/forgot_password.dart';
import 'package:taletime/screens/home.dart';
import 'package:taletime/screens/signup.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            Container(
                                child: TextFormField(
                                    controller: emailController,
                                    decoration: Input().textInputDecoration(
                                        "Email-Adresse",
                                        "Geben Sie Ihre Email-Adresse ein",
                                        Icon(Icons.mail, color: kPrimaryColor)),
                                    validator: (email) => //email != null &&
                                        //!EmailValidator.validate(email)
                                        // ? 'Geben Sie eine gültige Email-Adresse ein'
                                        //: null),
                                        AuthentificationUtil()
                                            .validateEmail(email)),
                                decoration:
                                    Input().inputBoxDecorationShaddow()),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: Input().textInputDecoration(
                                    "Passwort",
                                    "Geben Sie Ihr Passwort ein",
                                    Icon(Icons.lock, color: kPrimaryColor),
                                  ),
                                  validator: (password) =>
                                      AuthentificationUtil()
                                          .validatePassword(password)),
                              decoration: Input().inputBoxDecorationShaddow(),
                            ),
                            const SizedBox(height: 15.0),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordPage()));
                                },
                                child: Text(
                                  "Passwort vergessen?",
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                              ),
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
                                    email: emailController.text
                                        .trim()
                                        .toLowerCase(),
                                    password: passwordController.text.trim(),
                                    context: context);
                            if (user != null) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const Home()));
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

  /** 
  Future signIn() async {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    //if (FirebaseAuth.
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }

    //Navigator.pop(context);
    //navigatorKey.currentState!.popUntil((route) => route.isFirst);
    //Navigator.pushReplacementNamed(context, "home");
    */
  // }
}

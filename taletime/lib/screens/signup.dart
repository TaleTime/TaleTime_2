import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/Screens/home.dart';
import 'package:taletime/utils/authentification_util.dart';
import 'package:taletime/screens/login.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            Container(
                                child: TextFormField(
                                    controller: _nameController,
                                    decoration: Input().textInputDecoration(
                                        "Benutzername",
                                        "Geben Sie Ihren Benutzernamen ein",
                                        Icon(Icons.person,
                                            color: kPrimaryColor)),
                                    validator: (name) => AuthentificationUtil()
                                        .validateUserName(name)),
                                decoration:
                                    Input().inputBoxDecorationShaddow()),
                            const SizedBox(height: 25),
                            Container(
                                child: TextFormField(
                                    controller: _emailController,
                                    decoration: Input().textInputDecoration(
                                        "Email",
                                        "Geben Sie Ihre Email-Adresse ein",
                                        Icon(Icons.email_rounded,
                                            color: kPrimaryColor)),
                                    validator: (email) => AuthentificationUtil()
                                        .validateEmail(email)),
                                decoration:
                                    Input().inputBoxDecorationShaddow()),
                            const SizedBox(height: 25),
                            Container(
                                child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: Input().textInputDecoration(
                                        "Passwort",
                                        "Geben Sie Ihr Passwort ein",
                                        Icon(Icons.lock, color: kPrimaryColor)),
                                    validator: (password) =>
                                        AuthentificationUtil()
                                            .validatePassword(password)),
                                decoration:
                                    Input().inputBoxDecorationShaddow()),
                            const SizedBox(height: 25),
                            Container(
                                child: TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: true,
                                    decoration: Input().textInputDecoration(
                                        "Passwort bestätigen",
                                        "Bestätigen Sie Ihr Passwort",
                                        Icon(Icons.lock, color: kPrimaryColor)),
                                    validator: (password) {
                                      if (_passwordController.text.trim() !=
                                          password) {
                                        return 'Die Passwörter stimmen nicht überein';
                                      } else {
                                        AuthentificationUtil()
                                            .validatePassword(password);
                                      }
                                      return null;
                                    }),
                                decoration: Input().inputBoxDecorationShaddow())
                          ]))
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
                    onPressed: () async {
                      final isValidForm = _formKey.currentState!.validate();
                      if (isValidForm) {
                        try {
                          User? user = await AuthentificationUtil()
                              .registerWithEmailPassword(
                                  userName: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  context: context);
                          if (user != null) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Home()));
                          }
                        } on FirebaseAuthException catch (e) {
                          final SnackBar snackBar =
                                AuthentificationUtil().showRegisterError(e);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                        }
                      }
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

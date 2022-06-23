import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/utils/authentification_util.dart';
import 'package:taletime/screens/login.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taletime/utils/validation_util.dart';

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
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //backgroundColor: Colors.white,
      appBar: Decorations().appBarDecoration(
          title: AppLocalizations.of(context)!.register, context: context),
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
                  Text(
                    AppLocalizations.of(context)!.createAccount,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 5,
                    child: Image.network(assetLogo),
                  ),
                  const SizedBox(height: 20),
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
                                    decoration: Decorations()
                                        .textInputDecoration(
                                            AppLocalizations.of(context)!
                                                .username,
                                            AppLocalizations.of(context)!
                                                .enterUsername,
                                            Icon(Icons.person)),
                                                //color: kPrimaryColor)),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (name) => ValidationUtil()
                                        .validateUserName(name, context)),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(height: 25),
                            Container(
                                child: TextFormField(
                                    controller: _emailController,
                                    decoration: Decorations()
                                        .textInputDecoration(
                                            AppLocalizations.of(context)!.email,
                                            AppLocalizations.of(context)!
                                                .enterEmail,
                                            Icon(Icons.email_rounded)),
                                                //color: kPrimaryColor)),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (email) => ValidationUtil()
                                        .validateEmail(email, context)),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(height: 20),
                            Container(
                                child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: Decorations()
                                        .textInputDecoration(
                                            AppLocalizations.of(context)!
                                                .password,
                                            AppLocalizations.of(context)!
                                                .enterPassword,
                                            Icon(Icons.lock)),
                                                //color: kPrimaryColor)),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (password) => ValidationUtil()
                                        .validatePassword(password, context)),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow()),
                            const SizedBox(height: 25),
                            Container(
                                height: MediaQuery.of(context).size.height / 13,
                                child: TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: true,
                                    decoration: Decorations()
                                        .textInputDecoration(
                                            AppLocalizations.of(context)!
                                                .confirmPassword,
                                            AppLocalizations.of(context)!
                                                .confirmYourPassword,
                                            Icon(Icons.lock,
                                                color: kPrimaryColor)),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (password) {
                                      if (_passwordController.text.trim() !=
                                          password) {
                                        return AppLocalizations.of(context)!
                                            .passwordsDontMatch;
                                      } else {
                                        ValidationUtil().validatePassword(
                                            password, context);
                                      }
                                      return null;
                                    }),
                                decoration:
                                    Decorations().inputBoxDecorationShaddow())
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
                      final String _userName = _nameController.text;
                      final String _email =
                          _emailController.text.trim().toLowerCase();
                      final String _password = _passwordController.text.trim();
                      final isValidForm = _formKey.currentState!.validate();
                      if (isValidForm) {
                        AuthentificationUtil(auth: auth)
                            .registerWithEmailAndPassword(
                                userName: _userName,
                                email: _email,
                                password: _password,
                                context: context);
                      }
                    },
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      AppLocalizations.of(context)!.registerVerb,
                      style: const TextStyle(
                          //color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.alreadyHaveAccount),
                  TextButton(
                      child: Text(AppLocalizations.of(context)!.loginVerb,
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

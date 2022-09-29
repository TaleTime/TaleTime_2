import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taletime/utils/authentification_util.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:taletime/utils/text_form_field_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController editingController = TextEditingController();
  TextEditingController editingController1 = TextEditingController();

  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Decorations().appBarDecoration(
          title: AppLocalizations.of(context)!.changePassword,
          context: context,
          automaticArrow: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormFieldUtil().enterOldPasswordForm(
                          context, _oldPasswordController),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormFieldUtil()
                            .enterPasswordForm(context, _passwordController)),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormFieldUtil().confirmPasswordForm(context,
                            _passwordController, _confirmPasswordController)),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 13,
                        width: MediaQuery.of(context).size.width / 2,
                        child: ElevatedButton(
                          onPressed: () {
                            final isValidForm =
                                _formKey.currentState!.validate();
                            if (isValidForm) {
                              AuthentificationUtil(auth: auth).changePassword(
                                  context,
                                  _oldPasswordController.text.trim(),
                                  _passwordController.text.trim());
                            }
                          },
                          child: Text(
                              AppLocalizations.of(context)!.changePassword),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

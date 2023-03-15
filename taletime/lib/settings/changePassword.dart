///The class takes the old password and the new password and confirmed password from the user.
///The old password is compared with the password stored in the database.If the two match, the new password will be accepted.

///   At the end the act is confirmed with a button

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:taletime/common%20utils/constants.dart";
import "package:taletime/login%20and%20registration/utils/authentification_util.dart";
import "package:taletime/common%20utils/decoration_util.dart";
import "package:taletime/common%20utils/text_form_field_util.dart";
import "../internationalization/localizations_ext.dart";

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
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),

                      /// Enter old password
                      child:
                          TextFormFieldUtil().enterOldPasswordForm(context, _oldPasswordController),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),

                        ///Enter new password
                        child: TextFormFieldUtil().enterPasswordForm(context, _passwordController)),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(

                        /// enter the confirm the password and one compares between the new and confirmed
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormFieldUtil().confirmPasswordForm(
                            context, _passwordController, _confirmPasswordController)),
                    const SizedBox(
                      height: 25,
                    ),

                    /// When you press the button, the old password is exchanged with the new password in the database.
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 13,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: elevatedButtonDefaultStyle(),
                          onPressed: () {
                            final isValidForm = _formKey.currentState!.validate();
                            if (isValidForm) {
                              AuthentificationUtil(auth: auth).changePassword(
                                  context,
                                  _oldPasswordController.text.trim(),
                                  _passwordController.text.trim());
                            }
                          },

                          ///the password has been changed
                          child: Text(AppLocalizations.of(context)!.changePassword),
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

import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  Function changeToSignUp;
  Function submitAuthForm;
  SignInForm(this.changeToSignUp, this.submitAuthForm);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formkey = GlobalKey<FormState>();
  String user_email = '';
  String user_pass = '';

  void _trySubmit() {
    final isValid = _formkey.currentState!.validate();

    FocusScope.of(context).unfocus();
    if (isValid) {
      _formkey.currentState!.save();
      widget.submitAuthForm(user_email,'',user_pass, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formkey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                width: 300,
                child: TextFormField(
                  validator: (value) {
                    print("value is : $value");
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  onSaved: (newValue) {
                    user_email = newValue!;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                width: 300,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return 'Enter valid password containing atleast 8 characters';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  autofocus: false,
                  onSaved: (newValue) {
                    user_pass = newValue!;
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
          onPressed: () {
            _trySubmit();
          },
          child: const Text(
            "Submit",
            style: Constants.body1,
          ),
          style:
              ElevatedButton.styleFrom(primary: Constants.secondaryThemeColor),
        ),
        TextButton(
          onPressed: () {
            widget.changeToSignUp();
          },
          child: const Text(
            "Don't have an account? SignUp!",
            style: Constants.subtitle,
          ),
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith(
                (states) => Constants.secondaryThemeColor),
          ),
        )
      ],
    ));
  }
}

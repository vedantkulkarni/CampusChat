import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  Function changeToSignIn;
  Function submitAuthForm;
  bool isLoading;
  SignUpForm(this.changeToSignIn, this.submitAuthForm,this.isLoading);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpForm> {
  final _signUpKey = GlobalKey<FormState>();
  String user_email = '';
  String user_pass = '';
  String user_name = '';

  void _trySubmit() {
    final isValid = _signUpKey.currentState!.validate();

    FocusScope.of(context).unfocus();
    if (isValid) {
      _signUpKey.currentState!.save();
      widget.submitAuthForm(user_email, user_name, user_pass, false, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _signUpKey,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                width: 300,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Username should be atleast 4 characters.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  onSaved: (newValue) {
                    user_name = newValue!;
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
        (widget.isLoading)?CircularProgressIndicator(color: Colors.white,):
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
        (widget.isLoading)?Container():TextButton(
          onPressed: () {
            widget.changeToSignIn();
          },
          child: const Text(
            "Go back to SignIn",
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

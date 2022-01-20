import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInForm extends StatefulWidget {
  Function changeToSignUp;
  Function submitAuthForm;
  bool isLoading;
  SignInForm(this.changeToSignUp, this.submitAuthForm, this.isLoading);

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
      widget.submitAuthForm(user_email, '', user_pass, true, context);
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
                  child: Consumer(
                    builder: (_, ref, __) {
                      final showPass = ref.watch(userDataProvider);
                      return TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value.length < 8) {
                            return 'Enter valid password containing atleast 8 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPass.toggleVisIcon();
                                });

                              },
                              icon: showPass.vis?const Icon(Icons.visibility,color: Constants.secondaryThemeColor,): const Icon(Icons.visibility_off,color: Colors.grey,)),
                          border: const OutlineInputBorder(),
                          hintText: 'Password',
                        ),
                        obscureText: !showPass.vis,
                        autofocus: false,
                        onSaved: (newValue) {
                          user_pass = newValue!;
                        },
                      );
                    },
                  )),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        (widget.isLoading)
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : ElevatedButton(
                onPressed: () {
                  _trySubmit();
                },
                child: const Text(
                  "Submit",
                  style: Constants.body1,
                ),
                style: ElevatedButton.styleFrom(
                    primary: Constants.secondaryThemeColor),
              ),
        (widget.isLoading)
            ? Container()
            : TextButton(
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

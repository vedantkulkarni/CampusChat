import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpForm extends StatefulWidget {
  Function changeToSignIn;
  Function submitAuthForm;
  bool isLoading;

  SignUpForm(this.changeToSignIn, this.submitAuthForm, this.isLoading);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpForm> {
  final _signUpKey = GlobalKey<FormState>();
  String misId = '';
  String user_pass = '';
  String user_name = '';
  
  late TextEditingController tctr;
  late TextEditingController tctr2;

  void _trySubmit() {
    final isValid = _signUpKey.currentState!.validate();

    FocusScope.of(context).unfocus();
    if (isValid) {
      _signUpKey.currentState!.save();
      widget.submitAuthForm(misId, user_name, user_pass, false, context,
          );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    tctr = new TextEditingController();
    tctr2 = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tctr.dispose();
    tctr2.dispose();
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
                    if (value!.isEmpty || value.contains('@')) {
                      return 'Just enrollment number is fine!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'MIS Portal LoginId',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  onSaved: (newValue) {
                    misId = newValue!;
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
                  child: Consumer(builder: (_, ref, __) {
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
                            icon: showPass.vis
                                ? const Icon(
                                    Icons.visibility,
                                    color: Constants.secondaryThemeColor,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: Colors.grey,
                                  )),
                        border: OutlineInputBorder(),
                        hintText: 'MIS Portal Password',
                      ),
                      obscureText: !showPass.vis,
                      autofocus: false,
                      onSaved: (newValue) {
                        user_pass = newValue!;
                      },
                    );
                  })),
              const SizedBox(
                height: 10,
              ),
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

import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/widgets/signup.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late LottieBuilder myLottie;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myLottie = Lottie.asset('assets/images/auth_lottie.json');
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.themeColor,
        body: SingleChildScrollView(
          child: Container(
            height: h,
            width: w,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                      child: Text("Welcome!", style: Constants.headline)),
                  const SizedBox(height: 5),
                  const Center(
                      child: Text(
                    "To continue using the app,\n please sign in first.",
                    style: Constants.body1,
                    textAlign: TextAlign.center,
                  )),
                  Center(
                    child: myLottie,
                  ),
                  const SignUpForm(),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Submit",
                      style: Constants.body1,
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Constants.secondaryThemeColor),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Don't have an account? SignUp!",
                      style: Constants.subtitle,
                    ),
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Constants.secondaryThemeColor),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

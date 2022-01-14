import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/widgets/signin.dart';
import 'package:chat_app/widgets/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late LottieBuilder myLottie;
  bool isSignUpMode = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myLottie = Lottie.asset('assets/images/auth_lottie.json');
  }

  void changeAuthState() {
    setState(() {
      isSignUpMode = !isSignUpMode;
    });
  }

  void _submitAuthForm(
      String email, String name, String password, bool isSignIn) async {
    final authresult;
    try {
      if (isSignIn) {
        authresult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authresult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
    } on PlatformException catch (e) {
      var message = 'Please check your credentials!';
      if (e.message != null) {
        message = e.message.toString();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (err) {
      print(err);
    }
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
                  (isSignUpMode)
                      ? Center(
                          child: SignUpForm(changeAuthState, _submitAuthForm),
                        )
                      : Column(
                          children: [
                            Center(
                              child: myLottie,
                            ),
                            SignInForm(changeAuthState, _submitAuthForm),
                          ],
                        ),
                ]),
          ),
        ),
      ),
    );
  }
}

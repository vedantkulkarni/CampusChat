import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/widgets/signin.dart';
import 'package:chat_app/widgets/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireInstance = FirebaseFirestore.instance;
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

  void _submitAuthForm(String email, String name, String password,
      bool isSignIn, BuildContext ctx) async {
    final authresult;
    email = email.trim();
    name = name.trim();
    password = password.trim();
    setState(() {
      isLoading = true;
    });
    try {
      if (isSignIn) {
        authresult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(ctx)
            .showSnackBar(const SnackBar(content: Text('Login Successfull!')));
        
      } else {
        authresult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text('User created successfully'),
          backgroundColor: Colors.green,
        ));
        fireInstance
            .collection('Users')
            .doc(authresult.user.uid)
            .set({'username': name, 'email': email});
      }
    } on PlatformException catch (e) {
      setState(() {
        isLoading = false;
      });
      var message = 'Please check your credentials!';
      if (e.message != null) {
        message = e.message.toString();
      }

      message = message.replaceRange(
          message.indexOf('['), message.lastIndexOf(']') + 1, 'Error: ');
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      String myerr = err.toString();
      myerr = myerr.replaceRange(
          myerr.indexOf('['), myerr.lastIndexOf(']') + 1, 'Error: ');
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(myerr),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
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
                          child: SignUpForm(
                              changeAuthState, _submitAuthForm, isLoading),
                        )
                      : Column(
                          children: [
                            Center(
                              child: myLottie,
                            ),
                            SignInForm(
                                changeAuthState, _submitAuthForm, isLoading),
                          ],
                        ),
                ]),
          ),
        ),
      ),
    );
  }
}

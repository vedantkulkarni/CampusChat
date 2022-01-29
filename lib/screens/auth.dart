import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/db_helper.dart';
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

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late LottieBuilder myLottie;
  bool isSignUpMode = false;
  bool isLoading = false;
  late final AnimationController animationController;
  late final Animation animation;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myLottie = Lottie.asset('assets/images/auth_lottie.json');
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void changeAuthState() async {
    await animationController.reverse(from: 0.25);
    setState(() {
      isSignUpMode = !isSignUpMode;
    });
    await animationController.forward();
  }

  void _submitAuthForm(
    String misId,
    String name,
    String password,
    bool isSignIn,
    BuildContext ctx,
  ) async {
    final authresult;
    misId = misId.trim().toUpperCase();
    name = name.trim();
    password = password.trim();
    final String email = '$misId@gmail.com';
    setState(() {
      isLoading = true;
    });
    try {
      if (isSignIn) {
        authresult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        await DBHelper.insert(misId, password);
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text('Login Successfull!'),
          backgroundColor: Colors.green,
        ));
        setState(() {
          isLoading = false;
        });
      } else {
        authresult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text('User created successfully'),
          backgroundColor: Colors.green,
        ));
        
        await fireInstance
            .collection(Constants.userPath)
            .doc(authresult.user.uid)
            .set({
          'username': name,
          'email': email,
          'loginId': misId,
        });
        await DBHelper.insert(misId, password);
      }
    } on PlatformException catch (e) {
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
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      String myerr = err.toString();

      if (mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(myerr),
          backgroundColor: Theme.of(ctx).errorColor,
        ));
        setState(() {
          isLoading = false;
        });
      }
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
          child: FadeTransition(
            opacity: animationController,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                        child: Text("Welcome!", style: Constants.headline)),
                    const SizedBox(height: 5),
                    Center(
                        child: Text(
                      "To continue using the app,\n please ${isSignUpMode ? 'SignUp' : 'SignIn'} first.",
                      style: Constants.body1,
                      textAlign: TextAlign.center,
                    )),
                    (isSignUpMode)
                        ? Container(
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
      ),
    );
  }
}

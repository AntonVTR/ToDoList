import 'package:flutter/material.dart';
import 'package:todo/screens/authenticate/register.dart';
import 'package:todo/screens/authenticate/sign_in.dart';

class Autheticate extends StatefulWidget {
  @override
  _AutheticateState createState() => _AutheticateState();
}

class _AutheticateState extends State<Autheticate> {
  bool showSignIn = false;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn ? SingIn(toggleView) : Register(toggleView);
  }
}

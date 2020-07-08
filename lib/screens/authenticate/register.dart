import 'package:flutter/material.dart';
import 'package:todo/services/auth.dart';
import 'package:todo/shared/constants.dart';
import 'package:todo/shared/loading.dart';
import 'package:todo/shared/password_form_field.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register(this.toggleView);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final TextEditingController _passwordController = TextEditingController();

  //text field state
  String email, password, error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: c[100],
            appBar: AppBar(
              backgroundColor: c[400],
              elevation: 0.0,
              title: Text('Sign up to app', key: Key('titleSignIn')),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    key: Key('lableSignIn'),
                    label: Text(
                      'Sign in',
                      style: TextStyle(color: cText),
                    ))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        key: Key('textFormEmail'),
                        onChanged: (val) {
                          setState(() => email = val.trim());
                        },
                      ),
                      SizedBox(height: 20),
                      PasswordFormField(
                        controller: _passwordController,
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                        onPressed: () async {
                          _validateAndSubmit(context);
                        },
                        color: cButton[400],
                        key: Key('buttonSubmit'),
                        child: Text(
                          'Register',
                          style: TextStyle(color: cText),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        error,
                        style: TextStyle(color: cError, fontSize: 14),
                      )
                    ],
                  )),
            ),
          );
  }

  Future<void> _validateAndSubmit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      password = _passwordController.text.trim();
      _passwordController.text = "";
      dynamic result =
          await _auth.registerWithEmailAndPassword(email, password);
      if (result == null) {
        setState(() {
          loading = false;
          error = 'could not register with those credentials';
        });
      }
    }
  }
}

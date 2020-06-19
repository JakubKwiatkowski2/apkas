import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'package:flutter/material.dart';
import'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  GoogleSignIn googleAuth = new GoogleSignIn();

  final formKey = new GlobalKey<FormState>();

  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

    String validateEmail(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
    }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    print("signed in " + user.displayName);
    return user;
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: Center(
              child: Container(
                  height: 250.0,
                  width: 300.0,
                  child: Column(
                    children: <Widget>[
                      Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0,
                                      right: 25.0,
                                      top: 0.0,
                                      bottom: 5.0),
                                  child: Container(
                                    height: 50.0,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius
                                              .circular(10.0)),
                                      color: Color(0xffffffff),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          SizedBox(width: 5.0),
                                          Text(
                                            'Sign in with Google',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0),
                                          ),
                                        ],),
                                      onPressed: () {  _handleSignIn()
                                          .then((FirebaseUser user) => print(user))
                                          .catchError((e) => print(e));

                                      },
                                    ),


                                  )),

                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0,
                                      right: 25.0,
                                      top: 20.0,
                                      bottom: 5.0),
                                  child: Container(
                                    height: 50.0,
                                    child: TextFormField(
                                      decoration:
                                      InputDecoration(hintText: 'Email'),
                                      validator: (value) =>
                                      value.isEmpty
                                          ? 'Email is required'
                                          : validateEmail(value.trim()),
                                      onChanged: (value) {
                                        this.email = value;
                                      },
                                    ),
                                  )),

                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0,
                                      right: 25.0,
                                      top: 20.0,
                                      bottom: 5.0),
                                  child: Container(
                                    height: 50.0,
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration:
                                      InputDecoration(hintText: 'Password'),
                                      validator: (value) =>
                                      value.isEmpty
                                          ? 'Password is required'
                                          : null,
                                      onChanged: (value) {
                                        this.password = value;
                                      },
                                    ),
                                  )),
                              InkWell(
                                  onTap: () {
                                    if (checkFields()) {
                                      AuthService().signIn(email, password);
                                    }
                                  },
                                  child: Container(
                                      height: 40.0,
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                      ),
                                      child: Center(child: Text('Sign in')))),


                            ],
                          ))
                    ],
                  ))));
    }
  }
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../RoundedButton.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool show = false;
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;

  login() async {}

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: show,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  style: const TextStyle(color: Colors.black87),
                  decoration:
                      kInputDecoration.copyWith(hintText: 'Enter your Email'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  obscuringCharacter: '*',
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  style: const TextStyle(color: Colors.black87),
                  //note WE CAN CHANGE ONE OR TWO PROPERTIES USING COPYWITH
                  decoration: kInputDecoration.copyWith(
                      hintText: 'Enter Your Password'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    colour: Colors.lightBlueAccent,
                    fun: () async {
                      setState(() {
                        show = true;
                      });
                      try {
                        final newuser = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (newuser != null) {
                          setState(() {
                            show=false;
                          });
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return alertfun(context, e.toString());
                          },
                        );
                      }
                      setState(() {
                        show = false;
                      });
                    },
                    text: 'Login'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

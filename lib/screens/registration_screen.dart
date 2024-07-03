import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../RoundedButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'RegestrationScreen';

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool show = false;

  final _auth = FirebaseAuth.instance;
  late String password;
  late String email;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: show,
      child: Flexible(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
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
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    //Do something with the user input.
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
                    //Do something with the user input.
                    password = value;
                  },
                  style: const TextStyle(color: Colors.black87),
                  decoration: kInputDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    colour: Colors.blueAccent,
                    fun: () async {
                      setState(() {
                        show = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return alertfun(context, e.toString());
                            });
                      }
                      setState(() {
                        show = false;
                      });
                    },
                    text: 'Register'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

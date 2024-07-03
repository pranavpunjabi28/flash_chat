import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/RoundedButton.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "WelcomeScreen";

  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  //if we want multiple animation controller object than we use TickerProviderStateMixin or in case
  //of one ob of Animation Controller we use SingleTickerProviderStateMixin

  late AnimationController controller;
  late Animation curve;

  // it is common for an AnimationController to be created in the State.
  // initState method and then disposed in the State.dispose method.

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    //NOTE:By default, an AnimationController linearly produces values that
    // range from lowerbound=0.0 to upperbound=1.0,
    // during a given duration. The animation controller generates a new value
    // whenever the device running your app is ready to display a new frame
    // (typically, this rate is around 60 values per second).

    controller.forward();
    //Starts running this animation forwards (towards the end).

    //curve=CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    //To use a Tween object with an animation, call the Tween object's animate method and pass it the Animation object that you want to modify.
    curve = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    //for repeating animation
    // curve.addStatusListener((status) {
    //   //Calls listener every time the status of the animation changes.
    //   if(status==AnimationStatus.completed)
    //   {controller.reverse(from: 1);}
    //   else if(status==AnimationStatus.dismissed)
    //   {controller.forward(from: 0);}
    // });

    controller.addListener(() {
      //Calls the listener every time the value of the animation changes.
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: curve.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 60,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText(
                    'Flash Chat',
                    speed: const Duration(milliseconds: 60),
                    textStyle: const TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                    cursor: '|',
                  )
                ]),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                colour: Colors.lightBlueAccent,
                fun: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                text: 'Login'),
            RoundedButton(
                colour: Colors.blueAccent,
                fun: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                text: 'Register'),
          ],
        ),
      ),
    );
  }
}

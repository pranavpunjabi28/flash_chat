import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //NOTE WHEN WE USING INITIAL ROUTES WE CANT USE HOME PROPERTIES BEC THEY CAN GENRATE CONFLICTS IN A PROJECT
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) {
          return const WelcomeScreen();
        },
        LoginScreen.id: (context) {
          return const LoginScreen();
        },
        RegistrationScreen.id: (context) {
          return const RegistrationScreen();
        },
        ChatScreen.id: (context) {
          return const ChatScreen();
        },
      },
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black54),
        ),
      ),
      // home: const WelcomeScreen(),
    );
  }
}

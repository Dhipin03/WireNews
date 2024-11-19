import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wirenews/controller/home_screen_controller.dart';
import 'package:wirenews/controller/login_screen_controller.dart';
import 'package:wirenews/controller/signup_screen_controller.dart';
import 'package:wirenews/firebase_options.dart';
import 'package:wirenews/view/isuserlogined_screen/isuserlogined_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeScreenController()),
        ChangeNotifierProvider(create: (context) => SignupScreenController()),
        ChangeNotifierProvider(create: (context) => LoginScreenController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IsuserloginedScreen(),
      ),
    );
  }
}

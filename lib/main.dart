import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice1/screens/homepage.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(Splashscreen());
}

bool _darkthemeSwitch = false;

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: _darkthemeSwitch ? ThemeData.dark() : null,
      theme: ThemeData(
          textTheme:
              GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme)),
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(
        seconds: 2,
        navigateAfterSeconds: MyApp(),
        image: Image.asset('assets/images/tasklisticon.png'),
        backgroundColor: Colors.deepPurple,
        photoSize: 50,
        loaderColor: Colors.deepPurple,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      child: HomePage(),
    );
  }
}

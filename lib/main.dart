import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:practice1/screens/homepage.dart';
import 'package:splashscreen/splashscreen.dart';

const darkModeBox = 'darkModeEnabler';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(darkModeBox);
  runApp(Splashscreen());
}

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    return ValueListenableBuilder(
        valueListenable: Hive.box(darkModeBox).listenable(),
        builder: (context, box, widget) {
          var _darkthemeSwitch = box.get('darkMode', defaultValue: false);
          return Container(
            child: HomePage(darkthemeSwitcher: _darkthemeSwitch,box: box,),
          );
        });
  }
}

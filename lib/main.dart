import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:practice1/screens/homepage.dart';
import 'package:practice1/screens/workpage.dart';
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
    return ValueListenableBuilder(
        valueListenable: Hive.box(darkModeBox).listenable(),
        builder: (context, box, widget) {
          var _darkthemeSwitch = box.get('darkMode', defaultValue: false);
          return MaterialApp(
            darkTheme: _darkthemeSwitch ? ThemeData.dark() : null,
            theme: ThemeData(
                textTheme: GoogleFonts.nunitoSansTextTheme(
                    Theme.of(context).textTheme)),
            debugShowCheckedModeBanner: false,
            home: new SplashScreen(
              seconds: 2,
              navigateAfterSeconds: PageNav(
                darkthemeSwitch: _darkthemeSwitch,
              ),
              image: Image.asset('assets/images/tasklisticon.png'),
              backgroundColor: Colors.deepPurple,
              photoSize: 50,
              loaderColor: Colors.deepPurple,
            ),
          );
        });
  }
}

class CasualTasks extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(darkModeBox).listenable(),
        builder: (context, box, widget) {
          var _darkthemeSwitch = box.get('darkMode', defaultValue: false);
          return Container(
            child: HomePage(
              darkthemeSwitcher: _darkthemeSwitch,
              box: box,
              selectedIndex: _selectedIndex,
            ),
          );
        });
  }
}

class WorkTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(darkModeBox).listenable(),
      builder: (context, box, widget) {
        var _darkthemeSwitch = box.get('darkMode', defaultValue: false);
        return Container(
          child: Workpage(
            darkthemeSwitcher: _darkthemeSwitch,
            box: box,
            selectedindex: _selectedIndex,
          ),
        );
      },
    );
  }
}

int _selectedIndex = 0;

class PageNav extends StatefulWidget {
  final bool darkthemeSwitch;
  PageNav({this.darkthemeSwitch});
  @override
  _PageNavState createState() => _PageNavState();
}

class _PageNavState extends State<PageNav> {
  static List<Widget> _widgetOptions = <Widget>[ WorkTasks(),CasualTasks()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(blurRadius: 10, color: Colors.black87, spreadRadius: 0)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: GNav(
              gap: 8,
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 5),
              duration: Duration(milliseconds: 200),
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  iconSize: 20,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.black,
                  backgroundColor: Colors.white,
                  text: 'Casual',
                  textColor: Colors.black,
                ),
                GButton(
                  icon: Icons.work_outline,
                  iconSize: 20,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.black,
                  backgroundColor: Colors.white,
                  text: 'Work',
                  textColor: Colors.black,
                )
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  print(_selectedIndex);
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

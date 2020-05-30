import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './splash_screen.dart';
import './tab_page.dart';
import './sub_screens/view_members_screen.dart';
import './sub_screens/view_gifts_screen.dart';
import './sub_screens/my_gifts_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: SplashScreen(),
      routes: ({
        ViewMembersScreen.routeName:(context) => ViewMembersScreen(),
        ViewGiftsScreen.routeName:(context) => ViewGiftsScreen(),
        MyGiftsScreen.routeName:(context) => MyGiftsScreen(),
      }),
    );
  }
}

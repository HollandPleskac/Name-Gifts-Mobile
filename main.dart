import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './splash_screen.dart';
import './tab_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

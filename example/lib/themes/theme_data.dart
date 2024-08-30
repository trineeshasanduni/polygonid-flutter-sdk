import 'package:flutter/material.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    secondaryHeaderColor: Colors.black,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2CFFAE),
      secondary: Color(0xFFa3d902),
      background:  Color.fromARGB(255, 214, 230, 168),

    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.green,
      
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    secondaryHeaderColor: Colors.white,
    
    colorScheme: const ColorScheme.dark(
       primary: Color(0xFF2CFFAE),
      secondary: Color(0xFFa3d902),
      background: Color.fromARGB(255, 40, 40, 40),
      

    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFFa3d902),
    ),

    
    
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
     
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
  );
}

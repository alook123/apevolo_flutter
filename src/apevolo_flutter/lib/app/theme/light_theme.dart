import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  //scaffoldBackgroundColor: const Color.fromRGBO(246, 247, 251, 1),
  // colorScheme: ColorScheme(
  //   primary: Colors.blue,
  //   secondary: Colors.orange.shade700,
  //   surface: Colors.white,
  //   background: const Color.fromRGBO(246, 247, 251, 1),
  //   error: Colors.red,
  //   onPrimary: Colors.red,
  //   onSecondary: Colors.green,
  //   onSurface: Colors.black87,
  //   onBackground: Colors.white,
  //   onError: Colors.red,
  //   brightness: Brightness.light,
  // ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue, //设置主色
    //  primaryColorDark: Colors.blue[900], //设置主色深色
    accentColor: Colors.orange.shade700, //设置强调色
    cardColor: Colors.white, //设置卡片颜色
    backgroundColor: const Color.fromRGBO(246, 247, 251, 1), //设置背景颜色
    errorColor: Colors.red, //设置错误颜色
    brightness: Brightness.light, //设置亮度
  ).copyWith(
    primary: Colors.blue,
    onPrimary: Colors.red,
    //secondary: Colors.orange.shade700,
    // onSecondary: Colors.red,
    background: const Color.fromRGBO(246, 247, 251, 1),
    onBackground: Colors.white,
  ),
  // textTheme: ThemeData.light().textTheme.apply(
  //       bodyColor: Colors.green, // 用于一般文本的颜色
  //       displayColor: Colors.orange, // 用于标题等展示文本的颜色
  //     ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  // textButtonTheme: TextButtonThemeData(
  //   style: TextButton.styleFrom(
  //     foregroundColor: Colors.black,
  //   ),
  // ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey; // 设置禁用时的颜色为灰色
          }
          return Colors.blue; // 默认使用浅蓝色
        },
      ),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.transparent,
    elevation: 0,
  ),
  // bottomAppBarTheme(
  //   color: Colors.white,
  //   elevation: 0,
  // ),
  // appBarTheme: const AppBarTheme(
  //   //backgroundColor: Color.fromRGBO(246, 247, 251, 1),
  //   backgroundColor: Color.fromRGBO(246, 247, 251, 1),
  //   surfaceTintColor: Color.fromRGBO(246, 247, 251, 1),
  //   foregroundColor: Colors.black,
  //   titleTextStyle: TextStyle(
  //     color: Colors.black,
  //   ),
  //   toolbarTextStyle: TextStyle(
  //     color: Colors.black,
  //   ),
  // ),
  // floatingActionButtonTheme: const FloatingActionButtonThemeData(
  //   backgroundColor: Colors.blue,
  //   foregroundColor: Colors.white,
  // ),
  // inputDecorationTheme: const InputDecorationTheme(
  //   fillColor: Colors.white,
  //   labelStyle: TextStyle(
  //     color: Color.fromRGBO(195, 195, 195, 1),
  //   ),
  // ),
  // iconTheme: const IconThemeData(
  //   color: Colors.black54,
  // ),
  // primaryIconTheme: const IconThemeData(
  //   color: Colors.black,
  // ),
  // iconButtonTheme: IconButtonThemeData(
  //   style: ButtonStyle(
  //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  //   ),
  // ),
  // popupMenuTheme: const PopupMenuThemeData(
  //   surfaceTintColor: Colors.white,
  //   color: Colors.white,
  //   textStyle: TextStyle(
  //     color: Colors.black,
  //   ),
  // ),
  // buttonTheme: const ButtonThemeData(
  //   buttonColor: Colors.blue,
  //   textTheme: ButtonTextTheme.primary,
  // ),
  // textButtonTheme: TextButtonThemeData(
  //   style: ButtonStyle(
  //     foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  //   ),
  // ),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ButtonStyle(
  //     backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  //   ),
  // ),
  // dialogTheme: const DialogTheme(
  //   surfaceTintColor: Colors.white,
  // ),
);

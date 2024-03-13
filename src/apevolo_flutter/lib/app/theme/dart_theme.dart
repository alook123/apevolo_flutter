import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue, //设置主色
    // primaryColorDark: Colors.blue[900], //设置主色深色
    accentColor: Colors.orange.shade700, //设置强调色
    backgroundColor: const Color.fromRGBO(48, 48, 48, 48), //设置背景颜色
    errorColor: Colors.red, //设置错误颜色
    brightness: Brightness.dark, //设置亮度
  ).copyWith(
    primary: Colors.blue,
    onPrimary: Colors.red,
    //secondary: Colors.orange.shade700,
    // onSecondary: Colors.red,
    background: const Color.fromRGBO(48, 48, 48, 48),
    //onBackground: const Color.fromRGBO(66, 66, 66, 66),
    onBackground: Colors.black,
  ),
  cardTheme: CardTheme(
    // color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  // textButtonTheme: TextButtonThemeData(
  //   style: TextButton.styleFrom(
  //     foregroundColor: Colors.white,
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
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  ),
);

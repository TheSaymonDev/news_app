import 'package:flutter/material.dart';
import 'package:news_app/screen/home_page.dart';
import 'package:news_app/theme_pref/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
          builder: (context, ModelTheme themeNotifier, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeNotifier.isDark
              ? ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Colors.black,
                  cardColor: Color(0xff323232),
                  textTheme: TextTheme(
                    headline1: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    headline2: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              : ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  cardColor: Color(0xffe0f7fa),
                  brightness: Brightness.light,
                  primaryColor: Colors.green,
                  primarySwatch: Colors.green,
                ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        );
      }),
    );
  }
}

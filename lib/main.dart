import 'package:flutter/material.dart';
import 'package:episodes/WebViewContainer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headlineLarge: TextStyle(
              color: Colors.white, fontSize: 25, fontFamily: 'MainFont'),
          headlineMedium: TextStyle(color: Colors.black, fontSize: 20),
          titleMedium: TextStyle(color: Colors.red, fontSize: 16),
        ),
        useMaterial3: true,
      ),
      home: const WebViewContainer(),
    );
  }
}
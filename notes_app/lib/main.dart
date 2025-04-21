import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/ultils/constants.dart';
import 'package:notes_app/widgets/floating_search_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteNow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(primaryColor: DARK_THEME_COLOR),
      home: HomeScreen(),
    );
  }
}

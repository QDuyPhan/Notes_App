import 'package:flutter/material.dart';
import 'package:notes_app/app_state/app_state.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/ultils/constants.dart';
import 'package:provider/provider.dart';

late AppState appState;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  appState = AppState();

  appState.initialization().then((_) => appState.readNotes());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => appState,
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            title: 'NoteNow',
            debugShowCheckedModeBanner: false,
            theme:
                Provider.of<AppState>(context).isDarkTheme
                    ? ThemeData.dark().copyWith(primaryColor: DARK_THEME_COLOR)
                    : ThemeData.light().copyWith(
                      primaryColor: LIGHT_THEME_COLOR,
                    ),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/app_state/app_state.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/screens/note_screen.dart';
import 'package:notes_app/ultils/constants.dart';
import 'package:notes_app/widgets/home_nav_drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/floating_search_bar.dart';
import '../widgets/note_box.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => NoteScreen()));
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1),
            ],
          ),
          child: Icon(Icons.add, color: LIGHT_THEME_COLOR, size: 40),
        ),
      ),
      drawer: HomeNavDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: FloatingSearchBar(scaffoldKey: _scaffoldKey),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 4),
              child: Text(
                "Yours Notes",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                color:
                    Provider.of<AppState>(context).isDarkTheme
                        ? DARK_THEME_COLOR
                        : LIGHT_THEME_COLOR,
                child:
                    Provider.of<AppState>(context).notesModel.notesCount != 0
                        ? Consumer<AppState>(
                          builder: (context, appState, child) {
                            return MasonryGridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              crossAxisSpacing: 12,
                              itemCount: appState.notesModel.notesCount,
                              physics: BouncingScrollPhysics(),
                              itemBuilder:
                                  (context, index) => Hero(
                                    tag: 'note_box_$index',
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (builder) => NoteScreen(
                                                  noteIndex: index,
                                                ),
                                          ),
                                        );
                                      },
                                      child: NoteBox(
                                        title:
                                            (appState.notesModel
                                                        .getNote(index)
                                                        .noteTitle !=
                                                    null)
                                                ? appState.notesModel
                                                    .getNote(index)
                                                    .noteTitle
                                                : "Note",
                                        text:
                                            appState.notesModel
                                                .getNote(index)
                                                .noteContent,
                                        labelColor:
                                            LABEL_COLOR[appState.notesModel
                                                .getNote(index)
                                                .noteLabel],
                                      ),
                                    ),
                                  ),
                            );
                          },
                        )
                        : Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/rafiki.png"),
                                Text(
                                  "Create your first note !",
                                  style: TextStyle(
                                    color:
                                        appState.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

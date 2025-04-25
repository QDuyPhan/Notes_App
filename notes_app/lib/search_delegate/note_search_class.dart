import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../app_state/app_state.dart';
import '../screens/note_screen.dart';
import '../ultils/constants.dart';
import '../widgets/note_box.dart';

class NoteSearchClass extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return showSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return showSearchResults(context);
  }

  Widget showSearchResults(BuildContext context) {
    List<int> relevantIndexes = Provider.of<AppState>(
      context,
    ).notesModel.searchNotes(query);
    if (relevantIndexes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/cuate.png"),
              Text(
                "File not found. Try searching again.",
                style: TextStyle(
                  color:
                      Provider.of<AppState>(context).isDarkTheme
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return AlignedGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          itemCount: relevantIndexes.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Hero(
              tag: 'note_box_$index',
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (builder) =>
                              NoteScreen(noteIndex: relevantIndexes[index]),
                    ),
                  );
                },
                child: NoteBox(
                  title:
                      appState.notesModel
                          .getNote(relevantIndexes[index])
                          .noteTitle,
                  text:
                      appState.notesModel
                          .getNote(relevantIndexes[index])
                          .noteContent,
                  labelColor:
                      LABEL_COLOR[appState.notesModel
                          .getNote(relevantIndexes[index])
                          .noteLabel],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

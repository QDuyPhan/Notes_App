import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/app_state/app_state.dart';
import 'package:notes_app/main.dart';
import 'package:provider/provider.dart';

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
    if (relevantIndexes.length == 0) {
      return Container(
        child: Center(child: Text('No result', style: TextStyle(fontSize: 20))),
      );
    }

    return Consumer(
      builder: (context, appState, child) {
        return AlignedGridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          itemCount: relevantIndexes.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Hero(
              tag: 'note_box_$index',
              child: GestureDetector(onTap: () {}),
            );
          },
        );
      },
    );
  }
}

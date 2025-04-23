import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state/app_state.dart';
import '../ultils/constants.dart';

class NoteWritingSection extends StatefulWidget {
  String? startingTitle;
  String? startingContent;
  Function? editNoteTitleCallback;
  Function? editNoteContentCallback;

  NoteWritingSection({
    super.key,
    this.startingTitle,
    this.startingContent,
    this.editNoteTitleCallback,
    this.editNoteContentCallback,
  });

  @override
  State<NoteWritingSection> createState() => _NoteWritingSectionState();
}

class _NoteWritingSectionState extends State<NoteWritingSection> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.startingTitle ?? "";
    _contentController.text = widget.startingContent ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder:
          (context, appState, child) => Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.2,
                color:
                    appState.isDarkTheme ? LIGHT_THEME_COLOR : DARK_THEME_COLOR,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            appState.isDarkTheme
                                ? LIGHT_THEME_COLOR
                                : DARK_THEME_COLOR,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            appState.isDarkTheme
                                ? LIGHT_THEME_COLOR
                                : DARK_THEME_COLOR,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            appState.isDarkTheme
                                ? LIGHT_THEME_COLOR
                                : DARK_THEME_COLOR,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 0,
                    ),
                    hintStyle: TextStyle(fontSize: 24),
                    hintText: "Title",
                  ),
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    widget.editNoteTitleCallback!(value);
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Note",
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      widget.editNoteContentCallback!(value);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

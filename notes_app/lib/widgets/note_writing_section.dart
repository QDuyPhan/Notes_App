import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state/app_state.dart';
import '../ultils/constants.dart';

class NoteWritingSection extends StatefulWidget {
  String? startingTitle;
  String? startingContent;
  void Function(String) editNoteTitleCallback;
  void Function(String) editNoteContentCallback;

  NoteWritingSection({
    super.key,
    this.startingTitle,
    required this.startingContent,
    required this.editNoteTitleCallback,
    required this.editNoteContentCallback,
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
    _contentController.text = widget.startingContent!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder:
          (context, appState, child) => Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: appState.isDarkTheme ? Colors.white : Colors.black,
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
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              appState.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              appState.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
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
                      widget.editNoteTitleCallback(value);
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
                        widget.editNoteContentCallback(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

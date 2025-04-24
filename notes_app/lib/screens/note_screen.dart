import 'package:flutter/material.dart';
import 'package:notes_app/app_state/app_state.dart';
import 'package:notes_app/ultils/constants.dart';
import 'package:notes_app/widgets/label_selector_dialog.dart';
import 'package:notes_app/widgets/note_writing_section.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/note.dart';

class NoteScreen extends StatefulWidget {
  final int? noteIndex;

  const NoteScreen({super.key, this.noteIndex});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  NoteModel? _note;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo _note trong initState với giá trị mặc định tạm thời
    if (widget.noteIndex == null) {
      _note = NoteModel(
        noteContent: "",
        noteTitle: "",
        noteLabel: 0,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      _isInitialized = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Nếu đang chỉnh sửa ghi chú, lấy từ AppState
    if (widget.noteIndex != null && _note == null) {
      final appState = Provider.of<AppState>(context, listen: false);
      final existingNote = appState.notesModel.getNote(widget.noteIndex!);
      setState(() {
        _note = NoteModel(
          noteTitle: existingNote.noteTitle ?? "",
          noteContent: existingNote.noteContent,
          noteLabel: existingNote.noteLabel,
          id: existingNote.id,
        );
        _isInitialized = false;
      });
    }
  }

  void editNoteTitle(String newTitle) {
    setState(() {
      _note?.noteTitle = newTitle;
    });
  }

  void editNoteContent(String newContent) {
    setState(() {
      _note?.noteContent = newContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Consumer<AppState>(
      builder:
          (context, appState, child) => Scaffold(
            appBar: AppBar(
              leading: BackButton(
                color:
                    appState.isDarkTheme ? LIGHT_THEME_COLOR : DARK_THEME_COLOR,
              ),
              elevation: 0,
              title: Text(
                "Your Note",
                style: TextStyle(
                  color:
                      appState.isDarkTheme
                          ? LIGHT_THEME_COLOR
                          : DARK_THEME_COLOR,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color:
                        appState.isDarkTheme
                            ? LIGHT_THEME_COLOR
                            : DARK_THEME_COLOR,
                  ),
                  onPressed: () {
                    if (_note!.noteContent.trim().isNotEmpty ||
                        _note!.noteTitle!.trim().isNotEmpty) {
                      appState.saveNote(_note!, widget.noteIndex);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please enter some content or title for the note.",
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            body: Hero(
              tag:
                  widget.noteIndex != null
                      ? 'note_box_${widget.noteIndex}'
                      : 'note_box',
              child: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          height -
                          (MediaQuery.of(context).padding.top + kToolbarHeight),
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: height * 0.01,
                                vertical: width * 0.015,
                              ),
                              child: NoteWritingSection(
                                startingTitle: _note!.noteTitle,
                                startingContent: _note!.noteContent,
                                editNoteTitleCallback: editNoteTitle,
                                editNoteContentCallback: editNoteContent,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          BottomNoteOptions(
                            height: height,
                            width: width,
                            note: _note!,
                            deleteNoteCallback: () {
                              if (widget.noteIndex != null) {
                                appState.deleteNote(_note!);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

class BottomNoteOptions extends StatefulWidget {
  NoteModel note;
  final Function? deleteNoteCallback;
  final double height;
  final double width;

  BottomNoteOptions({
    required this.note,
    required this.deleteNoteCallback,
    required this.height,
    required this.width,
  });

  @override
  State<StatefulWidget> createState() => _BottomNoteOptionsState();
}

class _BottomNoteOptionsState extends State<BottomNoteOptions> {
  // void changeLabelCallback(int newLabel) {
  //   setState(() {
  //     widget.note.noteLabel = newLabel;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height * 0.09,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => LabelSelectorDialog(
                      selectedLabel: widget.note.noteLabel,
                      width: widget.width,
                      changeLabelCallback: (int newLabel) {
                        setState(() {
                          widget.note.noteLabel = newLabel;
                        });
                      },
                    ),
              );
            },
            icon: Icon(Icons.star, color: LABEL_COLOR[widget.note.noteLabel]),
            iconSize: 28,
          ),
          IconButton(
            onPressed: () {
              widget.deleteNoteCallback?.call();
            },
            icon: Icon(Icons.delete_outline),
            iconSize: 29,
          ),
          IconButton(
            onPressed: () {
              if (widget.note.noteContent.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("There is no content in the note to share"),
                  ),
                );
              } else {
                Share.share(widget.note.noteContent);
              }
            },
            icon: Icon(Icons.share_outlined),
            iconSize: 28,
          ),
        ],
      ),
    );
  }
}

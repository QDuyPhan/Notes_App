import 'package:flutter/material.dart';
import 'package:notes_app/app_state/app_state.dart';
import 'package:notes_app/ultils/constants.dart';
import 'package:provider/provider.dart';

class NoteBox extends StatelessWidget {
  final Color? labelColor;
  final String text;
  final String? title;

  const NoteBox({
    Key? key,
    required this.labelColor,
    required this.text,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(6),
      child: Consumer<AppState>(
        builder: (context, appState, child) => Container(
          constraints: BoxConstraints(
            maxHeight: 150, // Giới hạn chiều cao tối đa của ô
          ),
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.8),
            color: appState.isDarkTheme ? DARK_THEME_COLOR : Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.star, color: labelColor, size: 14),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          title?.trim().isNotEmpty == true ? title! : "Note",
                          maxLines: 1,
                          style: appState.isDarkTheme
                              ? NOTE_STYLE.copyWith(color: Colors.white)
                              : NOTE_STYLE,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: appState.isDarkTheme ? Colors.white : Colors.grey,
                thickness: 0.5,
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(height: 1.2),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  maxLines: 4, // Giảm số dòng tối đa để nhường chỗ cho tiêu đề
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:notes_app/app_state/app_state.dart';
import 'package:notes_app/search_delegate/note_search_class.dart';
import 'package:provider/provider.dart';

import '../ultils/constants.dart';

class FloatingSearchBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  const FloatingSearchBar({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(6),
      child: Consumer<AppState>(
        builder:
            (context, appState, child) => Container(
              height: 50,
              decoration: BoxDecoration(
                color: appState.isDarkTheme ? SURFACE_COLOR_DARK : Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                       _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Icon(Icons.menu, size: ICON_SIZE),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: NoteSearchClass(),
                          );
                        },
                        child: Text(
                          'Search your notes',
                          style: TextStyle(fontSize: 18, color: TEXT_COLOR),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.cloud_upload_rounded, size: ICON_SIZE),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

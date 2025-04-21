import 'package:flutter/material.dart';

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
      child: Container(),
    );
  }
}

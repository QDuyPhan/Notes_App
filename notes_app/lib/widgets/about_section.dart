import 'package:flutter/material.dart';
import 'package:notes_app/app_state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ultils/constants.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Consumer<AppState>(
        builder:
            (context, appState, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Developer By".toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w500,
                    color:
                        appState.isDarkTheme
                            ? DARK_THEME_WHITE_GREY
                            : TEXT_COLOR,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  "Phan Quang Duy",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    await canLaunchUrl("https://github.com/QDuyPhan" as Uri)
                        ? await launchUrl("https://github.com/QDuyPhan" as Uri)
                        : throw "Could not launch";
                  },
                  icon: Icon(Icons.link),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color:
                            appState.isDarkTheme
                                ? DARK_THEME_WHITE_GREY
                                : TEXT_COLOR,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        horizontal: width * 0.1,
                        vertical: height * 0.01,
                      ),
                    ),
                  ),
                  label: Text(
                    "Github",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color:
                          appState.isDarkTheme
                              ? DARK_THEME_WHITE_GREY
                              : TEXT_COLOR,
                      letterSpacing: 1.05,
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

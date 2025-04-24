import 'package:flutter/material.dart';
import 'package:notes_app/app_state/app_state.dart';
import 'package:notes_app/ultils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnlineSyncScreen extends StatefulWidget {
  const OnlineSyncScreen({super.key});

  @override
  State<OnlineSyncScreen> createState() => _OnlineSyncScreenState();
}

class _OnlineSyncScreenState extends State<OnlineSyncScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final SharedPreferences prefs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoginMode = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AppState>(
        builder:
            (context, appState, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                leading: BackButton(
                  color:
                      appState.isDarkTheme
                          ? LIGHT_THEME_COLOR
                          : DARK_THEME_COLOR,
                ),
              ),
              body: Center(
                child: Container(
                  height: 400,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child:
                      (appState.userEmail == DEFAUL_EMAIL)
                          ? Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  isLoginMode
                                      ? "Login".toUpperCase()
                                      : "Register".toUpperCase(),
                                  style: TEXT_STYLE,
                                ),
                                SizedBox(height: 25),
                                TextFormField(
                                  controller: emailController,
                                  decoration: INPUT_FIELD_DECORATION.copyWith(
                                    labelStyle: TextStyle(
                                      color:
                                          appState.isDarkTheme
                                              ? Colors.white70
                                              : Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    value = value!.toLowerCase().trim();
                                    if (value.isEmpty) {
                                      return "Please enter your email";
                                    }
                                    if (value == DEFAUL_EMAIL) {
                                      return "This email is invalid.";
                                    } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                    ).hasMatch(value)) {
                                      return "This does not seem to be a valid email id";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: passwordController,
                                  style: TextStyle(fontSize: 18),
                                  decoration: INPUT_FIELD_DECORATION.copyWith(
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                      color:
                                          appState.isDarkTheme
                                              ? Colors.white70
                                              : Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            appState.isDarkTheme
                                                ? Colors.white
                                                : Colors.black45,
                                      ),
                                    ),
                                  ),
                                  // keyboardType: TextInputType.o,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter the password.";
                                    } else if (value.length < 6) {
                                      return "Please enter at least 6 characters for the password.";
                                    }
                                  },
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                          BUTTON_COLOR,
                                        ),
                                    padding: WidgetStateProperty.all<
                                      EdgeInsetsGeometry
                                    >(EdgeInsets.symmetric(vertical: 16)),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      print(
                                        "Valid data entered for ${isLoginMode ? 'login' : 'register'}.",
                                      );
                                      final appState = Provider.of<AppState>(
                                        context,
                                        listen: false,
                                      );
                                      final future =
                                          isLoginMode
                                              ? appState.loginUser(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                              )
                                              : appState.registerUser(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                              );

                                      future.then((value) {
                                        if (value == STATUS.unknownError) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "An unknown error occurred.",
                                              ),
                                            ),
                                          );
                                        } else if (value ==
                                            STATUS.wrong_password) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Wrong password entered.",
                                              ),
                                            ),
                                          );
                                        } else if (value ==
                                            STATUS.user_not_found) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("User not found."),
                                            ),
                                          );
                                        } else if (value ==
                                            STATUS.weak_password) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Firebase says it is a weak password.",
                                              ),
                                            ),
                                          );
                                        } else if (value ==
                                            STATUS.email_already_in_use) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Email already in use.",
                                              ),
                                            ),
                                          );
                                        } else if (value == STATUS.successful) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                isLoginMode
                                                    ? "Logged in successfully."
                                                    : "Registered successfully.",
                                              ),
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        }
                                      });
                                    }
                                  },
                                  child: Text(
                                    isLoginMode ? "Login" : "Register",
                                    style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 0.75,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isLoginMode
                                          ? "Don't have an account? "
                                          : "Already have an account? ",
                                      style: TextStyle(
                                        color:
                                            appState.isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isLoginMode =
                                              !isLoginMode; // Chuyển đổi chế độ
                                        });
                                      },
                                      child: Text(
                                        isLoginMode ? 'Register' : 'Login',
                                        style: TextStyle(
                                          color: BLUE_COLOR,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                          : AlreadySyncingWidget(),
                ),
              ),
            ),
      ),
    );
  }
}

class AlreadySyncingWidget extends StatelessWidget {
  const AlreadySyncingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(BUTTON_COLOR),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Try something note!",
            style: TextStyle(fontSize: 16, letterSpacing: 0.75),
          ),
        ),
      ],
    );
  }
}

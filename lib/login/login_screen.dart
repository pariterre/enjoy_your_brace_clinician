import 'package:flutter/material.dart';

import 'widgets/change_password_alert_dialog.dart';
import 'widgets/new_user_alert_dialog.dart';
import 'login_information.dart';
import 'user.dart';

enum LoginStatus {
  none,
  waitingForLogin,
  success,
  newUser,
  couldNotCreateUser,
  wrongUsername,
  wrongPassword,
  unrecognizedError,
  cancelled,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  LoginInformation? _logger;
  Future<LoginStatus>? _futureStatus;

  Future<User?> _createUser(String email) async {
    final user = await showDialog<User>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return NewUserAlertDialog(email: email);
      },
    );
    return user;
  }

  Future<String> _changePassword() async {
    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const ChangePasswordAlertDialog();
      },
    );
    return password!;
  }

  void _showSnackbar(LoginStatus status, ScaffoldMessengerState scaffold) {
    late final String message;
    if (status == LoginStatus.waitingForLogin) {
      message = '';
    } else if (status == LoginStatus.cancelled) {
      message = 'La connexion a été annulée';
    } else if (status == LoginStatus.success) {
      message = '';
    } else if (status == LoginStatus.wrongUsername) {
      message = 'Utilisateur non enregistré';
    } else if (status == LoginStatus.wrongPassword) {
      message = 'Mot de passe non reconnu';
    } else {
      message = 'Erreur de connexion inconnue';
    }

    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<LoginStatus> _processConnexion() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return LoginStatus.cancelled;
    }
    _formKey.currentState!.save();

    final scaffold = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    _logger = LoginInformation.of(context, listen: false);
    final status = await _logger!.login(
      context,
      email: _email!,
      password: _password!,
      newUserUiCallback: _createUser,
      changePasswordCallback: _changePassword,
    );
    setState(() {});
    if (status != LoginStatus.success) {
      _showSnackbar(status, scaffold);
      return status;
    }

    if (_logger!.user!.isStudent) {
      _waitingRoomForStudent();
    } else {
      navigator.pushReplacementNamed(StudentsScreen.routeName);
    }
    return status;
  }

  void _waitingRoomForStudent() {
    if (_logger == null) return;

    // Wait until the data are fetched
    if (_allStudents!.isEmpty) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _waitingRoomForStudent());
      return;
    }

    Navigator.of(context).pushReplacementNamed(QAndAScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    _allStudents = Provider.of<AllStudents>(context, listen: true);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ColoredCorners(
            firstColor: LinearGradient(
              end: const Alignment(0, 0.6),
              begin: const Alignment(0.5, 1.5),
              colors: [
                teacherTheme().colorScheme.primary,
                Colors.white,
              ],
            ),
            secondColor: LinearGradient(
              begin: const Alignment(-0.1, -1),
              end: const Alignment(0, -0.6),
              colors: [
                studentTheme().colorScheme.primary,
                Colors.white10,
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MainTitle(),
                const SizedBox(height: 50),
                FutureBuilder<LoginStatus>(
                    future: _futureStatus,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: teacherTheme().colorScheme.primary,
                        );
                      }

                      return Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Informations de connexion',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Courriel'),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Inscrire un courriel'
                                            : null,
                                    onSaved: (value) => _email = value,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Mot de passe'),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Entrer le mot de passe'
                                            : null,
                                    onSaved: (value) => _password = value,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    keyboardType: TextInputType.visiblePassword,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () {
                              _futureStatus = _processConnexion();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    teacherTheme().colorScheme.primary),
                            child: Text(
                              'Se connecter',
                              style: TextStyle(
                                color: teacherTheme().colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainTitle extends StatelessWidget {
  const MainTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()..rotateZ(-15 * 3.1415927 / 180),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColoredBox(
            color: studentTheme().colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'DÉFI',
                style: TextStyle(
                    fontSize: 40, color: studentTheme().colorScheme.onPrimary),
              ),
            ),
          ),
          ColoredBox(
            color: teacherTheme().colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'PHOTO',
                style: TextStyle(
                    fontSize: 40, color: teacherTheme().colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

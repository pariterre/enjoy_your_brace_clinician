import 'package:ezlogin/ezlogin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ezlogin_mock.dart';
import 'models/main_user.dart';
import 'screens/login_screen.dart';
import 'screens/patient_overview_screen.dart';

///
/// Here is an dummy database to test. It creates
final Map<String, dynamic> initialDatabase = {
  'a': defineNewUser(
      MainUser(
        firstName: 'Super',
        lastName: 'Three',
        email: 'super3@user.qc',
        userType: EzloginUserType.superUser,
        shouldChangePassword: false,
        notes: 'This is my first note',
      ),
      password: 'a'),
  'super1@user.qc': defineNewUser(
      MainUser(
        firstName: 'Super',
        lastName: 'One',
        email: 'super1@user.qc',
        userType: EzloginUserType.superUser,
        shouldChangePassword: false,
        notes: 'This is my second note',
      ),
      password: '123456'),
  'super2@user.qc': defineNewUser(
      MainUser(
        firstName: 'Super',
        lastName: 'Two',
        email: 'super2@user.qc',
        userType: EzloginUserType.superUser,
        shouldChangePassword: true,
        notes: 'This is my third note',
      ),
      password: '123456'),
  'normal1@user.qc': defineNewUser(
    MainUser(
      firstName: 'Normal',
      lastName: 'One',
      email: 'normal1@user.qc',
      userType: EzloginUserType.user,
      shouldChangePassword: false,
      notes: 'This is my forth note',
    ),
    password: '123456',
  ),
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EzloginMock>(create: (_) => EzloginMock(initialDatabase))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) =>
              LoginScreen(targetRouteName: PatientOverviewScreen.routeName),
          PatientOverviewScreen.routeName: (context) =>
              const PatientOverviewScreen(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yu_ngantri_medic_user/models/user.dart';
import 'package:yu_ngantri_medic_user/screens/wrapper.dart';
import 'package:yu_ngantri_medic_user/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Yu-Ngantri Medic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFFD81B60),
          accentColor: Color(0xFFFFFFFF),
        ),
        home: Wrapper(),
      ),
    );
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yu_ngantri_medic_user/screens/authenticate/schedule.dart';
import 'package:yu_ngantri_medic_user/services/auth.dart';
import 'package:yu_ngantri_medic_user/services/database.dart';
import 'package:yu_ngantri_medic_user/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    void _showAvailableDoctors() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Schedule(),
          );
        },
      );
    }

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                _showAvailableDoctors();
              },
              backgroundColor: Color(0xFFD81B60),
              child: Icon(
                Icons.schedule,
                color: Colors.white,
              ),
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      children: <Widget>[
                        Image(
                          height: 100.0,
                          width: 200.0,
                          image: AssetImage(
                            'images/primary.png',
                          ),
                        ),
                        SizedBox(
                          height: 64.0,
                        ),
                        Form(
                          key: _formKey,
                          child: signInForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget signInForm() {
    return new Column(
      children: <Widget>[
        Container(
          height: 50.0,
          child: TextFormField(
            obscureText: false,
            cursorColor: Color(0xFFD81B60),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Alamat Email',
            ),
            validator: (val) => val.isEmpty ? 'Masukkan email' : null,
            onChanged: (val) {
              setState(() {
                email = val;
              });
            },
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          height: 50.0,
          child: TextFormField(
            obscureText: true,
            cursorColor: Color(0xFFD81B60),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kata Sandi',
            ),
            validator: (val) =>
                val.length < 6 ? 'Masukkan password minimal 6 karakter' : null,
            onChanged: (val) {
              setState(() {
                password = val;
              });
            },
          ),
        ),
        SizedBox(
          height: 24.0,
        ),
        ButtonTheme(
          height: 50.0,
          minWidth: double.infinity,
          child: RaisedButton(
            color: Color(0xFFD81B60),
            child: Text(
              'Masuk',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                setState(() {
                  loading = true;
                });

                dynamic result =
                    await _auth.signInWithEmailAndPassword(email, password);

                // get the token for user device
                String fcmToken = await _fcm.getToken();

                if (fcmToken != null) {
                  await DatabaseService(uid: await _auth.getUser())
                      .updateUserData(
                    email,
                    fcmToken,
                  );
                }

                if (result == null) {
                  setState(() {
                    error = 'Email atau password salah';
                    loading = false;
                  });
                }
              }
            },
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        FlatButton(
          child: Text(
            'Daftar',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          onPressed: () {
            widget.toggleView();
          },
        ),
        SizedBox(
          height: 16.0,
        ),
        Text(
          error,
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 14.0,
            color: Colors.red[400],
          ),
        ),
      ],
    );
  }
}

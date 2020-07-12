import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yu_ngantri_medic_user/services/auth.dart';
import 'package:yu_ngantri_medic_user/services/database.dart';
import 'package:yu_ngantri_medic_user/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
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
                            'images/secondary.png',
                          ),
                        ),
                        SizedBox(
                          height: 64.0,
                        ),
                        Form(
                          key: _formKey,
                          child: registerForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget registerForm() {
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
              'Daftar',
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
                    await _auth.registerWithEmailAndPassword(email, password);

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
                    error = 'Email anda salah atau sudah terdaftar';
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
            'Masuk',
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

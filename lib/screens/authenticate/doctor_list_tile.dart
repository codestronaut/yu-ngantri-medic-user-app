import 'package:flutter/material.dart';
import 'package:yu_ngantri_medic_user/models/doctor.dart';

class DoctorListTile extends StatelessWidget {
  final Doctor doctor;
  const DoctorListTile({this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 0.0),
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${doctor.id}',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              Text(
                '${doctor.schedule}',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w300,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          title: Text(
            doctor.name,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            doctor.division,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

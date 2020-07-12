import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yu_ngantri_medic_user/models/doctor.dart';
import 'package:yu_ngantri_medic_user/screens/authenticate/doctor_list_tile.dart';

class DoctorList extends StatefulWidget {
  DoctorList({Key key}) : super(key: key);

  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  @override
  Widget build(BuildContext context) {
    final doctors = Provider.of<List<Doctor>>(context) ?? [];
    return ListView.builder(
      itemBuilder: (context, index) {
        return DoctorListTile(
          doctor: doctors[index],
        );
      },
      itemCount: doctors.length,
    );
  }
}

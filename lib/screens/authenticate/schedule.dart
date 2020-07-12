import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yu_ngantri_medic_user/models/doctor.dart';
import 'package:yu_ngantri_medic_user/screens/authenticate/doctor_list.dart';
import 'package:yu_ngantri_medic_user/services/database.dart';

class Schedule extends StatefulWidget {
  Schedule({Key key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal dokter hari ini'),
      ),
      body: SafeArea(
        child: StreamProvider<List<Doctor>>.value(
          value: DatabaseService().availableDoctor,
          child: DoctorList(),
        ),
      ),
    );
  }
}

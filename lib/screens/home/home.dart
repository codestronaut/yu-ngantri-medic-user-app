import 'package:flutter/material.dart';
import 'package:yu_ngantri_medic_user/screens/home/outside_list.dart';
import 'package:yu_ngantri_medic_user/screens/home/ticket_form.dart';
import 'package:yu_ngantri_medic_user/screens/home/waiting_room_list.dart';
import 'package:yu_ngantri_medic_user/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showGetTicketForm() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: TicketForm(),
          );
        },
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Luar Ruangan'),
              ),
              Tab(
                child: Text('Ruang Tunggu'),
              ),
            ],
          ),
          title: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Yu-',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                    ),
                  ),
                  Text(
                    'Ngantri',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 6.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Text(
                  'medic',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w300,
                    fontSize: 14.0,
                    color: Color(0xFFD81B60),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: Text(
                'Keluar',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFD81B60),
          child: Icon(
            Icons.receipt,
            color: Colors.white,
          ),
          onPressed: () async {
            _showGetTicketForm();
          },
        ),
        body: TabBarView(
          children: [
            OutsideList(),
            WaitingRoomList(),
          ],
        ),
      ),
    );
  }
}

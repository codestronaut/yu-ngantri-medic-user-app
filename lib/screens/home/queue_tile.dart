import 'package:flutter/material.dart';
import 'package:yu_ngantri_medic_user/models/queue.dart';

class QueueTile extends StatelessWidget {
  final Queue queue;
  final String userId;
  QueueTile({this.queue, this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: queue.id == userId ? Color(0xFFD81B60) : Colors.white,
        margin: EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 0.0),
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${queue.ticket}',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                  color: queue.id == userId ? Colors.white : Colors.black,
                ),
              ),
              Text(
                '${queue.date}',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w300,
                  fontSize: 16.0,
                  color: queue.id == userId ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          title: Text(
            queue.id == userId
                ? 'Nomor Antrian Saya'
                : 'Tiket Antrian Loket ${queue.service.split('.')[0]}',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18.0,
              color: queue.id == userId ? Colors.white : Colors.black,
            ),
          ),
          subtitle: Text(
            'Layanan: ${queue.service}',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w300,
              color: queue.id == userId ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yu_ngantri_medic_user/services/auth.dart';
import 'package:yu_ngantri_medic_user/services/database.dart';

class TicketForm extends StatefulWidget {
  TicketForm({Key key}) : super(key: key);

  @override
  _TicketFormState createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> services = [
    'G. Dokter Gigi',
    'U. Dokter Umum',
    'R. Ronsen',
    'M. Spesialis Mata',
    'PD. Spesialis Penyakit Dalam'
  ];

  // input text state
  String _visitorService;
  int _visitorTicketNumber;
  String _ticketCode;
  String _visitorTime;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          Text(
            'Daftar Antrian Baru',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18.0,
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          DropdownButtonFormField(
            hint: Text('Layanan'),
            items: services.map((service) {
              return DropdownMenuItem(
                value: service,
                child: Text(service),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _visitorService = val;
              });
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _visitorTime != null
                  ? Text("Waktu Kunjungan: $_visitorTime")
                  : Text('Pilih jam untuk berkunjung'),
              OutlineButton(
                child: Icon(Icons.access_time),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.pink[700]),
                  borderRadius: BorderRadius.circular(50),
                ),
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      showSecondsColumn: false,
                      showTitleActions: true,
                      theme: DatePickerTheme(
                        doneStyle: TextStyle(
                          color: Color(0xFFD81B60),
                        ),
                      ), onChanged: (time) {
                    print('change $time'); // update time
                    setState(() {
                      _visitorTime = "${time.hour}:${time.minute}";
                    });
                  }, onConfirm: (time) {
                    print('confirm $time'); // update time
                    setState(() {
                      _visitorTime = "${time.hour}:${time.minute}";
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.id);
                },
              ),
            ],
          ),
          SizedBox(
            height: 24.0,
          ),
          ButtonTheme(
            height: 50.0,
            minWidth: double.infinity,
            child: RaisedButton(
              color: Color(0xFFD81B60),
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Daftar',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
              onPressed: () async {
                if (_formKey.currentState.validate() &&
                    _visitorService != null) {
                  isLoading = true;

                  setState(() {
                    if (_visitorService == 'G. Dokter Gigi') {
                      _ticketCode = 'latest_ticket_g';
                    } else if (_visitorService == 'U. Dokter Umum') {
                      _ticketCode = 'latest_ticket_u';
                    } else if (_visitorService == 'R. Ronsen') {
                      _ticketCode = 'latest_ticket_r';
                    } else if (_visitorService == 'M. Spesialis Mata') {
                      _ticketCode = 'latest_ticket_m';
                    } else {
                      _ticketCode = 'latest_ticket_pd';
                    }
                  });

                  await Firestore.instance
                      .collection('ticket_number')
                      .document(_ticketCode)
                      .get()
                      .then((value) {
                    setState(() {
                      _visitorTicketNumber = value.data['ticket'] + 1;
                    });
                  });

                  String finalTicket;

                  if (_visitorTicketNumber.toString().length == 1) {
                    finalTicket =
                        "${_visitorService.split('.')[0]}00$_visitorTicketNumber";
                  } else if (_visitorTicketNumber.toString().length == 2) {
                    finalTicket =
                        "${_visitorService.split('.')[0]}0$_visitorTicketNumber";
                  } else {
                    finalTicket =
                        "${_visitorService.split('.')[0]}$_visitorTicketNumber";
                  }

                  var result =
                      await DatabaseService(uid: await AuthService().getUser())
                          .updateQueueData(
                    DatabaseService().outsideQueueRef,
                    finalTicket,
                    _visitorService,
                    _visitorTime,
                  );

                  if (result != null) {
                    setState(() {
                      isLoading = false;
                    });
                  }

                  await DatabaseService()
                      .updateTicketNumber(_ticketCode, _visitorTicketNumber);
                } else {
                  Fluttertoast.showToast(
                      msg:
                          'Tolong pilih service untuk mendapatkan nomor antrian',
                      toastLength: Toast.LENGTH_SHORT);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      key: _formKey,
    );
  }
}

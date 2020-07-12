import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yu_ngantri_medic_user/models/doctor.dart';
import 'package:yu_ngantri_medic_user/models/queue.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection of users
  final CollectionReference users = Firestore.instance.collection('users');

  // collection outside queue
  final CollectionReference outsideQueueRef =
      Firestore.instance.collection('outside_queue');

  // query outside queue
  final Query outsideQueueQuery =
      Firestore.instance.collection('outside_queue').orderBy('date');

  // query for service G (Dokter Gigi)
  final Query outsideQueryG = Firestore.instance
      .collection('outside_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'G. Dokter Gigi');

  // query for service U (Dokter Umum)
  final Query outsideQueryU = Firestore.instance
      .collection('outside_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'U. Dokter Umum');

  // query for service R (Ronsen)
  final Query outsideQueryR = Firestore.instance
      .collection('outside_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'R. Ronsen');

  // query for service M (Spesialis Mata)
  final Query outsideQueryM = Firestore.instance
      .collection('outside_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'M. Spesialis Mata');

  // query for service PD (Spesialis Penyakit Dalam)
  final Query outsideQueryPD = Firestore.instance
      .collection('outside_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'PD. Spesialis Penyakit Dalam');

  // collection waiting room queue
  final CollectionReference waitingQueueRef =
      Firestore.instance.collection('waiting_room_queue');

  // query for waiting room queue
  final Query waitingQueueQuery =
      Firestore.instance.collection('waiting_room_queue').orderBy('date');

  // query for waiting room queue G (Dokter Gigi)
  final Query waitingQueryG = Firestore.instance
      .collection('waiting_room_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'G. Dokter Gigi');

  // query for waiting room queue U (Dokter Umum)
  final Query waitingQueryU = Firestore.instance
      .collection('waiting_room_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'U. Dokter Umum');

  // query for waiting room queue R (Ronsen)
  final Query waitingQueryR = Firestore.instance
      .collection('waiting_room_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'R. Ronsen');

  // query for waiting room queue M (Dokter Spesialis Mata)
  final Query waitingQueryM = Firestore.instance
      .collection('waiting_room_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'M. Spesialis Mata');

  // query for waiting room queue PD (Dokter Spesialis Penyakit Dalam)
  final Query waitingQueryPD = Firestore.instance
      .collection('waiting_room_queue')
      .orderBy('date')
      .where('service', isEqualTo: 'PD. Spesialis Penyakit Dalam');

  // collection reference 'ticket_number'
  final CollectionReference ticketNumberCollection =
      Firestore.instance.collection('ticket_number');

  // collection reference available doctor
  final CollectionReference availableDoctors =
      Firestore.instance.collection('available_doctor');

  // update user data
  Future updateUserData(String email, String deviceToken) async {
    return await users.document(uid).setData({
      'id': uid,
      'email': email,
      'device_token': deviceToken,
    });
  }

  // update queue data
  Future updateQueueData(CollectionReference ref, String ticketNumber,
      String service, String date) async {
    return await ref.document(uid).setData({
      'id': uid,
      'ticket_number': ticketNumber,
      'service': service,
      'date': date,
    });
  }

  // handle ticket number update
  Future updateTicketNumber(String ticketCode, int newTicketNumber) async {
    return await ticketNumberCollection.document(ticketCode).setData({
      'ticket': newTicketNumber,
    });
  }

  // queue list from snapshot
  List<Queue> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Queue(
        id: doc.data['id'] ?? '',
        ticket: doc.data['ticket_number'] ?? '',
        service: doc.data['service'] ?? '',
        date: doc.data['date'] ?? '',
      );
    }).toList();
  }

  List<Doctor> _brewDoctorListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Doctor(
        id: doc.data['id'] ?? '',
        name: doc.data['name'] ?? '',
        division: doc.data['division'] ?? '',
        schedule: doc.data['schedule'] ?? '',
      );
    }).toList();
  }

  // get outside queue stream
  Stream<List<Queue>> get outsideQueues {
    return outsideQueueQuery.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get outsideQueuesG {
    return outsideQueryG.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get outsideQueuesU {
    return outsideQueryU.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get outsideQueuesR {
    return outsideQueryR.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get outsideQueuesM {
    return outsideQueryM.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get outsideQueuesPD {
    return outsideQueryPD.snapshots().map(_brewListFromSnapshot);
  }

  // get waiting queue stream
  Stream<List<Queue>> get waitingQueues {
    return waitingQueueQuery.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get waitingQueuesG {
    return waitingQueryG.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get waitingQueuesU {
    return waitingQueryU.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get waitingQueuesR {
    return waitingQueryR.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get waitingQueuesM {
    return waitingQueryM.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Queue>> get waitingQueuesPD {
    return waitingQueryPD.snapshots().map(_brewListFromSnapshot);
  }

  // get available doctor stream
  Stream<List<Doctor>> get availableDoctor {
    return availableDoctors.snapshots().map(_brewDoctorListFromSnapshot);
  }
}

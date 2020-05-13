import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

final Firestore _firestore = Firestore.instance;

class Fire {
  ///
  ///
  ///                              Create an Account
  ///
  ///

  void createAccount(String userUid, String email) {
    _firestore.collection('user data').document(userUid).setData(
      {
        'email': email,
      },
    );
  }

  ///
  ///
  ///                                Create an Event
  ///
  ///

  void createEvent(
      {String eventName, String uid, String host, String familyNameForEvent}) {
    var _randomString = randomAlphaNumeric(20);

    _firestore
        .collection("user data")
        .document(uid)
        .collection('my events')
        .document(_randomString)
        .setData(
      {
        'event name': eventName,
        'host': host,
        'creation date': 'creation date',
      },
    );

    _firestore.collection('events').document(_randomString).setData(
      {
        'event name': eventName,
        'host': host,
        'creation date': 'creation date',
      },
    );

    createFamilyInEvent(
        uid: uid,
        eventId: _randomString,
        familyName: familyNameForEvent,
        host: host);
    // _randomString here is the event id

    setSelectedEvent(uid, _randomString);
  }

  void createFamilyInEvent(
      {String uid, String eventId, String familyName, String host}) {
    _firestore
        .collection("events")
        .document(eventId)
        .collection('event members')
        .document(uid)
        .setData(
      {
        'family name': familyName,
        'host': host,
        'members': 0,
        'gifts': 0,
      },
    );
  }

  void setSelectedEvent(String uid, String eventId) {
    _firestore.collection("user data").document(uid).updateData(
      {
        'selected event': eventId,
      },
    );
  }

  ///
  ///
  ///                            Remove Event
  ///
  ///

  void deleteEvent(String uid, String eventId) async {
    _firestore
        .collection('user data')
        .document(uid)
        .collection('my events')
        .document(eventId)
        .delete();

    _firestore.collection('events').document(eventId).delete();

    String _selectedEvent = await _firestore
        .collection('user data')
        .document(uid)
        .get()
        .then((docSnapshot) => docSnapshot.data['selected event'].toString());

    if (_selectedEvent == eventId) {
      // sets the selected event to nothing
      setSelectedEvent(uid, '');
    }
  }

  ///
  ///
  ///                                            Add a member to event
  ///
  ///

  void addDependantMember({String memberName, String uid, String eventId}) {
    _firestore
        .collection('events')
        .document(eventId)
        .collection('event members')
        .document(uid)
        .collection('family members')
        .document(memberName)
        .setData(
      {
        'linked': '',
        'member type': 'dependant member',
      },
    );

    //               transaction updates the count of total members in family

    final DocumentReference postRef = Firestore.instance
        .collection('events')
        .document(eventId)
        .collection('event members')
        .document(uid);
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{
          'total family members': postSnapshot.data['total family members'] + 1
        });
      }
    });
  }

  ///
  ///
  ///                                       remove a member
  ///
  ///

  void deleteDependantMember({String memberName, String uid, String eventId}) {
    _firestore
        .collection('events')
        .document(eventId)
        .collection('event members')
        .document(uid)
        .collection('family members')
        .document(memberName)
        .delete();

    //                                 transaction is called up update the amount of family members

    final DocumentReference postRef = Firestore.instance
        .collection('events')
        .document(eventId)
        .collection('event members')
        .document(uid);
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{
          'total family members': postSnapshot.data['total family members'] - 1
        });
      }
    });
  }
}

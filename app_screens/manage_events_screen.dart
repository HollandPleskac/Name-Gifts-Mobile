import 'package:flutter/material.dart';
import 'package:name_gifts_v2/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/fire.dart';

final _fire = Fire();
final Firestore _firestore = Firestore.instance;

class ManageEventsScreen extends StatefulWidget {
  @override
  _ManageEventsScreenState createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  TextEditingController _displayNameForEventController =
      TextEditingController();
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _inviteController = TextEditingController();

  String uid;
  String selectedEventID;
  String selectedEventName = '';
  String isUserEvents = 'loading';

  Future getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userUid = prefs.getString('uid');

    uid = userUid;
    print(uid);
  }

  Future getSelectedEventID() async {
    String eventID = await _firestore
        .collection("user data")
        .document(uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.data['selected event']);
    selectedEventID = eventID;
    print(selectedEventID);
  }

  Future getSelectedEventName() async {
    try{
    String selEventName = await _firestore
        .collection('user data')
        .document(uid)
        .collection('my events')
        .document(selectedEventID)
        .get()
        .then(
          (docSnap) => docSnap.data['event name'],
        );

    selectedEventName = selEventName;
    print(selectedEventName);
    } catch(e) {
      selectedEventName = 'No selected event';
    }
  }

  Future checkUsersEvents(memberUid) async {
    try {
      String data = await _firestore
          .collection("user data")
          .document(uid)
          .collection('my events')
          .getDocuments()
          .then(
            (value) => value.documents[0].documentID.toString(),
          );
      if (data == null) {
        isUserEvents = null;
      } else {
        isUserEvents = 'true';
      }
    } catch (_) {
      isUserEvents = null;
    }

    // value is a query snapshot of documents
  }

  @override
  void initState() {
    getUid().then((_) {
      print("got uid");
      getSelectedEventID().then((_) {
        print("got selected event name");
        getSelectedEventName().then(
          (_) {
            print('got the selected event id');
            checkUsersEvents(uid).then(
              (_) {
                print('checked for user events');
                setState(() {});
              },
            );
          },
        );
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: SClipper(),
              child: Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3383CD),
                      Color(0xFF11249F),
                    ],
                  ),
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage(
                      "assets/images/virus.png",
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          // SvgPicture.asset(
                          //   'assets/icons/Drcorona.svg',
                          //   width: 210,
                          //   fit: BoxFit.fitWidth,
                          //   alignment: Alignment.topCenter,
                          // ),
                          Positioned(
                            top: 75,
                            right: 60,
                            child: Wrap(
                              children: <Widget>[
                                Text(
                                  'Manage Events',
                                  style: kHeadingTextStyle.copyWith(
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(), // dont know why this works ??
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: selectedEvent(context, selectedEventName),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            topBar(
              context,
              _eventNameController,
              _displayNameForEventController,
              _inviteController,
              selectedEventName,
              uid,
            ),
            SizedBox(
              height: 20,
            ),

            ///
            ///
            ///
            Container(
              height: 230,
              child: isUserEvents == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(),
                          Text('You have no events'),
                          Text('Your events will be displayed here'),
                          Container(),
                        ],
                      ),
                    )
                  : StreamBuilder(
                      stream: _firestore
                          .collection("user data")
                          .document(uid)
                          .collection('my events')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');

                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          default:
                            return Center(
                              child: ListView(
                                children: snapshot.data.documents.map(
                                  (DocumentSnapshot document) {
                                    return event(
                                      context,
                                      document['event name'],
                                      document['creation date'],
                                      uid,
                                      selectedEventID,
                                    );
                                  },
                                ).toList(),
                              ),
                            );
                        }
                      },
                    ),
            ),

            ///
            ///
            ///
            // Container(
            //   height: 350,
            //   child: ListView(
            //     physics: BouncingScrollPhysics(),
            //     children: <Widget>[
            //       event(context),
            //       event(context),
            //       event(context),
            //       event(context),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class SClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 230);
    var firstControlPoint = new Offset(size.width / 4, size.height - 230);
    var firstEndPoint = new Offset(size.width / 2, size.height - 180);
    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height - 120);
    var secondEndPoint = new Offset(size.width, size.height - 120);

    // var firstControlPoint = new Offset(size.width / 4, size.height - 120);
    // var firstEndPoint = new Offset(size.width / 2, size.height - 180);
    // var secondControlPoint =
    //     new Offset(size.width - (size.width / 4), size.height - 235);
    // var secondEndPoint = new Offset(size.width, size.height - 230);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Widget event(
  BuildContext context,
  String eventName,
  String creationDate,
  String uid,
  String selectedEventId,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width * 0.92,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                kPrimaryColor,
                Color.fromRGBO(42, 61, 243, 1).withOpacity(0.9),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    eventTitleText(context, eventName),
                    SizedBox(
                      height: 10,
                    ),
                    eventSubText(context, creationDate),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 35),
                child: eventDelete(
                  context,
                  uid,
                  selectedEventId,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget eventTitleText(BuildContext context, String eventName) {
  return Text(
    eventName,
    style: kHeadingTextStyle.copyWith(color: Colors.white, fontSize: 18),
  );
}

Widget eventSubText(BuildContext context, String creationDate) {
  return Text(
    creationDate,
    style: kSubTextStyle.copyWith(
      color: Colors.white,
      fontSize: 15,
    ),
  );
}

Widget eventDelete(BuildContext context, String uid, String eventId) {
  return IconButton(
    onPressed: () {
      _fire.deleteEvent(uid, eventId);
    },
    icon: Icon(
      Icons.delete_forever,
      color: Colors.white,
      size: 28,
    ),
  );
}

Widget displayNameInput({
  BuildContext context,
  TextEditingController controller,
  Icon icon,
  String hintText,
}) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        style: kSubTextStyle,
        autofocus: false,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: kSubTextStyle,
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            hintText: hintText,
            icon: icon),
        // dont need a validator - solving the issue is done in the return from the sign in function
      ),
    ),
  );
}

Widget topBar(
  BuildContext context,
  TextEditingController _eventNameController,
  TextEditingController _displayNameForEventController,
  TextEditingController _inviteController,
  String selectedEventName,
  String uid,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      topBarButton(
        context,
        'Create Event',
        () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  'Create an Event',
                  style: kHeadingTextStyle,
                ),
                content: Container(
                  height: 150,
                  child: Column(
                    children: <Widget>[
                      displayNameInput(
                        context: context,
                        controller: _eventNameController,
                        icon: Icon(
                          Icons.near_me,
                          color: kPrimaryColor,
                        ),
                        hintText: 'name of the event',
                      ),
                      displayNameInput(
                        context: context,
                        controller: _displayNameForEventController,
                        icon: Icon(
                          Icons.event_note,
                          color: kPrimaryColor,
                        ),
                        hintText: 'your name in the new event',
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            color: kPrimaryColor,
                            onPressed: () {
                              _fire.createEvent(
                                uid: uid,
                                eventName: _eventNameController.text,
                                familyNameForEvent:
                                    _displayNameForEventController.text,
                                host: 'hollandpleskac@gmail.com',
                              );
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Create',
                              style: kSubTextStyle.copyWith(
                                  color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      topBarButton(
        context,
        'Invite',
        () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Invite to :\n",
                        style: kHeadingTextStyle.copyWith(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: selectedEventName,
                        style: kHeadingTextStyle.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      displayNameInput(
                        context: context,
                        controller: _inviteController,
                        icon: Icon(
                          Icons.email,
                          color: kPrimaryColor,
                        ),
                        hintText: 'email of recipient',
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            color: kPrimaryColor,
                            onPressed: () {
                              //fire invite member
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Invite',
                              style: kSubTextStyle.copyWith(
                                  color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ],
  );
}

Widget topBarButton(
    BuildContext context, String buttonTitle, Function onPressFunction) {
  return InkWell(
    child: Container(
      height: 40,
      width: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromRGBO(42, 61, 243, 1).withOpacity(0.9)),
      child: Center(
        child: Text(
          buttonTitle,
          style: kSubTextStyle.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    ),
    onTap: onPressFunction,
  );
}

Widget selectedEvent(BuildContext context, selectedEvent) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Selected Event",
        style: kTitleTextstyle.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 28,
        ),
      ),
      Text(
        selectedEvent,
        style: kTitleTextstyle.copyWith(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

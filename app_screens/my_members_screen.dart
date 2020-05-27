import 'package:flutter/material.dart';
import 'package:name_gifts_v2/constant.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/fire.dart';

final _fire = Fire();

final Firestore _firestore = Firestore();

class MyMembersScreen extends StatefulWidget {
  @override
  _MyMembersScreenState createState() => _MyMembersScreenState();
}

class _MyMembersScreenState extends State<MyMembersScreen> {
  TextEditingController _memberNameController = TextEditingController();

  String uid;
  String selectedEventID;
  String selectedEventName = ' ';
  String isMembersData = 'loading';
  String familyName;

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
    try {
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
    } catch (e) {
      selectedEventName = 'No Selected Event';
    }
  }

  Future checkMembersData(eventId, memberUid) async {
    try {
      String data = await _firestore
          .collection("events")
          .document(eventId)
          .collection('event members')
          .document(memberUid)
          .collection('family members')
          .getDocuments()
          .then(
            (value) => value.documents[0].documentID.toString(),
          );
      if (data == null) {
        isMembersData = null;
      } else {
        isMembersData = 'true';
      }
    } catch (_) {
      isMembersData = null;
    }

    // value is a query snapshot of documents
  }

  Future getFamilyName(String eventID, String uid) async {
    try {
      String famName = await _firestore
          .collection("events")
          .document(eventID)
          .collection("event members")
          .document(uid)
          .get()
          .then(
            (docSnap) => docSnap.data['family name'],
          );
      familyName = famName;
    } catch (e) {
      familyName = '!@##56765@#asdfsd#@#No Fam Name@#7568@#@adsfsd#%@#%)(*&';
    }
  }

  @override
  void initState() {
    getUid().then((_) {
      print("got uid");
      getSelectedEventID().then((_) {
        print("got selected event id");
        getSelectedEventName().then(
          (_) {
            print('got the selected event name');
            checkMembersData(selectedEventID, uid).then(
              (_) {
                print('checked member data');
                getFamilyName(selectedEventID, uid).then(
                  (_) {
                    print('got family name');
                    setState(() {});
                  },
                );
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
                height: MediaQuery.of(context).size.height * 0.4,
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
                    SizedBox(height: 90),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.035,
                              ),
                              child: Text(
                                selectedEventName == 'No Selected Event'
                                    ? 'My Members'
                                    : familyName == null
                                        ? ''
                                        : familyName.toString() + '\'s Members',
                                style: kHeadingTextStyle.copyWith(
                                    color: Colors.white),
                              ),
                            ),
                          ),
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
            MemberOptionBar(
              uid: uid,
              memberNameController: _memberNameController,
              selectedEventID: selectedEventID,
              updateScreenFunction: () => getUid().then((_) {
                print("got uid");
                getSelectedEventID().then((_) {
                  print("got selected event id");
                  getSelectedEventName().then(
                    (_) {
                      print('got the selected event name');
                      checkMembersData(selectedEventID, uid).then(
                        (_) {
                          print('checked member data');
                          getFamilyName(selectedEventID, uid).then(
                            (_) {
                              print('got family name');
                              setState(() {});
                            },
                          );
                        },
                      );
                    },
                  );
                });
              }),
            ),
            SizedBox(
              height: 20,
            ),

            ///
            ///
            ///

            Container(
              height: 325,
              child: isMembersData == null && selectedEventID != 'no event'
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(),
                          Container(),
                          Text(
                              'When you add or invite members, they will be visible here'),
                          Text('Remember to add yourself'),
                          Container(),
                          Container(),
                        ],
                      ),
                    )
                  : selectedEventID == 'no event'
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(),
                              Container(),
                              Text(
                                  'You must create an event first to add or invite members'),
                              Container(),
                              Container(),
                            ],
                          ),
                        )
                      : StreamBuilder(
                          stream: _firestore
                              .collection("events")
                              .document(selectedEventID)
                              .collection('event members')
                              .document(uid)
                              .collection('family members')
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
                                        return Member(
                                          memberName: document.documentID,
                                          memberType: document['member type'],
                                          uid: uid,
                                          selectedEventID: selectedEventID,
                                          updateScreenFunction: () =>
                                              getUid().then((_) {
                                            getSelectedEventID().then((_) {
                                              getSelectedEventName().then(
                                                (_) {
                                                  checkMembersData(
                                                          selectedEventID, uid)
                                                      .then(
                                                    (_) {
                                                      getFamilyName(
                                                              selectedEventID,
                                                              uid)
                                                          .then(
                                                        (_) {
                                                          setState(() {});
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            });
                                          }),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                );
                            }
                          },
                        ),
            ),
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
    path.lineTo(0, size.height - 80);
    var firstControlPoint = new Offset(size.width / 4, size.height - 120);
    var firstEndPoint = new Offset(size.width / 2, size.height - 90);
    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height - 50);
    var secondEndPoint = new Offset(size.width, size.height - 80);

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

class Member extends StatelessWidget {
  final String memberName;
  final String memberType;
  final String uid;
  final String selectedEventID;
  final Function updateScreenFunction;

  Member({
    this.memberName,
    this.memberType,
    this.uid,
    this.selectedEventID,
    @required this.updateScreenFunction,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Card(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 45,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        hexagon(context),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(),
                            memberNameText(context, memberName),
                            memberTypeText(context, memberType),
                            Container(),
                            // containers are here to make memberNameText and memberTypeText go nearer to each other
                          ],
                        ),
                      ],
                    ),
                    memberDelete(
                      context,
                      memberName,
                      uid,
                      selectedEventID,
                      () => updateScreenFunction(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget hexagon(BuildContext context) {
  return Container(
    width: 60,
    child: ClipPolygon(
      sides: 6,
      borderRadius: 5.0, // Default 0.0 degrees
      rotate: 0.0, // Default 0.0 degrees
      // boxShadows: [
      //   PolygonBoxShadow(color: Colors.black, elevation: 1.0),
      //   PolygonBoxShadow(color: Colors.grey, elevation: 5.0)
      // ],
      child: Container(
        color: kPrimaryColor,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 25,
        ),
      ),
    ),
  );
}

Widget memberNameText(BuildContext context, String memberName) {
  return Text(
    memberName,
    style: kHeadingTextStyle.copyWith(
      fontSize: 20,
      color: kPrimaryColor,
    ),
  );
}

Widget memberTypeText(BuildContext context, String memberType) {
  return Text(
    memberType,
    style: kSubTextStyle.copyWith(
      fontSize: 15,
    ),
  );
}

class MemberDelete extends StatelessWidget {
  final String memberName;
  final String uid;
  final String selectedEventID;
  final Function updateScreenFunction;

  MemberDelete({
    @required this.memberName,
    @required this.uid,
    @required this.selectedEventID,
    @required this.updateScreenFunction,
  });
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Widget memberDelete(
  BuildContext context,
  String memberName,
  String uid,
  String selectedEventID,
  Function updateScreenFunction,
) {
  return Padding(
    padding: const EdgeInsets.only(right: 20),
    child: IconButton(
      icon: Icon(
        Icons.delete_outline,
        color: kRedColor,
        size: 30,
      ),
      onPressed: () {
        _fire.deleteDependantMember(
            uid: uid, eventId: selectedEventID, memberName: memberName);
        updateScreenFunction();
      },
    ),
  );
}

Widget memberNameInput({
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

class MemberOptionBar extends StatefulWidget {
  final TextEditingController memberNameController;
  final String uid;
  final String selectedEventID;
  final updateScreenFunction;
  MemberOptionBar({
    this.memberNameController,
    this.uid,
    this.selectedEventID,
    @required this.updateScreenFunction,
  });

  @override
  _MemberOptionBarState createState() => _MemberOptionBarState();
}

class _MemberOptionBarState extends State<MemberOptionBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MemberOptionButton(
          buttonTitle: 'Add Member',
          onPressFunction: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  'Add a member',
                  style: kHeadingTextStyle,
                ),
                content: Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      memberNameInput(
                        context: context,
                        controller: widget.memberNameController,
                        icon: Icon(
                          Icons.person_add,
                          color: kPrimaryColor,
                        ),
                        hintText: 'member name',
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
                              _fire.addDependantMember(
                                uid: widget.uid,
                                eventId: widget.selectedEventID,
                                memberName: widget.memberNameController.text,
                              );

                              Navigator.pop(context);

                              //update screen after pop
                              widget.updateScreenFunction();
                            },
                            child: Text(
                              'Add',
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
          ),
          eventId: widget.selectedEventID,
        ),
        MemberOptionButton(
          buttonTitle: 'Invite Collaborator',
          onPressFunction: () {},
          eventId: widget.selectedEventID,
        ),
      ],
    );
  }
}

class MemberOptionButton extends StatelessWidget {
  final String buttonTitle;
  final Function onPressFunction;
  final String eventId;

  MemberOptionButton({
    this.buttonTitle,
    this.onPressFunction,
    this.eventId,
  });
  @override
  Widget build(BuildContext context) {
    return eventId == null
        ? Container()
        : InkWell(
            child: Container(
              height: 40,
              width: 160,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: eventId == 'no selected event' || eventId == ''
                      ? Colors.grey
                      : Color.fromRGBO(42, 61, 243, 1).withOpacity(0.9)),
              child: Center(
                child: Text(
                  buttonTitle,
                  style: kSubTextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onTap: eventId == 'no selected event' || eventId == ''
                ? () {}
                : onPressFunction,
          );
  }
}

Widget selectedEvent(BuildContext context, String selectedEventName) {
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
        selectedEventName == ''
            ? 'No selected event'
            : selectedEventName,
        style: kTitleTextstyle.copyWith(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

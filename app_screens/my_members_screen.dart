import 'package:flutter/material.dart';
import 'package:name_gifts_v2/constant.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../logic/fire.dart';

final _fire = Fire();

final Firestore _firestore = Firestore();

class MyMembersScreen extends StatefulWidget {
  @override
  _MyMembersScreenState createState() => _MyMembersScreenState();
}

class _MyMembersScreenState extends State<MyMembersScreen> {
  TextEditingController _memberNameController = TextEditingController();
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
                            left: 110,
                            child: Wrap(
                              children: <Widget>[
                                Text(
                                  'My Members',
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

            ///
            ///
            ///

            Container(
              height: 320,
              child: StreamBuilder(
                stream: _firestore
                    .collection("events")
                    .document('FS2N1B12Q1Fs3GURMUA0')
                    .collection('event members')
                    .document('HpVdivf2z7MRwu4nppw8m6CVTpp1')
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
                              return member(context, document.documentID,document['member type']);
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
            //   height: 320,
            //   child: ListView(
            //     physics: BouncingScrollPhysics(),
            //     children: <Widget>[
            //       member(context),
            //       member(context),
            //       member(context),
            //       member(context),
            //       member(context),
            //       member(context),
            //       member(context),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          backgroundColor: kRedColor,
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
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
                          controller: _memberNameController,
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
                                  uid: 'HpVdivf2z7MRwu4nppw8m6CVTpp1',
                                  eventId: 'FS2N1B12Q1Fs3GURMUA0',
                                  memberName: _memberNameController.text,
                                );
                                Navigator.pop(context);
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
            );
          },
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
    var firstEndPoint = new Offset(size.width / 2, size.height - 180);
    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height - 235);
    var secondEndPoint = new Offset(size.width, size.height - 230);

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

Widget member(BuildContext context, String memberName,String memberType) {
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
                          memberNameText(context,memberName),
                          memberTypeText(context,memberType),
                          Container(),
                          // containers are here to make memberNameText and memberTypeText go nearer to each other
                        ],
                      ),
                    ],
                  ),
                  memberDelete(context, memberName),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
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

Widget memberNameText(BuildContext context,String memberName) {
  return Text(
    memberName,
    style: kHeadingTextStyle.copyWith(
      fontSize: 20,
      color: kPrimaryColor,
    ),
  );
}

Widget memberTypeText(BuildContext context,String memberType) {
  return Text(
    memberType,
    style: kSubTextStyle.copyWith(
      fontSize: 15,
    ),
  );
}

Widget memberDelete(BuildContext context, String memberName) {
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
            uid: 'HpVdivf2z7MRwu4nppw8m6CVTpp1',
            eventId: 'FS2N1B12Q1Fs3GURMUA0',
            memberName: memberName);
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

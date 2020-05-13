import 'package:flutter/material.dart';
import 'package:name_gifts_v2/constant.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

import '../logic/fire.dart';

final _fire = Fire();

class MyMembersScreen extends StatefulWidget {
  @override
  _MyMembersScreenState createState() => _MyMembersScreenState();
}

class _MyMembersScreenState extends State<MyMembersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          Container(
            height: 320,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                member(context),
                member(context),
                member(context),
                member(context),
                member(context),
                member(context),
                member(context),
              ],
            ),
          ),
        ],
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
            print('adding a member now');
            _fire
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

Widget member(BuildContext context) {
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
                          memberNameText(context),
                          memberTypeText(context),
                          Container(),
                          // containers are here to make memberNameText and memberTypeText go nearer to each other
                        ],
                      ),
                    ],
                  ),
                  memberDelete(context),
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

Widget memberNameText(BuildContext context) {
  return Text(
    'Holland Pleskac',
    style: kHeadingTextStyle.copyWith(
      fontSize: 20,
      color: kPrimaryColor,
    ),
  );
}

Widget memberTypeText(BuildContext context) {
  return Text(
    'Verified User',
    style: kSubTextStyle.copyWith(
      fontSize: 15,
    ),
  );
}

Widget memberDelete(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(right: 20),
    child: IconButton(
      icon: Icon(
        Icons.delete_outline,
        color: kRedColor,
        size: 30,
      ),
      onPressed: () {},
    ),
  );
}

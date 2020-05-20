import 'package:flutter/material.dart';
import 'package:name_gifts_v2/constant.dart';

import '../constant.dart';

class InvitationScreen extends StatefulWidget {
  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ClipPath(
            clipper: SClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height*0.4,
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
                  alignment: Alignment.topLeft,
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
                                'My Invitations',
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
            height: 300,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
                invitation(context),
              ],
            ),
          )
        ],
      ),
    );
  }
}



class SClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 120);
    var firstControlPoint = new Offset(size.width / 4, size.height - 120);
    var firstEndPoint = new Offset(size.width / 2, size.height - 170);
    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height - 220);
    var secondEndPoint = new Offset(size.width, size.height - 160);

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

Widget invitation(BuildContext context) {
  return Container(
    height: 200,
    margin: EdgeInsets.only(
      bottom: 30,
      left: 15,
      right: 15,
    ),
    width: MediaQuery.of(context).size.width * 0.9,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 10,
          child: invitationCard(context),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 3,
          child: invitationActions(context),
        ),
      ],
    ),
  );
}

Widget invitationCard(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Text(
          'Saturday, 22 Feb 2020',
          style: kSubTextStyle.copyWith(fontSize: 18),
        ),
      ),
      Container(
        height: 160,
        width: double.infinity,
        child: Card(
          elevation: 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.insert_invitation,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'event invitation',
                    style: kHeadingTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.email,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'hollandpleskac@gmail.com',
                    style: kHeadingTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ],
  );
}

Widget invitationActions(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Container(
        height: 160,
        width: double.infinity,
        child: Card(
          color: kPrimaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    ],
  );
}
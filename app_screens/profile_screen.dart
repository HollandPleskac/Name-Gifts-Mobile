import 'package:flutter/material.dart';

import '../constant.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                  alignment: Alignment.topRight,
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
                          left: 130,
                          child: Wrap(
                            children: <Widget>[
                              Text(
                                'Profile',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              accountSignOut(context),
              accountDelete(context),
            ],
          ),
        ],
      ),
    );
  }
}

class SClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 160);
    var firstControlPoint = new Offset(size.width / 4, size.height - 103);
    var firstEndPoint = new Offset(size.width / 2, size.height - 170);
    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height - 240);
    var secondEndPoint = new Offset(size.width, size.height - 220);

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

Widget accountDelete(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.4,
    height: 60,
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: kRedColor,
      child: Text(
        'Delete Account',
        style: kSubTextStyle.copyWith(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {},
    ),
  );
}

Widget accountSignOut(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.4,
    height: 60,
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: kGreenColor,
      child: Text(
        'Sign Out',
        style: kSubTextStyle.copyWith(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {},
    ),
  );
}

Widget viewEmail(BuildContext context) {
  return Text(
    'hollandpleskac@gmail.com',
    style: kHeadingTextStyle.copyWith(fontSize: 26),
  );
}

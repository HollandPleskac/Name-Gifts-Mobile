import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import './sign_up_screen.dart';
import '../logic/auth.dart';
import '../tab_page.dart';

final _auth = Auth();

final Firestore _firestore = Firestore.instance;

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  var errorMessage = '';

  void login() async {
    ///
    ///
    void setUid(String uidValue) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'uid',
        uidValue,
      );
    }

    void setSelectedEventId(String selectedEventId) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(
        'selected event id',
        selectedEventId,
      );
    }

    void setSelectedEventName(
        String uid, String eventId, String eventName) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(
        'selected event name',
        eventName,
      );
    }

    //
    //
    List authPackage = await _auth.signIn(
      context,
      _emailController.text,
      _passwordController.text,
    );

    //authPackage[0] is either success or contains the error message
    //authPackage[1] is either the user uid or null

    if (authPackage[0] == 'success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // sets the uid - authPackage[1] is the uid
      setUid(authPackage[1]);

      String uid = prefs.getString('uid');

      String selectedEventId =
          await _firestore.collection('user data').document(uid).get().then(
                (docSnapShot) => docSnapShot.data['selected event'],
              );

      // sets the selected event id
      setSelectedEventId(selectedEventId);

      String selectedEventName = await _firestore
          .collection('user data')
          .document(uid)
          .collection('my events')
          .document(selectedEventId)
          .get()
          .then((docSnap) => docSnap.data['event name']);

      //sets the selected event name
      setSelectedEventName(uid, selectedEventId, selectedEventName);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabPage(),
        ),
      );
    } else {
      setState(() {
        errorMessage = authPackage[0];
      });
      print('authPack of 1  ' + authPackage[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              signInText(context),
              SizedBox(
                height: 40,
              ),
              Hero(
                tag: 'dash',
                child: Container(
                  width: 200,
                  child: Image.asset('assets/images/gift.png'),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              signInInput(
                context: context,
                controller: _emailController,
                hintText: 'email',
                icon: Icon(
                  Icons.email,
                  color: kPrimaryColor,
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(
                height: 25,
              ),
              signInInput(
                context: context,
                controller: _passwordController,
                hintText: 'password',
                icon: Icon(
                  Icons.lock,
                  color: kPrimaryColor,
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(
                height: 8,
              ),
              signInErrorText(context, errorMessage),
              SizedBox(
                height: 8,
              ),
              signInButton(
                context,
                () => login(),
              ),
              SizedBox(
                height: 20,
              ),
              signInAlreadyHaveAccount(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget signInText(BuildContext context) {
  return Text(
    'Name Gifts',
    style: kHeadingTextStyle.copyWith(
      fontWeight: FontWeight.w400,
      color: kPrimaryColor,
      fontSize: 45,
    ),
  );
}

Widget signInInput({
  BuildContext context,
  String hintText,
  Icon icon,
  TextInputType keyboardType,
  TextEditingController controller,
}) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: kPrimaryColor,
          width: 2.25,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: TextFormField(
          controller: controller,
          maxLines: 1,
          keyboardType: keyboardType,
          style: kSubTextStyle.copyWith(color: kPrimaryColor),
          autofocus: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: kSubTextStyle.copyWith(color: kPrimaryColor),
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            hintText: hintText,
            icon: icon,
          ),
          // dont need a validator - solving the issue is done in the return from the sign in function
        ),
      ),
    ),
  );
}

Widget signInButton(
  BuildContext context,
  Function loginFunction,
) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width * 0.6,
    child: FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: kPrimaryColor,
      child: Text(
        'Sign In',
        style: kSubTextStyle.copyWith(color: Colors.white, fontSize: 21),
      ),
      onPressed: loginFunction,
    ),
  );
}

Widget signInAlreadyHaveAccount(BuildContext context) {
  return InkWell(
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Don\'t have an account? ",
            style: kSubTextStyle.copyWith(fontSize: 15.5),
          ),
          TextSpan(
            text: "Sign Up!",
            style: TextStyle(color: kPrimaryColor, fontSize: 16),
          ),
        ],
      ),
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        ),
      );
    },
  );
}

Widget signInErrorText(BuildContext context, String errorMessage) {
  if (errorMessage ==
      'There is no user record corresponding to this identifier. The user may have been deleted.') {
    errorMessage = 'There is no record of this user existing';
  } else if (errorMessage == 'Given String is empty or null') {
    errorMessage = 'Fill out all fields';
  } else if (errorMessage ==
      'The password is invalid or the user does not have a password.') {
    errorMessage = 'Wrong Password';
  }
  return Container(
    child: Text(
      errorMessage,
      style: kErrorTextstyle,
    ),
  );
}

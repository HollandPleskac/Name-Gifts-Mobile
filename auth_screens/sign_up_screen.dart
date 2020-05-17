import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constant.dart';

import './sign_in_screen.dart';
import '../logic/auth.dart';
import '../tab_page.dart';

final _auth = Auth();
final _firestore = Firestore.instance;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  var errorMessage = '';

  void signup() async {
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

    if (_passwordController.text == _passwordConfirmController.text) {
      List authPackage = await _auth.signUp(
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

// sets the selected event id
        try {
          String selectedEventId =
              await _firestore.collection('user data').document(uid).get().then(
                    (docSnapShot) => docSnapShot.data['selected event'],
                  );
          setSelectedEventId(selectedEventId);
        } catch (e) {
          String selectedEventId = 'no selected event id';
          setSelectedEventId(selectedEventId);
        }

        try {
          String selectedEventId = prefs.getString('selected event id');
          String selectedEventName = await _firestore
              .collection('user data')
              .document(uid)
              .collection('my events')
              .document(selectedEventId)
              .get()
              .then((docSnap) => docSnap.data['event name']);
          setSelectedEventName(uid, selectedEventId, selectedEventName);
        } catch (e) {
          String selectedEventId = prefs.getString('selected event id');
          String selectedEventName = 'no selected event name';
          setSelectedEventName(uid, selectedEventId, selectedEventName);
        }

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
        print('error  ' + authPackage[0]);
      }
    } else {
      setState(() {
        errorMessage = 'Password and Confirm Password must be equal';
      });
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
                height: 60,
              ),
              signInText(context),
              SizedBox(
                height: 40,
              ),
              Container(
                width: 200,
                child: Image.asset('assets/images/gift.png'),
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
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
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
                obscureText: true,
              ),
              SizedBox(
                height: 25,
              ),
              signInInput(
                context: context,
                controller: _passwordConfirmController,
                hintText: 'confirm password',
                icon: Icon(
                  Icons.lock,
                  color: kPrimaryColor,
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              SizedBox(
                height: 8,
              ),
              signUpErrorText(context, errorMessage),
              SizedBox(
                height: 8,
              ),
              signInButton(context, () => signup()),
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
  bool obscureText,
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
          obscureText: obscureText,
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

Widget signInButton(BuildContext context, Function signinFunction) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width * 0.6,
    child: FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: kPrimaryColor,
      child: Text(
        'Sign Up',
        style: kSubTextStyle.copyWith(color: Colors.white, fontSize: 21),
      ),
      onPressed: signinFunction,
    ),
  );
}

Widget signInAlreadyHaveAccount(BuildContext context) {
  return InkWell(
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Already have an account? ",
            style: kSubTextStyle.copyWith(fontSize: 15.5),
          ),
          TextSpan(
            text: "Sign In!",
            style: TextStyle(color: kPrimaryColor, fontSize: 16),
          ),
        ],
      ),
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    },
  );
}

Widget signUpErrorText(BuildContext context, String errorMessage) {
  if (errorMessage ==
      'The given password is invalid. [ Password should be at least 6 characters ]') {
    errorMessage = 'Password should be at least 6 characters';
  } else if (errorMessage == 'Given String is empty or null') {
    errorMessage = 'Fill out all fields';
  }
  return Container(
    child: Text(
      errorMessage,
      style: kErrorTextstyle,
    ),
  );
}

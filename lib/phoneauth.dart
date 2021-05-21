import 'package:eliveryday/registerProfile.dart';
import 'package:eliveryday/styledbuttons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebaseCustomServices.dart';

class PhoneAuth extends StatefulWidget {
  final FirebaseAuth _auth;

  PhoneAuth(this._auth);

  @override
  State<StatefulWidget> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String? _verificationId;

  void _showSnackbar(String m) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

// just replace widget._auth.signIn...... with _signInWithCredential

  Future _signInWithCredential(AuthCredential credential) async {
    AuthResult authResult = await widget._auth.signInWithCredential(credential);
    FireStoreService fireStoreService = FireStoreService();
    final user = await widget._auth.currentUser();
    var result = await fireStoreService.checkUserExists(user);

    if (result == false) {
      print("Executed");
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputProfile(
            user.uid,
            _phoneNumberController.text,
          ),
        ),
      );
      result = await fireStoreService.checkUserExists(user);
      if (result == false) {
        widget._auth.signOut();
      }
    }
    return authResult;
  }

  void verifyPhoneNumber() async {
    // Callbacks
    PhoneVerificationCompleted phoneVerificationCompleted =
        (AuthCredential authCredential) async {
      await _signInWithCredential(authCredential);
      final user = await widget._auth.currentUser();
      if (user.phoneNumber != "") {
        _showSnackbar("Verified and Signed in : ${user.uid}");
      }
    };

    PhoneVerificationFailed phoneVerificationFailed =
        (AuthException authException) {
      _showSnackbar(
          "error code: ${authException.code} Message: ${authException.message}");
    };
    PhoneCodeSent phoneCodeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _showSnackbar("Check Phone for Verification Code");
      _verificationId = verificationId;
    };
    PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout =
        (String verificationId) {
      _showSnackbar("Verification code recieved: " + verificationId);
    };

    try {
      await widget._auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: Duration(seconds: 10),
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
      );
    } catch (e) {
      _showSnackbar("Failed with Error code : ${e}");
    }
  }

  void signInPhone() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );

      final FirebaseUser pUser = (await _signInWithCredential(credential)).user;

      _showSnackbar("Successfully signed in UID: ${pUser.uid}");
    } catch (e) {
      _showSnackbar("Failed to sign in : ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextFormField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(
                labelText: 'Phone number (+xx xxx-xxx-xxxx)'),
          ),
          ElevatedButton(
            onPressed: () {
              verifyPhoneNumber();
            },
            child: Text('Verify Number'),
          ),
          TextFormField(
            controller: _smsController,
            decoration: InputDecoration(labelText: 'Verification Code'),
          ),
          ElevatedButton(
            onPressed: () async {
              signInPhone();
            },
            child: Text('Sign In'),
          ),
          signoutButton(context, widget._auth)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _smsController.dispose();
    super.dispose();
  }
}

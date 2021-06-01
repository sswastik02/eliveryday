import 'package:flutter/material.dart';

import 'customUser.dart';
import 'firebaseCustomServices.dart';

class InputProfile extends StatefulWidget {
  String? uid, phoneNumber;
  FireStoreService fireStoreService = FireStoreService();
  InputProfile(this.uid, this.phoneNumber);
  State<StatefulWidget> createState() => _InputProfileState();
}

class _InputProfileState extends State<InputProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool agevalidate = true, namevalidate = true;
  final nameValidCharacters = RegExp(r"^[a-zA-Z]+");
  final ageValidCharacters = RegExp(r'^[0-9]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: namevalidate ? null : "Invalid Input",
            ),
          ),
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(
              labelText: 'Age',
              errorText: agevalidate ? null : "Invalid Input",
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                print(_nameController.text);
                if (_nameController.text.isNotEmpty &&
                    _ageController.text.isNotEmpty &&
                    nameValidCharacters.hasMatch(_nameController.text) &&
                    ageValidCharacters.hasMatch(_ageController.text) &&
                    int.parse(_ageController.text) >= 18) {
                  setState(() {
                    namevalidate = true;
                    agevalidate = true;
                  });
                  User cUser = User(
                    id: widget.uid!,
                    fullName: _nameController.text,
                    age: _ageController.text,
                    phoneNumber: widget.phoneNumber!,
                  );
                  await widget.fireStoreService.createUserProfile(cUser);
                  currentUser = cUser;
                  print('Registered');
                  Navigator.pop(context);
                }
                if (_nameController.text.isEmpty ||
                    !nameValidCharacters.hasMatch(_nameController.text)) {
                  setState(() {
                    namevalidate = false;
                  });
                } else {
                  setState(() {
                    namevalidate = true;
                  });
                }
                if (_ageController.text.isEmpty ||
                    ageValidCharacters.hasMatch(_ageController.text) == false ||
                    int.parse(_ageController.text) < 18) {
                  setState(() {
                    print(int.parse(_ageController.text));
                    agevalidate = false;
                  });
                } else {
                  setState(() {
                    agevalidate = true;
                  });
                }
              },
              child: Text('Submit'))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}

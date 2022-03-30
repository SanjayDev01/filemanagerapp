// ignore_for_file: non_constant_identifier_names

import 'package:filemanagerapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscureText = true;
  String _email = "", _password = "";
  bool _isSubmitting = false;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  final DateTime timestamp = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _showTitle(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showFormActions(),
                  _showSignUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showTitle() {
    return const Text(
      "Login",
      style: TextStyle(
          fontSize: 72, fontWeight: FontWeight.bold, color: Colors.blueGrey),
    );
  }

  _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        onSaved: (val) => _email = val!,
        validator: (val) => !val!.contains("@") ? "Invalid Email" : null,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
            hintText: "Enter Valid Email",
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
      ),
    );
  }

  _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        onSaved: (val) => _password = val!,
        validator: (val) => val!.length < 6 ? "Password Is Too Short" : null,
        obscureText: _obscureText,
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child:
                  Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            ),
            border: const OutlineInputBorder(),
            labelText: "Password",
            hintText: "Enter Valid Password",
            icon: const Icon(
              Icons.lock,
              color: Colors.grey,
            )),
      ),
    );
  }

  _showFormActions() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          _isSubmitting == true
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                )
              : SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    elevation: 8.0,
                    color: Colors.blueGrey,
                    onPressed: _submit,
                  ),
                ),
        ],
      ),
    );
  }

  _submit() {
    final _form = _formKey.currentState;
    if (_form!.validate()) {
      _form.save();
      //print("Email $_email, Password $_password");
      _LoginUser();
    } else {
      print("Form is Invalid");
    }
  }

  _LoginUser() async {
    setState(() {
      _isSubmitting = true;
    });

    final logMessage = await context
        .read<AuthenticationService>()
        .signIn(email: _email, password: _password);

    logMessage == "Signed In"
        ? _showSuccessSnack(logMessage)
        : _showErrorSnack(logMessage);

    //print("I am logMessage $logMessage");

    if (logMessage == "Signed In") {
      return;
    } else {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  _showSignUpOption() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(fontSize: 18),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/signUp");
            },
            child: Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  _showSuccessSnack(String message) async {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        message,
        style: const TextStyle(color: Colors.green),
      ),
    );
    _scaffoldKey.currentState!.showSnackBar(snackbar);
    _formKey.currentState!.reset();
  }

  _showErrorSnack(String message) {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
    _scaffoldKey.currentState!.showSnackBar(snackbar);
    setState(() {
      _isSubmitting = false;
    });
  }
}

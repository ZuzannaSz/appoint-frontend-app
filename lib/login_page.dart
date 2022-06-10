import 'dart:collection';
import 'dart:convert';

import 'package:appoint_webapp/doctor/list_of_appointments.dart';
import 'package:appoint_webapp/secretary/schedule_appointment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/User.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5DB075),
        title: const Text(
          "Login Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignInForm(),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

User user = User();

class _SignInFormState extends State<SignInForm> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  static const SERVER_IP = 'https://pz-backend2022.herokuapp.com';


   signIn() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var userEmail = _emailTextController.text;
    var password = _passwordTextController.text;

    final tokens = json.decode(await attemptLogIn(userEmail, password));
    print(tokens.runtimeType.toString());
    print("User logged in succesfully");
    if (tokens["errorCode"] == null) {
      print("user token: $tokens");
      user.token = tokens['token'];
      user.refreshToken = tokens['refreshToken'];
      user.username = userEmail;

      Map decodedToken = parseJwt(user.token);
      user.role = decodedToken['role'];
      print(decodedToken);
      if(decodedToken['role'] == "administrator"){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ScheduleAppointment(user: user,)));
      }else{
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListOfAppointments(user: user,)));
      }
    } else {
      displayDialog(context, "Incorrect Input", "Please make sure you wrote the correct username and password and try again");

    }
  }
  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  Future<String> attemptLogIn(String email, String password) async {
    print('serverip:$SERVER_IP');
    print('password:$password');
    print('email:$email');
    print(jsonEncode(<String, String>{"login": email, "password": password}));
    var res = await http.post(Uri.parse("$SERVER_IP/api/Auth/Login"),
        body:
            jsonEncode(<String, String>{"login": email, "password": password}),
        headers: <String, String>{"Content-Type": "application/json"});

    print(res.statusCode);
    print(res.body);
    if(res.body.isNotEmpty) {
      return res.body;
    } else
        return "";
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 120,
        ),
        const Text(
          "Log in",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 60,),
        _buildTextField("username"),
        const SizedBox(
          height: 30,
        ),
        _buildPasswordField(),
        const SizedBox(
          height: 60,
        ),
        ElevatedButton(
            onPressed: () {
              signIn();
            },
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 20),
            ),
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(300, 50)),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF5DB075)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ))))
      ],
    );
  }

  _buildTextField(String hintText) {
    return SizedBox(
      width: 300,
      child: Padding(

        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: hintText == "username"?_emailTextController:_passwordTextController,
            decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          hintText: hintText,
        )),
      ),
    );
  }
  _buildPasswordField() {
    return SizedBox(
      width: 300,
      child: Padding(

        padding: const EdgeInsets.all(8.0),
        child: TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            controller: _passwordTextController,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              hintText: "password"
            )),
      ),
    );
  }
}

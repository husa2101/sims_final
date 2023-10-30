import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import './components/textfield.dart';
import './homePge.dart';

class LoginPage extends StatelessWidget {
  // text additing controller
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  LoginPage({super.key});

// finction to check if the user exist
  Future signuser(BuildContext cont) async {
    if (username.text.isEmpty || password.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Both fields cannot be blank",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16,
      );
    } else {
      var url = Uri.parse(
          "http://192.168.1.190/ergoGreaser/database.php"); // sql database
      //var url = Uri.parse("http://localhost/test.php/database.php");   // Azure DB

      try {
        var response = await http.post(url, body: {
          "username": username.text,
          "password": password.text,
        });

        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          //String status = data['status'];

          if (data == 'success') {
            Navigator.push(
              cont,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            Fluttertoast.showToast(
              msg: "The user combination and password does not exist",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              fontSize: 16,
            );
          }
        } else {
          // Handle non-200 HTTP status code, e.g., server error
          Fluttertoast.showToast(
            msg: "Server error: ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16,
          );
        }
      } catch (e) {
        // Handle exceptions or network errors
        print("Error: $e");
        Fluttertoast.showToast(
          msg: "Network error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16,
        );
      }
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Ergogreaser',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(),
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 50), // khate fasele
              const Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
              const SizedBox(height: 25),
              const Text(
                'login',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              MyTextField(
                // jaye khali
                controller: username,
                hintText: 'Username',
                abscureText: false,
              ),
              MyTextField(
                // jaye khali
                controller: password,
                hintText: 'Password',
                abscureText: true,
              ),
              ButtonTheme(
                  child: ElevatedButton(
                // dokme
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                onPressed: () {
                  signuser(context);
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              )),
              const SizedBox(height: 25), // khate fasele
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('forgot the password',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}

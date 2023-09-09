import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:timing_project/home.dart';
import 'signup.dart';
import 'my_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the package


class SignInWidget extends StatefulWidget {
   static const String ROUTE = "/";

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(height: 16.0),


                  TextField(
                    //TODO
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: null, // TODO
                    ),
                  ),

                  SizedBox(height: 24.0),
                  Container(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement sign-in logic

                        _login();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppHome.ROUTE,
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: Size(double.infinity, 40),
                        backgroundColor: Colors.black,
                      ),
                      child: Text('Sign In'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // TODO CHECK LOGIC;

                      Navigator.pushNamed(context, SignUpWidget.ROUTE);


                    },
                    child: Text('Or create a new account'),
                  ),

                 // SizedBox(height: 2.0),
                  TextButton(
                    onPressed: () {
                      // TODO CHECK LOGIC;
                      Navigator.pushNamed(context, SignUpWidget.ROUTE);

                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }
}


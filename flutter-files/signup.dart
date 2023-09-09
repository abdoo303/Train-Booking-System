import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:timing_project/home.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the package

class SignUpWidget extends StatefulWidget {
  static const String ROUTE="/signup";
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController _userNameController   = TextEditingController();
  final TextEditingController _emailController      = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _phoneController      = TextEditingController();
  final TextEditingController _passwordController   = TextEditingController();

  bool _isValidEmail = true;
  bool _isValidPhoneNumber=true;
  int _isValidID = 2;             // 0-> length<14, 1-> year doesnt match, 2 ->valid;
  int _isValidPassword = 4;

  void _validateEmail(String value) {
    setState(() {
      _isValidEmail = EmailValidator.validate(value);
    });
  }
  void validateEgyptianPhoneNumber(String phoneNumber) {
    // Regular expression to match Egyptian phone numbers
    final RegExp regex = RegExp(r'^01[0125]{1}[0-9]{8}$');
    setState(() {
      _isValidPhoneNumber= regex.hasMatch(phoneNumber);
    });
  }


  void _validateNationalId(String value) {
    setState(() {
      if (value.length != 14) {
        _isValidID = 0;
        return;
      }
      int curYear = (DateTime.now().year) as int;
      int clientYearOfBirth=1700;
      clientYearOfBirth+=100*(int.parse(value[0])) + int.parse(value.substring(1,3));
      if(curYear-clientYearOfBirth<8 || curYear-clientYearOfBirth>120)_isValidID=1;
      else _isValidID=2;
      //TODO do the date of birth calc;

    });


  }
  void _validatePassword(String password) {
    setState(() {
      if (password.length < 8) {
        _isValidPassword=0;return;
      }

      for (var char in password.runes) {
        if (RegExp(r'[A-Z]').hasMatch(String.fromCharCode(char))) {
          _isValidPassword=1;return;
        } else if (RegExp(r'[a-z]').hasMatch(String.fromCharCode(char))) {
          _isValidPassword=2;return;
        } else if (RegExp(r'[0-9]').hasMatch(String.fromCharCode(char))) {
          _isValidPassword=3;return;
        }
        _isValidPassword=4;
      }

    });

  }
  String? errorMessageOfNationalID(){
    switch (_isValidID){
      case 0:return "ID number must be 14 digits";
      case 1:return "age must be between 8 and 120 years";
    }
    return null;
  }
  String? errorMessageOfPassword(){
    switch (_isValidPassword){
      case 0:return "password must be at least 8 characters";
      case 1:return "password must contain at least 1 uppercase letter";
      case 2:return "password must contain at least 1 lowercase letter";
      case 3:return "password must contain at least 1 special character";
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Change underline color here
          ),// Change color here
        ),
      ), // Apply black theme
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
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
                    controller: _emailController,
                    onSubmitted: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: _isValidEmail ? null : 'Invalid email',
                    ),
                  ),


                  SizedBox(height: 16.0),


                  TextField(
                    controller: _nationalIdController,
                    onSubmitted: _validateNationalId,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'National ID',
                      errorText: errorMessageOfNationalID(),

                    ),
                  ),



                  SizedBox(height: 16.0),


                  TextField(
                    controller: _phoneController,
                    onSubmitted: validateEgyptianPhoneNumber,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      errorText: _isValidPhoneNumber? null:"Invalid Number",
                    ),
                  ),


                  SizedBox(height: 16.0),


                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    onSubmitted: _validatePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: errorMessageOfPassword(),
                    ),
                  ),


                  SizedBox(height: 24.0),


                  Container(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppHome.ROUTE, // Route name of the new widget
                              (route) => false, // Remove all routes
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                          minimumSize: Size(double.infinity, 40),
                        backgroundColor: Colors.black
                      ),
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0), // Adjust padding as needed
                    child: Text('Sign Up'),
                  ),
                    ),
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
    _nationalIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

}

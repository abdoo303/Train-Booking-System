import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:timing_project/image_fetch.dart';
import 'package:timing_project/verification_code_reciever.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'my_tickets.dart';

class EmailVerificationWidget extends StatefulWidget {
  static final String ROUTE = "/email_verifier";
  const EmailVerificationWidget({super.key});

  @override
  State<EmailVerificationWidget> createState() => _EmailVerificationWidgetState();
}

class _EmailVerificationWidgetState extends State<EmailVerificationWidget> {
  bool _validateEmail() {
    return EmailValidator.validate(email);
  }

  bool get isValidEmail => _validateEmail();
   String email= "";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue), // Highlighted border when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey), // Regular border when enabled
                      ),
                      prefixIcon: Icon(Icons.email,
                      color: Colors.blue,),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white),


                    ),
                    validator: (value) =>
                    isValidEmail ? null : 'email not valid',
                    onChanged: (value) {
                      setState(() {
                        email=value;
                      });


  }),
            SizedBox(height: 100,),
            Center(
              child: ElevatedButton(

                onPressed: isValidEmail? () async{
                  try {
                    final url = Uri.parse('http://10.0.2.2:5000/verify_email/');
                    final data ={
                      'email':email
                    };

                    final response = await http.post(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode(data),
                    );

                    if (response.statusCode == 200) {
                        final Map<String,dynamic> tokenMap=jsonDecode(response.body);
                        Utilities.token= tokenMap['token']!;
                        Utilities.canEmail = tokenMap['canEmail'];
                        print(tokenMap['canEmail']);
                      Navigator.pushNamed(context, CodeVerificationWidget.ROUTE);

                    } else {
                      print(response.body);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response.body),
                        ),
                      );
                    }
                  } catch (e) {
                    print('Errory: $e');
                  }


                }:null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width / 3, 40),
                  side: BorderSide(color: isValidEmail?Colors.blue:Colors.white),
                  backgroundColor: Colors.black,
                ),
                child: Text('Proceed',
                  style: TextStyle(
                      color: isValidEmail?Colors.blue:Colors.white
                  ),),

              ),
            ),
                ],
              ),
            ),
          ),
        ),

    );
  }
}


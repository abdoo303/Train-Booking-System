import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:timing_project/verification_code_reciever.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home.dart';
import 'my_tickets.dart';

class PhoneEditWidget extends StatefulWidget {
  static final String ROUTE = "/phone_edit";
  const PhoneEditWidget({super.key});

  @override
  State<PhoneEditWidget> createState() => _PhoneEditWidgetState();
}

class _PhoneEditWidgetState extends State<PhoneEditWidget> {
  String phoneNumber= "";

  bool validateEgyptianPhoneNumber() {
    // Regular expression to match Egyptian phone numbers
    final RegExp regex = RegExp(r'^01[0125]{1}[0-9]{8}$');

      return regex.hasMatch(phoneNumber);

  }
  bool get isValidPhoneNumber => validateEgyptianPhoneNumber();

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
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue), // Highlighted border when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey), // Regular border when enabled
                      ),
                      prefixIcon: Icon(Icons.phone,
                        color: Colors.blue,),
                      hintText: 'Phone number',
                      hintStyle: TextStyle(color: Colors.white),


                    ),
                    validator: (value) =>
                    isValidPhoneNumber ? null : 'number not valid',
                    onChanged: (value) {
                      setState(() {
                        phoneNumber=value;
                      });


                    }),
                SizedBox(height: 100,),
                Center(
                  child: ElevatedButton(

                    onPressed:isValidPhoneNumber? () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('phoneNumber' , phoneNumber);

                        try {
                          final int? id =await prefs.getInt('id');
                          final url = Uri.parse(
                              'http://10.0.2.2:5000/update_phone_number/');
                          final data = {
                            'phoneNumber': phoneNumber,
                            'id':id
                          };

                          final response = await http.post(
                            url,
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode(data),
                          );
                        } catch (e) {


                      }
                      Navigator.pushReplacementNamed(context, AppHome.ROUTE);

                    }:null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(MediaQuery.of(context).size.width / 3, 40),
                      side: BorderSide(color: isValidPhoneNumber?Colors.blue:Colors.white),
                      backgroundColor: Colors.black,
                    ),
                    child: Text('Done',
                      style: TextStyle(
                          color: isValidPhoneNumber?Colors.blue:Colors.white
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


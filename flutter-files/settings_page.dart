import "dart:ffi";

import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "package:timing_project/auth/login/login_view.dart";
import "package:timing_project/image_fetch.dart";
import "package:timing_project/phone_edit.dart";
import "email_verification_view.dart";

class SettingsWidget extends StatefulWidget {
  static const String ROUTE = "/settings";
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();

}

class _SettingsWidgetState extends State<SettingsWidget> {
  static  String email="aboda@gmail.com";
   static String phoneNumber="01243534534";
  static String userName="Abdelrahim Abdelazim";
   @override
   void initState() {
     email = Utilities.email;
     phoneNumber = Utilities.phoneNumber;
     userName  = Utilities.userName;
     super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Settings',
        style: TextStyle(
          letterSpacing: 1,
        ),),
      ),
      body:  SingleChildScrollView(
      child:Container(
        color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/twitter_new.jpg'),
                    ),
                    SizedBox(width: 20),
                    Text(
                      userName,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                column("phoneNumber: ", phoneNumber, PhoneEditWidget.ROUTE),
                SizedBox(height: 20,),
                column("Email: ", email, EmailVerificationWidget.ROUTE),
                SizedBox(height: 70),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO CHECK LOGIC;
                      _logout();
                      Navigator.pushNamedAndRemoveUntil(context, LoginView.ROUTE, (route) => false);

                    },
                    child: Text('sign out',style: TextStyle(color: Colors.red),),
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

   void _logout() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setBool('isLoggedIn', false);

   }
  Widget column(String key,String value,String routeForEdit){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            key,
            style: TextStyle(fontSize: 13,
                color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,),
                  overflow: TextOverflow.ellipsis, // This truncates the text if it overflows
                  maxLines: 1, // You can adjust the number of lines as needed
                ),
              ),

              Expanded(child: Container()),
              IconButton(
                  onPressed:  (){
                   Navigator.pushNamed(context,routeForEdit);
                  }, icon: Icon(Icons.edit,color: Colors.white,))

            ],
          )

        ]
    );
  }
}

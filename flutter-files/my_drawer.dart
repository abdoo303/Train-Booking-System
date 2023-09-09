import 'package:flutter/material.dart';
import 'package:timing_project/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login/login_view.dart';
import 'image_fetch.dart';
class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  static const  Color blue=Colors.blue;
  static const  Color white = Colors.white;
  static  String userName='',email='',phoneNumber='';
  static const List<String> listItemNames=["Settings","Subscriptions","Payments"];
  static const List<Icon> listOfIcons=[
    Icon(Icons.settings,color: blue,),
    Icon(Icons.local_offer,color:blue,),
    Icon(Icons.payment_rounded,color: blue,)];
  static const routes = [
    SettingsWidget.ROUTE,SettingsWidget.ROUTE,SettingsWidget.ROUTE,
  ];
  @override
  void initState() {
    email = Utilities.email;
    phoneNumber = Utilities.phoneNumber;
    print("drawer phoneNumber is $phoneNumber");
    userName  = Utilities.userName;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: Container(
        color: Colors.black,
        child: Container(
          child: ListView(

            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(

                accountName: Text(
                  userName
                  ,style: TextStyle(color: white),
                // 01020962706
                ),
                accountEmail: Text(email,
                style: TextStyle(color: white),),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.black,
                  child:
                  ClipOval(
                    child: Image.asset("assets/twitter_new.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),

              Divider(
                indent: 30,
                endIndent: 30,
                height: 30,
                color: Colors.white,
                thickness: 1,

              ),



            ]
              ..addAll(List.generate(listItemNames.length, (element) {
              return Column(
                children: [
                  ListTile(
                    leading: listOfIcons[element],
                    title: Text(
                      listItemNames[element],
                      style: TextStyle(color: blue,fontSize: 20,),),
                    onTap: () {
                      Navigator.popAndPushNamed(context, routes[element]);
                    },
                  ),
                  Divider(color: white,
                    indent: 50,
                    endIndent: 50,
                  ),
                ],
              );
            }).toList())
              ..add(Padding(
                padding: const EdgeInsets.fromLTRB(0,40,0,0),
                child: TextButton(onPressed:
       () {
            // TODO CHECK LOGIC;
            _logout();
            Navigator.pushNamedAndRemoveUntil(context, LoginView.ROUTE, (route) => false);


            },
                  child: Text(
                    'sign out',
                    style: TextStyle(color: Colors.red),
                  )),
              )
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
}

import 'package:flutter/material.dart';
import 'package:timing_project/TripsList.dart';
import 'package:timing_project/actual_tickets_view.dart';
import 'package:timing_project/home.dart';
import 'package:timing_project/my_tickets.dart';
import 'package:timing_project/phone_edit.dart';
import 'package:timing_project/search_page.dart';
import 'package:timing_project/settings_page.dart';
import 'package:timing_project/verification_code_reciever.dart';
import 'auth/auth_repository.dart';
import 'email_verification_view.dart';
import 'network/tap_payment.dart';
import 'new_card/add_card.dart';
import 'new_card/test.dart';
import 'signin.dart';
import 'signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timing_project/auth/login/login_view.dart';
import 'package:timing_project/auth/signup/signup_view.dart';
import 'package:provider/provider.dart';


bool isLoggedIn=false;

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  initializeApp().then((_) {
    runApp(
        MyApp());
  });
      }


Future<void> initializeApp() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
}


class MyApp extends StatelessWidget {

  final AuthRepository authRepository = AuthRepository(); // Create an instance of AuthRepository

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository, // Provide the AuthRepository instance to the widget tree
      child: MaterialApp(
        title: 'Your App',
          routes: {
            LoginView.ROUTE: (context)      => LoginView(),
            SignUpView.ROUTE: (context)      => SignUpView(),
            AppHome.ROUTE: (context)           => AppHome(),
            SettingsWidget.ROUTE: (context)    => SettingsWidget(),
            TicketsWidget.ROUTE:(context)      => TicketsWidget(),
            EmailVerificationWidget.ROUTE:(context) => EmailVerificationWidget(),
            CodeVerificationWidget.ROUTE:(context)  => CodeVerificationWidget(),
            PhoneEditWidget.ROUTE:(context)  => PhoneEditWidget(),
            SearchPage.ROUTE:(context)    =>  SearchPage(),
            TripsList.ROUTE:(context)   => TripsList(),
            CurrentTicketsWidget.ROUTE:(context) => CurrentTicketsWidget(),
            CardDetailsScreen.ROUTE:(context)  =>CardDetailsScreen(),
            AddNewCardScreen.ROUTE:(context)  =>AddNewCardScreen(),
            MyHomePage.ROUTE:(context)  =>MyHomePage(),







          },


        initialRoute: isLoggedIn? AppHome.ROUTE: LoginView.ROUTE,
      ),
    );
  }
}




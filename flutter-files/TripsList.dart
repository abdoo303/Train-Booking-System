import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'actual_tickets_view.dart';
import 'image_fetch.dart';
import 'my_tickets.dart';
import 'new_card/test.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Trip {
  final String from;
  final String to;
  final DateTime begin_time;
  final DateTime end_time;
  final int seatsAvailable;
  final String class_;
  final double price;
  final String trainName;


  Trip(this.from,this.to,this.begin_time,this.end_time,this.seatsAvailable,this.class_,this.price,this.trainName);



String title(){


  int hour= begin_time.hour;
  int minute= begin_time.minute;

    String theTime='$hour:$minute';
    return 'From :  $from,   to :  $to, at: $theTime';
  }
  String subtitle(){
    Duration duration = end_time.difference(begin_time) ;
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return  "t-name:                   $trainName\n\n"
            "class:                    $class_\n\n"
            "duration:                 $hours h , $minutes m\n\n"
            "remaining seats:          $seatsAvailable\n\n"
            "price:                    $price EGP";
  }

}



class TripsList extends StatelessWidget {
  static const String ROUTE ='/trips_list';

  static   List<Trip> trips = [];

  @override
  Widget build(BuildContext context) {
    return   trips.length==0?
    Scaffold(backgroundColor: Colors.black, appBar: AppBar(
      backgroundColor: Colors.black,
      title: Text('Trips Available'),
    ),
        body:Center(child: Text("No Available Trips",style: TextStyle(fontSize: 20,color: Colors.white),)))
        :Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Trips Available'),
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              //TODO IF YOU WANT , go to another screen
            },
            child: TripItem(trip: trips[index]),
          );
        },
      ),
    );
  }
}

class TripItem extends StatelessWidget {
  final Trip trip;

  TripItem({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(trip.title()+'\n\n',style: TextStyle(color: Colors.blue,fontSize: 17),),
                subtitle: Text(trip.subtitle() ,style: TextStyle(color: Colors.white,fontSize: 14),),
                // You can add more widgets here for additional details or actions
              ),
            ),
            TextButton(
                onPressed: ()async{
                  final ticketData ={
                    "from_station":trip.from,
                    'to_station':trip.to,
                    'train_name':trip.trainName,
                  'begin_time':trip.begin_time.toIso8601String(),
                  'end_time':trip.end_time.toIso8601String(),
                  'class_':trip.class_,
                  'price':trip.price,
                  };
                  try {
                    final url = Uri.parse('http://10.0.2.2:5000/book/');

                    final response = await http.post(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode(ticketData),
                    );

                      if (response.statusCode == 200) {
                     final Map<String, dynamic> data = jsonDecode(response.body);
                       Uint8List imageBytes = base64Decode(data['image']);
                     DateTime expiryDate = DateTime.parse(data['expiryDate']);

                     final SharedPreferences prefs = await SharedPreferences.getInstance();
                     List<String> imagesNames = prefs.getStringList(Utilities.imageNamesList)??[];
                     imagesNames.insert(0,'ticket_${data['imageID']}');
                     print("image name is: $imagesNames");
                     prefs.setStringList(Utilities.imageNamesList, imagesNames);

                     List<String> imagesDates = prefs.getStringList(Utilities.imageDatesList)??[];
                     imagesDates.insert(0,expiryDate.toIso8601String());
                     print("image dates is: $imagesDates");
                     prefs.setStringList(Utilities.imageDatesList, imagesDates);

                     final base64String = base64Encode(imageBytes);
                     await prefs.setString("ticket_${data['imageID']}", base64String);

                     await Utilities.fill();
                     // await Utilities.saveWKhalas(imageBytes, data['imageID'],expiryDate);
                     // await Utilities.saveImageLocally(imageBytes, data['imageID'],expiryDate);
                     // await Utilities.fillImagePathsList();
                    // await Utilities.fillImagePathsList2();
                      Navigator.pushNamed(context, CurrentTicketsWidget.ROUTE);

                    } else {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response.body),
                        ),
                      );
                    }
                  } catch (e) {
                    print('Errory: $e');
                  }


                },
                child: Text("Book"))
          ],
        ),
      ),
    );
  }
}


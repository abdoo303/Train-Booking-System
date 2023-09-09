import 'package:flutter/material.dart';
import 'package:timing_project/TripsList.dart';
import 'date_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  static const String ROUTE = '/search_page';
  static DateTime selectedDate=DateTime.now();
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> items = [
    "Cairo",
    "Alexandria",
    "Giza",
    "Asyut",
    "Mansoura",
    "Minya",
    "Zagazig",
    "Luxor",
    "Assiut",
    "Tanta",
    "Benha",
    "Sohag",
    "Ismailia",
    "Fayoum",
    "Suez",
    "Damietta",
    "Qena",
    "Port Said",
    "Aswan",
    "Damanhur",
    "Shibin El Kom",
    "Kafr El Sheikh",
    "New Valley",
    "Banha",
    "Desouk",
    "Rosetta",
    "Abu Hammad",
    "El Mansoura",
    "El Mahalla El Kubra",
    "Mallawi",
    "Marsa Matruh",
    "Kafr El Dawwar",
    "Sidi Gaber",
    "Mit Ghamr",
    "Beni Suef",
    "Akhmim",
    "El Sadat",
    "Talkha",
    "Sidi Salim",
    "El Hammam",
    "El Edwa",
    "Ain Shams",
    "Girga",
    "El Mahata",
    "Malka",
    "Samalut",
    "Quesna",
    "Deirut",  ];
  List<String> filteredItems1 = [];
  List<String> filteredItems2 = [];

  TextEditingController searchController1 = TextEditingController();
  TextEditingController searchController2 = TextEditingController();

  bool isReadyToSearch(){
    return items.contains(searchController1.text) && items.contains(searchController2.text);
  }

  Trip createTrip(Map<String,dynamic> json){

      return Trip(
          json['from_station'],
          json['to_station'],
          DateTime.parse(json['begin_time']),
         DateTime.parse(json['end_time']),
         json['available_seats'],
         json['class_'],
         json['price'].toDouble(),
         json['train_name'],
      );

  }
  @override
  void initState() {
    super.initState();
    filteredItems1.addAll(items);
    filteredItems2.addAll(items);
  }

  void filterSearchResults1(String query) {
    List<String> searchResults = items.where((item) {
      return item.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredItems1.clear();
      filteredItems1.addAll(searchResults);
    });
  }

  void filterSearchResults2(String query) {
    List<String> searchResults = items.where((item) {
      return item.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredItems2.clear();
      filteredItems2.addAll(searchResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("From..To"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height:20),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: DatePickerWidget(),
            ),

            SizedBox(height: 20,),
            // Row with two search bars
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children:[ Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                          ),
                          child: TextField(
                            style: TextStyle(color: Colors.blue),
                            controller: searchController1,
                            onChanged: (value) {
                              filterSearchResults1(value);
                            },
                            decoration: InputDecoration(
                              labelText: "From",
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          child: TextField(
                            style: TextStyle(color: Colors.blue),
                            controller: searchController2,
                            onChanged: (value) {
                              filterSearchResults2(value);
                            },
                            decoration: InputDecoration(
                              labelText: "To",
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),


                // Centered button

                // Scrollable item lists next to each other
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container( // Wrap each ListView in a Container with a fixed height
                            height: 200.0, // Set your desired height here
                            child: ListView.builder(
                              itemCount: filteredItems1.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(filteredItems1[index], style: TextStyle(color: Colors.blue)),
                                  onTap: () {
                                    searchController1.text = filteredItems1[index];
                                    filterSearchResults1(searchController1.text);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container( // Wrap each ListView in a Container with a fixed height
                            height: 200.0, // Set your desired height here
                            child: ListView.builder(
                              itemCount: filteredItems2.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(filteredItems2[index], style: TextStyle(color: Colors.blue)),
                                  onTap: () {
                                    searchController2.text = filteredItems2[index];
                                    filterSearchResults2(searchController2.text);

                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40,),
                    Center(
                      child: ElevatedButton(

                        onPressed:  isReadyToSearch()? () async {

                          final Uri uri = Uri.parse('http://10.0.2.2:5000/get_trips/')
                              .replace(queryParameters: {
                            'from_city': searchController1.text,
                            'to_city': searchController2.text,
                            'date':SearchPage.selectedDate.toIso8601String()
                          });

                          final response = await http.get(uri);

                          if (response.statusCode == 200) {
                            print("hi");
                            final Map<String, dynamic> jsonResponse = json.decode(response.body);

                            // Extract the "trips" list from the JSON response
                            final List<dynamic> data = jsonResponse['trips'];
                            TripsList.trips = data.map((map) => createTrip(map)).toList();
                            Navigator.pushNamed(context, TripsList.ROUTE);

                          } else {
                            print('Failed to fetch available rides. Status code: ${response.statusCode}');
                          }

                        }: null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),


                          ),
                          minimumSize: Size(MediaQuery.of(context).size.width / 3, 40),
                          side: BorderSide(color:  isReadyToSearch()?Colors.blue:Colors.white,),
                          backgroundColor: Colors.black,
                        ),
                        child: Text('See available trips',
                          style: TextStyle(
                            color: isReadyToSearch()?Colors.blue:Colors.white,
                          ),),

                      ),
                    ),

                  ],
                ),
    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




}


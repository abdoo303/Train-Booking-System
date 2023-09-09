
import 'package:flutter/material.dart';
import 'package:timing_project/image_fetch.dart';
import 'dart:io';



class CurrentTicketsWidget extends StatefulWidget {
  static const String ROUTE = "/my_actual_tickets";

  const CurrentTicketsWidget({super.key});

  @override
  _CurrentTicketsWidgetState createState() => _CurrentTicketsWidgetState();
}

class _CurrentTicketsWidgetState extends State<CurrentTicketsWidget> {

    List<String> images=[];

  @override
  void initState() {
    super.initState();
    images=Utilities.imagesPaths;
  }

  int currentIndex = 0;

  void _navigateToPrevious() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  void _navigateToNext() {
    setState(() {
      if (currentIndex < Utilities.imageBytesList.length - 1) {
        currentIndex++;
      }
      print(currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text("My tickets",
          style: TextStyle(color: Colors.blue),),
        centerTitle: true,
        backgroundColor: Colors.black87,),
      body:
      SingleChildScrollView(
        child:
        Utilities.imageBytesList.length==0?
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Text("You dont't have any upcoming tickets.",
                style:
                TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),),
              ),
            )
            :

        Container(

          child: Column(
            children: [
              Row(
                children: [

                  IconButton(

                    icon: Icon(Icons.arrow_back_ios,color: currentIndex==0?Colors.white10:Colors.white,),
                    onPressed: _navigateToPrevious,

                  ),

                  Column(
                    children: [
                      Container(
                        child: Image.memory(
                         Utilities.imageBytesList[currentIndex], // Convert the path to a File object
                          width: MediaQuery.of(context).size.width - 100,
                          height: MediaQuery.of(context).size.height - 150,
                          fit: BoxFit.contain, // Adjust the BoxFit as per your requirement
                        ),
                      ),

                      Center(
                        child: ElevatedButton(

                          onPressed: () async{

                            await Utilities.saveImageToPhotosApp(images[currentIndex]);

                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),


                            ),
                            minimumSize: Size(MediaQuery.of(context).size.width / 3, 40),
                            side: BorderSide(color: Colors.blue,),
                            backgroundColor: Colors.black,
                          ),
                          child: Text('download',
                            style: TextStyle(
                              color: Colors.blue,
                            ),),

                        ),
                      ),
                    ],
                  ),


                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios,color: currentIndex==Utilities.imageBytesList.length-1?Colors.white10:Colors.white,),
                    onPressed: _navigateToNext,
                  ),
                ],
              ),

            ],
          ),
        ),
      ),

    );
  }
}




import 'package:flutter/material.dart';
import 'package:timing_project/image_fetch.dart';



class TicketsWidget extends StatefulWidget {
  static const String ROUTE = "/my_tickets";

  const TicketsWidget({super.key});

  @override
  _TicketsWidgetState createState() => _TicketsWidgetState();
}

class _TicketsWidgetState extends State<TicketsWidget> {
   List<String> images = [];
  int currentIndex = 0;
@override
void initState() {
    super.initState();
    images= Utilities.imagesPaths2;
  }
  void _navigateToPrevious() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  void _navigateToNext() {
    setState(() {
      if (currentIndex < images.length - 1) {
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
        child: Container(

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
                        child: Image(
                          image: AssetImage(images[currentIndex]),
                          width:MediaQuery.of(context).size.width-100 ,
                          height: MediaQuery.of(context).size.height-150,
                          fit: BoxFit.contain, // Adjust the BoxFit as per your requirement
                        ),
                      ),

                      Center(
                        child: ElevatedButton(

                          onPressed: () {
                            print("i will download the ticket gamed gedan");
                            //
                            //  ImageUtilities.saveImageToPhotosApp(null);

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

                  // SizedBox(width: 16.0),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios,color: currentIndex==images.length-1?Colors.white10:Colors.white,),
                    onPressed: _navigateToNext,
                  ),
                ],
              ),
    // Center(
    // child: ElevatedButton(
    //
    // onPressed: () {
    //     print("i will download the ticket gamed gedan");
    //     //
    //    //  ImageUtilities.saveImageToPhotosApp(null);
    //
    // },
    // style: ElevatedButton.styleFrom(
    // shape: RoundedRectangleBorder(
    // borderRadius: BorderRadius.circular(10.0),
    //
    //
    // ),
    // minimumSize: Size(MediaQuery.of(context).size.width / 3, 40),
    // side: BorderSide(color: Colors.blue,),
    // backgroundColor: Colors.black,
    // ),
    // child: Text('download',
    // style: TextStyle(
    // color: Colors.blue,
    // ),),
    //
    // ),
    // ),
            ],
          ),
        ),
      ),

    );
  }
}



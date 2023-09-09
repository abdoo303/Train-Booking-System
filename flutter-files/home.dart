import 'package:flutter/material.dart';
import 'package:timing_project/image_fetch.dart';
import 'package:timing_project/my_tickets.dart';
import 'package:timing_project/search_page.dart';
import 'actual_tickets_view.dart';
import 'date_widget.dart';
import 'my_drawer.dart';

class AppHome extends StatefulWidget {

  static const String ROUTE = "/home";
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();


}

class _AppHomeState extends State<AppHome> {
 final TextEditingController FromController = TextEditingController();
 final TextEditingController ToController = TextEditingController();
 bool isReadyToSearch =true;

 @override
 void dispose() {
   FromController.dispose();
   ToController.dispose();
   super.dispose();
 }
 @override
 void initState() {
   Utilities.fillerOfUserName_Mail_PhoneNumber();
    super.initState();
  }
  static const appTitle ="Qetarak";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(appTitle,
        style: TextStyle(color: Colors.blue),),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu_rounded,color: Colors.blue,), // Change the drawer icon here
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
    child:Column(
        children: [
          SizedBox(height: 20,),
          Center(
            child: ElevatedButton(
              onPressed: ()async {
                await Utilities.fillImagePathsList();
                //await Utilities.fillImagePathsList2();
                await Utilities.fill();
                Navigator.pushNamed(context, CurrentTicketsWidget.ROUTE);

              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: Size(MediaQuery.of(context).size.width / 2, 40),
                side: BorderSide(color: Colors.blue),
                backgroundColor: Colors.black,
              ),
              child: Text('My Tickets',
              style: TextStyle(
                color: Colors.blue
              ),),

            ),
          ),
          SizedBox(height: 50,),

          DatePickerWidget(),
          SizedBox(height: 20,),

          BuildRoundedSquare("from..\n\n to.."),
          //_searchWidget("From",FromController),
          //_searchWidget("To",ToController),
          SizedBox(height: 50,),

          SearchButton(),

        ],
    )
        ),
      ),
      drawer:
      Container(
        child: MyDrawer(
        ),
      ),
    );
  }
  Widget _searchWidget(String fromOrTo,TextEditingController textEditingController){
    return  Container(
      width:MediaQuery.of(context).size.width * 2 / 3 ,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: textEditingController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.blue),
            hintText: '$fromOrTo...',
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.blue), // Highlighted border when focused
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey), // Regular border when enabled
            ),
          ),
        ),
      ),
    );
  }

  Widget SearchButton(){
    return Center(
      child: ElevatedButton(

        onPressed: isReadyToSearch?() {

          Navigator.pushNamed(context, SearchPage.ROUTE);

        }: null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),


          ),
          minimumSize: Size(MediaQuery.of(context).size.width / 3, 40),
          side: BorderSide(color: isReadyToSearch?Colors.blue:Colors.white,),
          backgroundColor: Colors.black,
        ),
        child: Text('Search for Trains',
          style: TextStyle(
            color: isReadyToSearch?Colors.blue:Colors.white,
          ),),

      ),
    );
}




 Widget BuildRoundedSquare(String text) {
   return Container(
     color: Colors.black,
     child: InkWell(
       onTap: (){
         print("hello");
         Navigator.pushNamed(context,SearchPage.ROUTE ,arguments:DateTime(2023,2,3));
       },
       child: Container(
         width: MediaQuery.of(context).size.width/2, // Adjust the width as needed
         height: 100, // Adjust the height as needed
         decoration: BoxDecoration(
           color: Colors.black, // Set your desired background color
           borderRadius: BorderRadius.circular(20), // Adjust the border radius for curved edges
           border: Border.all(
             color: Colors.blue, // Set your desired border color
             width: 2.0, // Set the border width
           ),
         ),
         child: Stack(
           children: [
             Center(
               child: Text(
                 text,
                 style: TextStyle(
                   color: Colors.white, // Set your desired text color
                   fontSize: 16, // Set your desired text size
                 ),
               ),
             ),
             Positioned(
               top: 49.0, // Adjust this value to position the line in the middle
               left: 0.0,
               right: 0.0,
               child: Container(
                 height: 2.0,
                 color: Colors.blue, // Set your desired line color
               ),
             ),
           ],
         ),
       ),
     ),
   );
 }




}



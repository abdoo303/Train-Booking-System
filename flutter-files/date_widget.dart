import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'search_page.dart';
class DatePickerWidget extends StatefulWidget {


  DatePickerWidget({Key? key}) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {

  List<String> dateLabels = ['Today', 'Tomorrow'];

  DateTime selectedDate = DateTime.now();
  int indexOfSelected=0;

  DateTime get someValue => selectedDate;

  void updateValue(DateTime newValue) {
    setState(() {
      selectedDate = newValue;
      SearchPage.selectedDate=newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedDate=DateTime.now();
    for (int i = 2; i < 7; i++) {
      dateLabels.add(
        DateFormat('E d').format(selectedDate.add(Duration(days: i))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: PopupMenuButton<String>(
        color: Colors.black,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.blue)
        ),
        onSelected: (String value) {
          setState(() {
              indexOfSelected=dateLabels.indexOf(value) ;
              selectedDate = DateTime.now().add(Duration(days: indexOfSelected));
              SearchPage.selectedDate=selectedDate;


          });
        },
        itemBuilder: (BuildContext context) {
          return dateLabels.map((dateLabel) {
            return PopupMenuItem<String>(

              value: dateLabel,
              child: Container(
                  color:Colors.black,
                  child: Text(dateLabel,style: TextStyle(color: Colors.blue),)),
            );
          }).toList();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
            color: Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.access_time_rounded,color: Colors.blue,),
              Text(
                '${dateLabels[indexOfSelected]}',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

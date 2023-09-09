import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utilities
{

////////////////////////// image utilities ///////////////////
static String userName='';
static String email='';
static String phoneNumber = '';
static int id = 0;

static Map<String,dynamic> userData={};
static String token = '';
static String canEmail = '';

 static Future< void> fillerOfUserName_Mail_PhoneNumber()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName=  (await prefs.getString('userName'))!;
    email  =   (await prefs.getString('email'))!;
    phoneNumber = (await prefs.getString('phoneNumber'))!;
    print("phoneNumber is $phoneNumber");
    id = (await prefs.getInt('id'))!;
  }

  static const String imageNamesList = "listNamesListKey";
  static const String imageDatesList = "listDatesListKey";


 static  Future<bool?> saveWKhalas(Uint8List imageData, String imageName,DateTime expirationDate) async {
   final String directory = "C:\\Users\\DELL\\Desktop\\images";
   final file = File('${directory}\\ticket_$imageName.png');
   file.writeAsBytes(imageData);
   List<Map<String,dynamic>> listOfMaps= await getMapList2();
   try {
     listOfMaps.insert(0, {
       'path': file.path,
       'expiration': expirationDate.toIso8601String()
     });
     await saveMapList2(listOfMaps);
     return true;
   }
      catch (e) {
        print('Error saving image: $e');
        return false;
      }

 }
static Widget displayLocalImage(String imagePath) {
  final file = File(imagePath);

  if (file.existsSync()) {
    // The image file exists, so display it
    return Image.file(file);
  } else {
    // If the file does not exist, you can show a placeholder or error message
    return Text('Image not found');
  }
}
static Future<void> saveImageToPhotosApp(String imagePath) async {
  final result = await ImageGallerySaver.saveFile(imagePath);

  if (result != null) {
    print('Image saved to Photos app: $imagePath');
  } else {
    print('Failed to save image to Photos app');
  }
}

static Future<void> deleteImage(String filePath) async {
  try {
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
      print('Image deleted successfully');
    } else {
      print('Image not found');
    }
  } catch (e) {
    print('Error deleting image: $e');
  }
}






/////////////////////// list of images utilites //////////////



  static const String key = 'myMapList';
  static List<String> imagesPaths = [];

  static  Future<bool?> saveImageLocally(Uint8List imageData, String imageName,DateTime expirationDate) async {

     try {
       final directory = await getApplicationDocumentsDirectory();
       final file = File('${directory.path}/ticket_$imageName.png');
       file.writeAsBytes(imageData);
       print("iamge saved successfully ya man");
       List<Map<String,dynamic>> listOfMaps= await getMapList();
       listOfMaps.insert(0,{
         'path':file.path,
         'expiration': expirationDate
       });
       print("listOfMaps: $listOfMaps");

       await saveMapList(listOfMaps);


       return true;
     } catch (e) {
       print('Error saving image: $e');
       return false;
     }
   }

 static  List<Uint8List> imageBytesList=[];

   static Future<void> fill() async{
      imageBytesList=[];

     final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> names =prefs.getStringList(imageNamesList)??[] ;
    final List<String> dates =prefs.getStringList(imageDatesList) ??[];
    final List<DateTime> dateTimeList = dates.map((string) {
      return DateTime.parse(string);
    }).toList();
    int dec=0;
    List.generate(dates.length, (index)async {
      if(dateTimeList[index].isBefore(DateTime.now())){
        await prefs.remove(names[index]);
        names.removeAt(index-dec);
        dec++;
      }
      else{
        final base64String = prefs.getString(names[index]);
        if (base64String != null && base64String.isNotEmpty) {
          final decodedData = base64Decode(base64String);
          imageBytesList.add(Uint8List.fromList(decodedData));
        }

        // Decode the base64 string back to a Uint8List

      }

    });
    dateTimeList.removeWhere((element) =>
      element.isBefore(DateTime.now()));
    print("the length of iamges is ${imageBytesList.length}");

   }

  static Future<void> saveMapList(List<Map<String, dynamic>> mapList) async {

    print("the to be saved maplist is $mapList");
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> jsonList = mapList.map((map) {
        final dateTime = map['expiration'] as DateTime;
        final path = map['path'] as String;
        return '{"expiration": "${dateTime.toIso8601String()}", "path": "$path"}';
      }).toList();

      await prefs.setStringList(key, jsonList);
    } catch (e) {
      print('Error saving mapList: $e');
    }
  }
  static Future<List<Map<String, dynamic>>> getMapList() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(key);

    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }

    final mapList = jsonList.map((jsonString) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(
        Map<String, dynamic>.from(json.decode(jsonString)),
      );

      final dateTime = DateTime.parse(map['expiration'] as String);
      final path = map['path'] as String;

      return {'expiration': dateTime, 'path': path};
    }).toList();

    return mapList;
  }
  static Future<void> fillImagePathsList()async{
    List<Map<String,dynamic>> listOfMaps =await getMapList();
    listOfMaps.removeWhere((map) {

      if(map['expiration'].isBefore( DateTime.now())){
        Utilities.deleteImage(map['path']);
        return true;
      }
      return false;
    }
    );
    Utilities.saveMapList(listOfMaps);

    imagesPaths  = listOfMaps.map((map) {
      return map['path'] as String;
    }
    ).toList();
    print("imagePaths is : $imagesPaths");

  }


  static const String key2 = 'myMapList2';



  static Future<void> saveMapList2(List<Map<String, dynamic>> mapList) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = mapList.map((map) => jsonEncode(map)).toList();
    await prefs.setStringList(key2, encodedList);
  }


  static Future<List<Map<String, dynamic>>> getMapList2() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList(key2);


    if (encodedList != null) {
      final mapList = encodedList.map((encodedMap) => jsonDecode(encodedMap)).toList();
      return mapList.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }




  static List<String> imagesPaths2 = [];

  static Future<void> fillImagePathsList2()async{
    List<Map<String,dynamic>> listOfMaps =await getMapList2();
    listOfMaps.removeWhere((map) {

      if(DateTime.parse(map['expiration']).isBefore( DateTime.now())){
        Utilities.deleteImage(map['path']);
        return true;
      }
      return false;
    }
    );
    Utilities.saveMapList2(listOfMaps);

    imagesPaths2  = listOfMaps.map((map) {
      return map['path'] as String;
    }
    ).toList();
    print(imagesPaths2);

  }

}
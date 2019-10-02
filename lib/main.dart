 import 'dart:io';
import 'package:file_picker/file_picker.dart';
  
import 'package:flutter/material.dart';
 import 'package:http/http.dart';
 import 'package:image_picker/image_picker.dart';
 import 'package:firebase_storage/firebase_storage.dart';
 import 'package:path/path.dart';

import 'p.dart';



 void main(){
   runApp(
     MaterialApp(
       home: Home(),
     ),
   );
 }

 class Home extends StatefulWidget {
   @override
   _HomeState createState() => _HomeState();
 }
 
 class _HomeState extends State<Home> {
   
   File _image;
   bool upload2=false;
   String url;
   String path;
   bool pic=false;
  List urls=[];

  Future download1() async{
    StorageReference reference = FirebaseStorage.instance.ref().child(path);
    String str= await reference.getDownloadURL();
    setState(() {
     url=str; 
     urls.add(url);
     int i;
     for(i=0; i<urls.length; i=i+1){
       print(urls[i]);
     }
     print(urls);
    });
  }


  Future upload1() async{
    StorageReference reference = FirebaseStorage.instance.ref().child(path);
    StorageUploadTask upload= await reference.putFile(_image);
    StorageTaskSnapshot task = await upload.onComplete;
    setState(() {
     upload2=true; 
    });
  }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("uploading and downloading url"),
         elevation: 4.0,
         centerTitle: true,
       ),
       body: Column(
         children: <Widget>[
           Center(
             child: _image==null?Container():Image.file(_image),
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: <Widget>[
             RaisedButton(
               onPressed: () {
                 setState(() async{
                  _image =  await ImagePicker.pickImage(source: ImageSource.gallery);
                  pic=true;
                  path=basename(_image.path);
                 });
               },
               child: Icon(Icons.image),
             ),
             RaisedButton(
               onPressed: (){
                 setState(() async{
                   pic=true;
                  _image = await ImagePicker.pickImage(source: ImageSource.camera) ;
                  path=basename(_image.path);
                 });
               },
               child: Icon(Icons.camera_alt),


             ),
           ],),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: <Widget>[
             pic==true?RaisedButton(
               onPressed: (){
                 upload2=true;
                 upload1();
               },
               child: Text("Upload"),
             ):Container(),
             upload2==false?Container():RaisedButton(
               onPressed: (){
                 download1();
               },
               child: Text("download url"),
             ),
             
           ],),
          
          RaisedButton(
            onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> P(urls))),
            child: Text("see the uploaded image"),
          )
         ],
       ),

     );
   }
 }
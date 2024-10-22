

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/main.dart';

class PermissionScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PermissionScreenState();

}

class PermissionScreenState extends State<PermissionScreen>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: ElevatedButton(onPressed: () { Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> MyApp(key: Key('home screen'),)));}, child: Text('Allow Permission'),)
     ),
   );
  }

}
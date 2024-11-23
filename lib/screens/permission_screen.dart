

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader/main.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:sizing/sizing.dart';

class PermissionScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PermissionScreenState();

}

class PermissionScreenState extends State<PermissionScreen>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Permisson Required'),
       centerTitle: true,
       actions: [
         IconButton(onPressed: (){SystemNavigator.pop();}, icon: Icon(Icons.close))
       ],
     ),
     body: Padding(
       padding: EdgeInsets.all(24.ss),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
         Text('Allow storage access to read all documents files in the devices!',style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
         SizedBox(height: 20.ss,),
         ElevatedButton(onPressed: () { Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> MyApp(key: Key('home screen'),)));}, child: Text('Allow Permission'),style: ButtonStyle(backgroundColor:WidgetStatePropertyAll(ColorTheme.RED),foregroundColor: WidgetStatePropertyAll(ColorTheme.WHITE)),)
       ]),
     ),
   );
  }

}
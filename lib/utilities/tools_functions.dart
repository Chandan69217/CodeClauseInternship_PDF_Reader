
import 'dart:io';
import 'package:printing/printing.dart';

import '../model/data.dart';

class ToolsFunction{





  static Future<void> printPDF(File files)async{
    try{
      if(await files.exists()){
        var pdfData = await files.readAsBytes();
        await Printing.layoutPdf(
          onLayout: (format) => pdfData,
        );
      }else{
        print('file does not exits');
      }
    }catch(exception,trace){
      print('exception : $exception , trace: $trace');
    }
  }

  static Future<void> lockPDF(Data data) async{
    
  }




}
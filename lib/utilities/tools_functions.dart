
import 'dart:io';
import 'package:printing/printing.dart';

class ToolsFunction{





  static printPDF(File files)async{
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


}
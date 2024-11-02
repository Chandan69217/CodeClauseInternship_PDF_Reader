import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:sizing/sizing.dart';

void customBottomSheet({required BuildContext context,required Data data}){
  showModalBottomSheet(
      context: context,
      elevation: 8,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height*0.6,
        minHeight: MediaQuery.of(context).size.height*0.46
      ),
      sheetAnimationStyle: AnimationStyle(curve: Curves.linear),
      useSafeArea: true,
      builder: (context){
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.ss),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 24.ss,right: 24.ss,top: 12.ss),
                child: _topDesign(context,data.fileName, data.details)),
                SizedBox(height: 6.ss,),
                const Divider(thickness: 2,),
                Padding(
                  padding: EdgeInsets.only(left: 12.ss,right: 24.ss,),
                  child: ListTile(leading: Icon(Icons.drive_file_rename_outline),title: Text('Rename',style: TextStyle(fontWeight: FontWeight.w400),),onTap: (){},),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.ss,right: 24.ss,),
                  child: ListTile(leading: Icon(Icons.share),title: Text('Share',style: TextStyle(fontWeight: FontWeight.w400),),onTap: (){},),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.ss,right: 24.ss,),
                  child: ListTile(leading: Icon(Icons.delete_rounded),title: Text('Delete',style: TextStyle(fontWeight: FontWeight.w400),),onTap: (){},),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.ss,right: 24.ss,),
                  child: ListTile(leading: Icon(Icons.info_outline),title: Text('Details',style: TextStyle(fontWeight: FontWeight.w400),),onTap: (){},),
                ),
              ],
            ),
          ),
        );
      });
}

Widget _topDesign(BuildContext context,String title,String subTitle){
  String extension = title.split('.').last.toLowerCase();
  String iconPath = '';
  if(extension == 'pdf'){
    iconPath = 'assets/icons/pdf.png';
  }else if(extension == 'doc' || extension == 'docx'){
    iconPath = 'assets/icons/doc.png';
  }else if(extension == 'ppt' || extension == 'pptx'){
    iconPath = 'assets/icons/ppt.png';
  }else if(extension == 'xls' || extension == 'xlsx'){
    iconPath = 'assets/icons/xls.png';
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(flex: 1,child: Image.asset(iconPath,width: 45.ss,height: 45.ss,),),
      Expanded(flex: 4,child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1,),
          Text(subTitle,style: Theme.of(context).textTheme.bodySmall,)
        ],
      )),
      Expanded(flex: 1,child: IconButton(onPressed: (){}, icon: Image.asset('assets/icons/bookmark_icon.png',width:40.ss,height: 40.ss,)))
    ],
  );
}
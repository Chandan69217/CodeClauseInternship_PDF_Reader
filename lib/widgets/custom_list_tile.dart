import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

class CustomListTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subTitle;
  final VoidCallbackAction? onOptionClick;
  final VoidCallbackAction? onTap;

  CustomListTile({super.key,required this.iconPath,required this.title,required this.subTitle,this.onOptionClick,this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ()=> onTap,
      leading: Image.asset(iconPath,width: 45.ss,height: 45.ss,),
      title: Text(title,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
      subtitle: Text(subTitle,style: Theme.of(context).textTheme.bodySmall,),
      trailing: IconButton(onPressed: (){onOptionClick;}, icon: Image.asset('assets/icons/three_dots_icon.png',width: 25.ss,height: 25.ss,)),
    );
  }
}

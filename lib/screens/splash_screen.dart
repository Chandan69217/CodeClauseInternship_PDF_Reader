import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/screens/dashboard.dart';
import 'package:lottie/lottie.dart';
import 'package:sizing/sizing.dart';

import '../external_storage/read_storage.dart';
import '../utilities/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _loadingStatus = true;
  var _onLoadingError = '';
  @override
  void initState() {
    super.initState();
    _loading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _loadingStatus ? _splashDesign():Center(child: Text(_onLoadingError,style: Theme.of(context).textTheme.headlineMedium,),),
    );
  }

  Widget _splashDesign() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 10,
                  child: Lottie.asset(
                      'assets/lottie_animation/splash_lottie_animation.json'),
                ),
                Expanded(
                  flex: 1,
                    child: _linearProgressIndicator())
              ])),
    );
  }

  Widget _linearProgressIndicator() {
    return Column(
      children: [
        Center(
          child: Container(
            width: 150,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                backgroundColor:
                    ColorTheme.PRIMARY, // Make background transparent
                valueColor: AlwaysStoppedAnimation<Color>(
                    ColorTheme.RED), // Make value color transparent
              ),
            ),
          ),
        ),
        SizedBox(
          height: 4.ss,
        ),
        Text(
          'Loading files...',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: ColorTheme.BLACK, fontSize: 14.fss),
        )
      ],
    );
  }

  Future<void> _loading() async{
    _loadingStatus = await Read(context).scanForAllFiles();
    if(_loadingStatus){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const Dashboard()));
    }else{
      _onLoadingError = 'Error while fetching files... ';
    }
    setState(() {
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
}

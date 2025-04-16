import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:pdf_reader/file_resolver/file_resolver.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/screens/dashboard.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf_reader/screens/file_viewer.dart';
import 'package:pdf_reader/screens/pdf_viewer.dart';
import 'package:pdf_reader/utilities/get_file_details.dart';
import '../external_storage/read_storage.dart';
import '../utilities/color_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _loadingStatus = true;
  var _onLoadingError = '';
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? list;
  bool _isSharedFileOpened = false;

  @override
  void initState() {
    super.initState();
    initSharingListener();
    WidgetsBinding.instance.addPostFrameCallback((duration){
      _loading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loadingStatus ? _splashDesign():Center(child: Text(_onLoadingError,style: Theme.of(context).textTheme.headlineSmall,),),
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
                  flex: 8,
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
        Expanded(
          flex: 3,
          child: RichText(
              text: TextSpan(
                  text: 'PDF ',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: ColorTheme.RED),
                  children: [
                    TextSpan(
                        text: 'Reader',
                        style: Theme.of(context).textTheme.headlineMedium
                  )
                  ])),
        ),
        const SizedBox(height: 10,),
        Expanded(
          flex: 1,
          child: Center(
            child: Container(
              width: 200,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  backgroundColor:
                      ColorTheme.PRIMARY,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      ColorTheme.RED),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
          flex: 3,
          child: Text(
            'Loading files...',
            style: Theme.of(context)
                .textTheme
                .titleSmall,
          ),
        )
      ],
    );
  }

  // initSharingListener()async {
  //   _intentDataStreamSubscription = FlutterSharingIntent.instance
  //       .getMediaStream()
  //       .listen((List<SharedFile> value) {
  //         list = value;
  //   }, onError: (err) {
  //     if (kDebugMode) {
  //       print("Shared: getIntentDataStream error: $err");
  //     }
  //   });
  //
  //   // For sharing images coming from outside the app while the app is closed
  //   FlutterSharingIntent.instance
  //       .getInitialSharing()
  //       .then((List<SharedFile> value) {
  //     list = value;
  //     _handleSharedFiles(list!);
  //   });
  // }

  initSharingListener()async {
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> value) {
      _handleSharedFiles(value);
    }, onError: (err) {
      if (kDebugMode) {
        print("Shared: getIntentDataStream error: $err");
      }
    });

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance
        .getInitialSharing()
        .then((List<SharedFile> value)async {
      _handleSharedFiles(value);
    });
  }

  void _handleSharedFiles(List<SharedFile> files)async {
    if(files.isEmpty){
      return;
    }
    _isSharedFileOpened = true;

    for (var file in files) {
      final path = await FileResolver.resolveContentUri(file.value!);
      String extension = path!.split('.').last.toLowerCase();
      await FileDetails.fetch(File(path));
      var data = Data(
        file: File(path),
        fileType: extension,
        fileName: path.split('/').last,
        filePath: path,
        details: FileDetails.getDetails(),
        fileSize: FileDetails.getSize(),
        date: FileDetails.getDate(),
        bytes: FileDetails.getBytes(),
      );
      if (extension == 'pdf') {
        WidgetsBinding.instance.addPostFrameCallback((duration){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> PdfViewer(data: data,isSharedIntent: true,)));
        });
      } else if (extension == 'docx') {
        // Navigate to DOCX viewer screen or show unsupported
      } else if (extension == 'xlsx') {
        // Handle Excel files
      } else if (extension == 'ppt' || extension == 'pptx') {
        // Handle PowerPoint files
      } else {
        // Show unsupported format message
      }
    }
  }

  Future<void> _loading() async{
    _loadingStatus = await Read(context).scanForAllFiles();
    if(_isSharedFileOpened){
      return;
    }
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
    _intentDataStreamSubscription.cancel();
  }

}

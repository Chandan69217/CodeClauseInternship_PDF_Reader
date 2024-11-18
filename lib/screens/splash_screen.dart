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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: Read(context).scanForAllFiles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Dashboard();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error while fetching files.'),
                );
              } else {
                return _splashDesign();
              }
            }),
      ),
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

  @override
  void dispose() {
    super.dispose();
  }
}

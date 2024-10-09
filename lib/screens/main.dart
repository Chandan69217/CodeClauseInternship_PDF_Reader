import 'package:flutter/material.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/all_files_screens.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/bookmark_screen.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/history_screen.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/tools_screen.dart';
import 'package:pdf_reader/utilities/color.dart';
import 'package:pdf_reader/utilities/theme_data.dart';
import 'package:sizing/sizing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SizingBuilder(
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PDF Reader',
        theme: themeData(),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _screens = <Widget>[AllFilesScreens(),HistoryScreen(),BookmarkScreen(),ToolsScreen()];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.PRIMARY,
        title: RichText(text: TextSpan(text: 'PDF ',style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: ColorTheme.RED),children: [TextSpan(text: 'Reader',style: Theme.of(context).textTheme.headlineMedium)])),
        actions: <Widget>[
          IconButton(onPressed: (){}, icon: Image.asset('assets/icons/search_icon.png',width: 30.ss,height: 30.ss,)),
          PopupMenuButton(itemBuilder: (context){
            return <PopupMenuItem>[
              PopupMenuItem(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex:8 ,child: Text('Last Modified',style: Theme.of(context).textTheme.bodyMedium,)),
                  Expanded(flex: 1,child: Image.asset('assets/icons/sort_icon.png',width: 0.ss,height: 20.ss,))
                ],
              ),),

              PopupMenuItem(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex:8 ,child: Text('Name',style: Theme.of(context).textTheme.bodyMedium,)),
                  Expanded(flex: 1,child: Image.asset('assets/icons/sort_by_name_icon.png',width: 20.ss,height: 20.ss,))
                ],
              ),),

              PopupMenuItem(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex:8 ,child: Text('File Size',style: Theme.of(context).textTheme.bodyMedium,)),
                  Expanded(flex: 1,child: Image.asset('assets/icons/sort_by_size_icon.png',width: 20.ss,height: 20.ss,))
                ],
              ),)
            ];
          },
            icon: Image.asset('assets/icons/sort_icon.png',width: 30.ss,height: 30.ss,),
            color: ColorTheme.WHITE,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.ss)),
          ),
          SizedBox(width: 10.ss,),
        ],
      ),
      body: SafeArea(child: _screens[_currentIndex]),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width*0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Expanded( flex: 2,child: Container(
            width: MediaQuery.of(context).size.width,
            color: ColorTheme.PRIMARY,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.ss,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex:1,child: SizedBox()),
                    Expanded(flex: 5,child: RichText(text: TextSpan(text: 'Trusted PDF',children: [TextSpan(text: '\n'),TextSpan(text: 'PDF',style: TextStyle(color: ColorTheme.RED)),TextSpan(text: ' Reader')],style: Theme.of(context).textTheme.headlineLarge),)),
                    Expanded(flex: 2,child: Text('Version 1.0.25',style: Theme.of(context).textTheme.bodyMedium,))
                  ],
                ),
              ),
            ),
          )),
          Expanded(flex: 5,child: Container(
            width: MediaQuery.of(context).size.width,
            color: ColorTheme.BLACK,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.ss,horizontal: 15.ss),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20.ss)),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex:1,child: Image.asset('assets/icons/crown_icon.png',width: 25.ss,height: 25.ss,color: ColorTheme.RED,)),
                          Expanded(flex: 3,child: RichText(text: TextSpan(text:'Design',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorTheme.RED),children: [TextSpan(text: ' By Chandan',style: TextStyle(color: ColorTheme.BLACK))]),)),
                        ],
                
                      ),
                    ),

                    SizedBox(height: 10.ss,),
                
                    IconButton(onPressed: (){}, icon: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(flex: 1,child: Image.asset('assets/icons/language_icon.png',width: 25.ss,height: 25.ss,color: ColorTheme.WHITE,)),
                        SizedBox(width: 10.ss,),
                        Expanded(flex: 6,child: Text('Language',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorTheme.WHITE),)),
                      ],)),
                
                    IconButton(onPressed: (){}, icon: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(flex: 1,child: Image.asset('assets/icons/share_icon.png',width: 25.ss,height: 25.ss,color: ColorTheme.WHITE,)),
                        SizedBox(width: 10.ss,),
                        Expanded(flex: 6,child: Text('Share App',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorTheme.WHITE),)),
                      ],)),
                
                    IconButton(onPressed: (){}, icon: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(flex: 1,child: Image.asset('assets/icons/app_like_icon.png',width: 25.ss,height: 25.ss,color: ColorTheme.WHITE,)),
                        SizedBox(width: 10.ss,),
                        Expanded(flex: 6,child: Text('Rate App',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorTheme.WHITE),)),
                      ],)),
                
                    IconButton(onPressed: (){}, icon: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(flex: 1,child: Image.asset('assets/icons/feedback_icon.png',width: 25.ss,height: 25.ss,color: ColorTheme.WHITE,)),
                        SizedBox(width: 10.ss,),
                        Expanded(flex: 6,child: Text('Feedback',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorTheme.WHITE),)),
                      ],)),
                
                    IconButton(onPressed: (){}, icon: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(flex: 1,child: Image.asset('assets/icons/privacy_icon.png',width: 25.ss,height: 25.ss,color: ColorTheme.WHITE,)),
                        SizedBox(width: 10.ss,),
                        Expanded(flex: 6,child: Text('Privacy Policy',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorTheme.WHITE),)),
                      ],)),
                
                    IconButton(onPressed: (){}, icon: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(flex: 1,child: Image.asset('assets/icons/application_icon.png',width: 25.ss,height: 25.ss,color: ColorTheme.WHITE,)),
                        SizedBox(width: 10.ss,),
                        Expanded(flex: 6,child: Text('More App',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorTheme.WHITE),)),
                      ],)),
                  ],
                ),
              ),
            ),
          ))],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){setState(() {
          _currentIndex = index;
        });},
        currentIndex: _currentIndex,
        selectedItemColor: ColorTheme.RED,
        unselectedItemColor: ColorTheme.BLACK,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14.fss,fontWeight: FontWeight.bold),
        unselectedFontSize: 14.fss,
        backgroundColor: ColorTheme.WHITE,
        items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Image.asset('assets/icons/file_icon.png',width: 30.ss,height: 30.ss,),label: 'All File', activeIcon: Image.asset('assets/icons/file_icon.png',width: 30.ss,height: 30.ss,color: ColorTheme.RED,)),
        BottomNavigationBarItem(icon: Image.asset('assets/icons/history_icon.png',width: 30.ss,height: 30.ss,),label: 'History',activeIcon: Image.asset('assets/icons/history_icon.png',width: 30.ss,height: 30.ss,color: ColorTheme.RED)),
        BottomNavigationBarItem(icon: Image.asset('assets/icons/bookmark_icon.png',width: 30.ss,height: 30.ss,),label: 'Bookmarks',activeIcon: Image.asset('assets/icons/bookmark_icon.png',width: 30.ss,height: 30.ss,color: ColorTheme.RED)),
        BottomNavigationBarItem(icon: Image.asset('assets/icons/tools_icon.png',width: 30.ss,height: 30.ss,),label: 'tools',activeIcon: Image.asset('assets/icons/tools_icon.png',width: 30.ss,height: 30.ss,color: ColorTheme.RED)),
      ],
      ),

    );
  }

}

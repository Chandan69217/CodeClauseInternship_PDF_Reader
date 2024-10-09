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
          IconButton(onPressed: (){}, icon: Image.asset('assets/icons/search_icon.png',width: 30,height: 30,)),
          IconButton(onPressed: (){}, icon: Image.asset('assets/icons/sort_icon.png',width: 30,height: 30,)),
          SizedBox(width: 10.ss,),
        ],
      ),
      body: SafeArea(child: _screens[_currentIndex]),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Expanded( flex: 2,child: Container(
            color: ColorTheme.PRIMARY,
          )),
          Expanded(flex: 5,child: Container(
            color: ColorTheme.BLACK,
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

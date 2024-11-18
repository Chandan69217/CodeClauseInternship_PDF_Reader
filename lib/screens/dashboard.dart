import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/all_files_screens.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/bookmark_screen.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/history_screen.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/tools_screen.dart';
import 'package:pdf_reader/screens/search_screen.dart';
import 'package:pdf_reader/utilities/color.dart';
import 'package:pdf_reader/utilities/sort.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';



class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  int _currentIndex = 0;
  double _appliedSortingDate = 0;
  double _appliedSortingName = 0;
  double _appliedSortingSize = 0;
  late final Future<bool> _scanFiles = Read(context).scanForAllFiles();
  static final GlobalKey<AllFilesStates> _allFilesKey = GlobalKey();
  final List<Widget> _screens = <Widget>[
    AllFilesScreens(
      key: _allFilesKey,
    ),
    HistoryScreen(),
    BookmarkScreen(),
    ToolsScreen()
  ];

  @override
  void initState() {
    super.initState();
    setSorting(Read.sortingType);
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: SafeArea(
            child: _screens[_currentIndex]
        ),
        drawer: _drawerUI(),
        bottomNavigationBar: _bottomNavigationBar());
  }

  setSorting(String sortType) {
    if (sortType == SortType.DATE) {
      _appliedSortingDate = 1;
      _appliedSortingName = 0;
      _appliedSortingSize = 0;
    } else if (sortType == SortType.NAME) {
      _appliedSortingDate = 0;
      _appliedSortingName = 1;
      _appliedSortingSize = 0;
    } else {
      _appliedSortingDate = 0;
      _appliedSortingName = 0;
      _appliedSortingSize = 1;
    }
  }

  Future<void> _saveSorting(String sortingType) async {
    var instance = await SharedPreferences.getInstance();
    instance.setString(SortType.KEY, sortingType);
    Read.sortBy(sortingType);
    _allFilesKey.currentState?.handleSortEvent();
    setSorting(sortingType);
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: ColorTheme.PRIMARY,
      title: RichText(
          text: TextSpan(
              text: 'PDF ',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: ColorTheme.RED),
              children: [
                TextSpan(
                    text: 'Reader',
                    style: Theme.of(context).textTheme.headlineMedium)
              ])),
      actions: _actionsButton(),
    );
  }

  _onSelected(dynamic value){
    _saveSorting(value);
  }

  List<Widget> _actionsButton() {
    return <Widget>[
      IconButton(
          onPressed: _onSearch,
          icon: Image.asset(
            'assets/icons/search_icon.png',
            width: 30.ss,
            height: 30.ss,
          )),
      PopupMenuButton(
        menuPadding: EdgeInsets.all(5.ss),
        onSelected: _onSelected,
        itemBuilder: (context) {
          return <PopupMenuItem>[
            PopupMenuItem(
              child: _popupMenuItemUI(leading: 'assets/icons/sort_icon.png', title: 'Last Modified', opacity: _appliedSortingDate),
              value: 'DATE',
            ),
            PopupMenuItem(
              child: _popupMenuItemUI(leading: 'assets/icons/sort_by_name_icon.png', title: 'Name', opacity: _appliedSortingName),
              value: 'NAME',
            ),
            PopupMenuItem(
              child: _popupMenuItemUI(leading: 'assets/icons/sort_by_size_icon.png', title: 'File Size', opacity: _appliedSortingSize),
              value: 'SIZE',
            )
          ];
        },
        icon: Image.asset(
          'assets/icons/sort_icon.png',
          width: 30.ss,
          height: 30.ss,
        ),
        color: ColorTheme.WHITE,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.ss)),
      ),
      SizedBox(
        width: 10.ss,
      ),
    ];
  }

  Widget _popupMenuItemUI({required String leading,required String title,required double opacity}){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(
            leading,
            width: 25.ss,
            height: 25.ss,
          ),
        ),
        SizedBox(width: 5.ss,),
        Expanded(
          flex: 5,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              'assets/icons/tick_icon.png',
              width: 25.ss,
              height: 25.ss,
            ),
          ),
        ),
      ],
    );
  }
  Drawer _drawerUI() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: ColorTheme.PRIMARY,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.ss,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                            flex: 5,
                            child: RichText(
                              text: TextSpan(
                                  text: 'Trusted PDF',
                                  children: [
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                        text: 'PDF',
                                        style:
                                        TextStyle(color: ColorTheme.RED)),
                                    TextSpan(text: ' Reader')
                                  ],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              'Version 1.0.25',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Expanded(
              flex: 5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: ColorTheme.BLACK,
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 30.ss, horizontal: 15.ss),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 50.ss),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.ss)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      'assets/icons/crown_icon.png',
                                      width: 25.ss,
                                      height: 25.ss,
                                      color: ColorTheme.RED,
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: RichText(
                                      text: TextSpan(
                                          text: 'Design',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: ColorTheme.RED),
                                          children: [
                                            TextSpan(
                                                text: ' By Chandan',
                                                style: TextStyle(
                                                    color: ColorTheme.BLACK))
                                          ]),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.ss,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      'assets/icons/language_icon.png',
                                      width: 25.ss,
                                      height: 25.ss,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10.ss,
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Text(
                                      'Language',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: ColorTheme.WHITE),
                                    )),
                              ],
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      'assets/icons/share_icon.png',
                                      width: 25.ss,
                                      height: 25.ss,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10.ss,
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Text(
                                      'Share App',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: ColorTheme.WHITE),
                                    )),
                              ],
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      'assets/icons/app_like_icon.png',
                                      width: 25.ss,
                                      height: 25.ss,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10.ss,
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Text(
                                      'Rate App',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: ColorTheme.WHITE),
                                    )),
                              ],
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      'assets/icons/feedback_icon.png',
                                      width: 25.ss,
                                      height: 25.ss,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10.ss,
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Text(
                                      'Feedback',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: ColorTheme.WHITE),
                                    )),
                              ],
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      'assets/icons/privacy_icon.png',
                                      width: 25.ss,
                                      height: 25.ss,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10.ss,
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Text(
                                      'Privacy Policy',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: ColorTheme.WHITE),
                                    )),
                              ],
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      'assets/icons/application_icon.png',
                                      width: 25.ss,
                                      height: 25.ss,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10.ss,
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Text(
                                      'More App',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: ColorTheme.WHITE),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      currentIndex: _currentIndex,
      selectedItemColor: ColorTheme.RED,
      unselectedItemColor: ColorTheme.BLACK,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:
      TextStyle(fontSize: 14.fss, fontWeight: FontWeight.bold),
      unselectedFontSize: 14.fss,
      backgroundColor: ColorTheme.WHITE,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/file_icon.png',
              width: 30.ss,
              height: 30.ss,
            ),
            label: 'All File',
            activeIcon: Image.asset(
              'assets/icons/file_icon.png',
              width: 30.ss,
              height: 30.ss,
              color: ColorTheme.RED,
            )),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/history_icon.png',
              width: 30.ss,
              height: 30.ss,
            ),
            label: 'History',
            activeIcon: Image.asset('assets/icons/history_icon.png',
                width: 30.ss, height: 30.ss, color: ColorTheme.RED)),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/bookmark_icon.png',
              width: 30.ss,
              height: 30.ss,
            ),
            label: 'Bookmarks',
            activeIcon: Image.asset('assets/icons/bookmark_icon.png',
                width: 30.ss, height: 30.ss, color: ColorTheme.RED)),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/tools_icon.png',
              width: 30.ss,
              height: 30.ss,
            ),
            label: 'tools',
            activeIcon: Image.asset('assets/icons/tools_icon.png',
                width: 30.ss, height: 30.ss, color: ColorTheme.RED)),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  _onSearch(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
  }

}

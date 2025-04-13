import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/database_helper.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/model/data.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/all_files_screens.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/bookmark_screen.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/history_screen.dart';
import 'package:pdf_reader/screens/navigation_screens/bottom/tools_screen.dart';
import 'package:pdf_reader/screens/search_screen.dart';
import 'package:pdf_reader/utilities/color_theme.dart';
import 'package:pdf_reader/utilities/sort.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _appliedSortingDate = false;
  bool _appliedSortingName = false;
  bool _appliedSortingSize = false;
  static final GlobalKey<AllFilesStates> _allFilesKey = GlobalKey();
  static final GlobalKey<BookmarkScreenState> _bookmarksKey = GlobalKey();
  static final GlobalKey<HistoryScreenState> _historysKey = GlobalKey();
  static final List<Widget> _screens = <Widget>[
    AllFilesScreens(key: _allFilesKey,),
    HistoryScreen(key: _historysKey,),
    BookmarkScreen(key: _bookmarksKey,),
    ToolsScreen()
  ];

  @override
  void initState() {
    super.initState();
    _setSortingTicker(Read.sortingType);
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
        bottomNavigationBar: _bottomNavigationBar()
    );
  }

  _setSortingTicker(String sortType) {
    if (sortType == SortType.DATE) {
      _appliedSortingDate = true;
      _appliedSortingName = false;
      _appliedSortingSize = false;
    } else if (sortType == SortType.NAME) {
      _appliedSortingDate = false;
      _appliedSortingName = true;
      _appliedSortingSize = false;
    } else {
      _appliedSortingDate = false;
      _appliedSortingName = false;
      _appliedSortingSize = true;
    }
  }


  Future<void> _saveSorting(String sortingType) async {
    var instance = await SharedPreferences.getInstance();
    instance.setString(SortType.KEY, sortingType);
    Read.sortBy(sortingType);
   _allFilesKey.currentState?.refreshAllFiles();
    _bookmarksKey.currentState?.refreshAllBookmarks();
    _historysKey.currentState?.refreshAllHistory();
    _setSortingTicker(sortingType);
  }

  AppBar _appBar() {
    return AppBar(
      leading: Builder(builder: (BuildContext context) {
        return IconButton(onPressed: (){Scaffold.of(context).openDrawer();}, icon: Icon(Icons.menu_rounded));
      },),
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
      Visibility(
        visible: _currentIndex != 3,
        child: IconButton(
            onPressed: _onSearch,
            icon: Image.asset(
              'assets/icons/search_icon.webp',
              width: 30,
              height: 30,
              color: Theme.of(context).brightness == Brightness.dark ? ColorTheme.WHITE:null,
            )
        ),
      ),
      Visibility(
        visible: _currentIndex !=3 ,
        child: PopupMenuButton(
          menuPadding: EdgeInsets.all(5),
          onSelected: _onSelected,
          itemBuilder: (context) {
            return <PopupMenuItem>[
              PopupMenuItem(
                child: _popupMenuItemUI(leading: 'assets/icons/sort_icon.webp', title: 'Last Modified', visibility: _appliedSortingDate),
                value: 'DATE',
              ),
              PopupMenuItem(
                child: _popupMenuItemUI(leading: 'assets/icons/sort_by_name_icon.webp', title: 'Name', visibility: _appliedSortingName),
                value: 'NAME',
              ),
              PopupMenuItem(
                child: _popupMenuItemUI(leading: 'assets/icons/sort_by_size_icon.webp', title: 'File Size', visibility: _appliedSortingSize),
                value: 'SIZE',
              )
            ];
          },
          icon: Image.asset(
            'assets/icons/sort_icon.webp',
            width: 30,
            height: 30,
            color: Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE:null,
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
    ];
  }

  Widget _popupMenuItemUI({required String leading,required String title,required bool visibility}){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(
            leading,
            width: 25,
            height: 25,
            color: Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE:null,
          ),
        ),
        SizedBox(width: 5,),
        Expanded(
          flex: 5,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: Visibility(
            visible: visibility,
            child: Image.asset(
              'assets/icons/tick_icon.webp',
              width: 25,
              height: 25,
              color: Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE:null,
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
                color: Theme.of(context).brightness == Brightness.light?ColorTheme.PRIMARY:Colors.black26,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                            flex: 5,
                            child: RichText(
                              text: TextSpan(
                                  text: 'Trusted PDF',
                                  children: const [
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
                color: Theme.of(context).brightness == Brightness.light?ColorTheme.BLACK:Colors.black12,
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      'assets/icons/crown_icon.webp',
                                      width: 25,
                                      height: 25,
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
                                          children: const [
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
                          height: 10,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      'assets/icons/language_icon.webp',
                                      width: 25,
                                      height: 25,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10,
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
                                      'assets/icons/share_icon.webp',
                                      width: 25,
                                      height: 25,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10,
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
                                      'assets/icons/app_like_icon.webp',
                                      width: 25,
                                      height: 25,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10,
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
                                      'assets/icons/feedback_icon.webp',
                                      width: 25,
                                      height: 25,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10,
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
                                      'assets/icons/privacy_icon.webp',
                                      width: 25,
                                      height: 25,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10,
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
                                      'assets/icons/application_icon.webp',
                                      width: 25,
                                      height: 25,
                                      color: ColorTheme.WHITE,
                                    )),
                                SizedBox(
                                  width: 10,
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
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/file_icon.webp',
              width: 25,
              height: 25,
              color: Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE:null,
            ),
            label: 'All File',
            activeIcon: Image.asset(
              'assets/icons/file_icon.webp',
              width: 25,
              height:25,
              color: ColorTheme.RED,
            )),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/history_icon.webp',
              width: 25,
              height: 25,
              color: Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE:null,
            ),
            label: 'History',
            activeIcon: Image.asset('assets/icons/history_icon.webp',
                width: 25, height: 25, color: ColorTheme.RED)),
        BottomNavigationBarItem(
            icon:
            Image.asset(
              'assets/icons/bookmark.webp',
              width: 25,
              height: 25,
              color: Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE:null,
            ),
            label: 'Bookmarks',
            activeIcon: Image.asset('assets/icons/bookmark.webp',
                width: 25, height: 25, color: ColorTheme.RED)),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/tools_icon.webp',
              width: 25,
              height: 25,
              color: Theme.of(context).brightness == Brightness.dark? ColorTheme.WHITE:null,
            ),
            label: 'Tools',
            activeIcon: Image.asset('assets/icons/tools_icon.webp',
                width: 25, height: 25, color: ColorTheme.RED)),
      ],
    );
  }

  @override
  void dispose(){
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    DatabaseHelper.getInstance().then((instance){instance.close();});
  }

  _onSearch(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(onChanged: _onChanged)));
  }


  _refreshAll(){
    _allFilesKey.currentState?.refreshAllFiles();
    _historysKey.currentState?.refreshAllHistory();
    _bookmarksKey.currentState?.refreshAllBookmarks();
  }
  void _onChanged(status,{Data? newData}) {
    if(status){
      _refreshAll();
    }
  }


}

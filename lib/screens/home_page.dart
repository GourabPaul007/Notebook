import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/documents_page.dart';
import 'package:frontend/screens/settings_page.dart';
import 'package:frontend/screens/subject_search_page.dart';
import 'package:frontend/screens/receive_shared_intent_page.dart';
import 'package:frontend/screens/starred_messages_page.dart';
import 'package:frontend/screens/subject_list_page.dart';
import 'package:frontend/services/documents_service.dart';
import 'package:frontend/services/subject_service.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with SingleTickerProviderStateMixin {
  // Intent Suff IDK dont ask shut
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;

  void clearIntentData() {
    setState(() {
      _sharedFiles = null;
    });
  }

  late final TabController _tabController;

  // Get All Subjects on Page Load
  @override
  void initState() {
    super.initState();

    // For sharing files coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        setState(() {
          _sharedFiles = value;
          debugPrint(
            "+++++++++++++++++Shared:" +
                (_sharedFiles?.map((f) => f.path).join(",") ?? "") +
                _sharedFiles.runtimeType.toString(),
          );
        });
      }
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });
    // For sharing files coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        setState(() {
          _sharedFiles = value;
          debugPrint(
            "*****************Shared:" +
                (_sharedFiles?.map((f) => f.path).join(",") ?? "") +
                _sharedFiles.runtimeType.toString(),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    _tabController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectServiceProvider).subjects;
    return _sharedFiles != null
        ? ReceiveSharedIntentPage(
            sharedFiles: _sharedFiles,
            clearIntentData: clearIntentData,
          )
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
              elevation: Theme.of(context).appBarTheme.elevation,
              title: Text('  WhatsNote', style: Theme.of(context).textTheme.headline1),
              actions: <Widget>[
                // Search Button
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () async {
                        showSearch(context: context, delegate: SubjectSearchPage(subjects));
                      },
                      icon: IconTheme(
                        data: Theme.of(context).iconTheme,
                        child: const Icon(
                          Icons.search_rounded,
                          size: 26.0,
                        ),
                      ),
                    ),
                  ),
                ),

                // Popup Menu Button
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    color: Colors.transparent,
                    child: PopupMenuTheme(
                      data: Theme.of(context).popupMenuTheme,
                      child: PopupMenuButton(
                        onSelected: (result) {
                          switch (result) {
                            case 1:
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => const StarredMessagesPage(from: "HomePage")),
                              );
                              break;

                            case 2:
                              Navigator.push(context, CupertinoPageRoute(builder: (context) => const SettingsPage()));
                              break;
                            default:
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text(
                              "Favourite Messages",
                              style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16),
                            ),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text(
                              "Settings",
                              style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16),
                            ),
                            value: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: const [
                SubjectListPage(),
                PdfsPage(),
              ],
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                border: const Border(top: BorderSide(color: Color(0xFF424242), width: 0.5)),
                // boxShadow: kElevationToShadow[1],
                color: Theme.of(context).colorScheme.background,
              ),

              /// need to wrap with theme to get rid of default splash effect on [BottomNavigationBarItem]s
              child: Theme(
                data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    ref.read(documentServiceProvider).disposeStates();
                    ref.read(subjectServiceProvider).resetHoldSubjectEffects();
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                  selectedItemColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Theme.of(context).iconTheme.color,
                  iconSize: 28,
                  // ==================================
                  // for default bottom navigation bar
                  // selectedFontSize: 16.0,
                  // unselectedFontSize: 16.0,
                  // showSelectedLabels: true,
                  // showUnselectedLabels: false,
                  // ==================================
                  // for custom bottom navigation bar
                  selectedFontSize: 8.0,
                  unselectedFontSize: 8.0,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  // ==================================
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.library_books_outlined),
                      label: 'Topics',
                      activeIcon: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).splashColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.library_books_outlined, color: Theme.of(context).colorScheme.secondary),
                            const SizedBox(width: 8),
                            Text("Topics", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                          ],
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.book_outlined),
                      label: 'Books',
                      activeIcon: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).splashColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.book_outlined, color: Theme.of(context).colorScheme.secondary),
                            const SizedBox(width: 8),
                            Text("Books", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}


    // _tabController = TabController(vsync: this, length: 3);
    // /**
    //  *  when the tab changes, reset all the states(if subject or documents on hold)
    //  */
    // _tabController.addListener(() {
    //   if (_tabController.indexIsChanging) {
    //     debugPrint("tab is animating. from active (getting the index) to inactive(getting the index) ");
    //   } else {
    //     debugPrint("tab index: " + _tabController.index.toString());
    //     ref.read(documentServiceProvider).disposeStates();
    //     ref.read(subjectServiceProvider).resetHoldSubjectEffects();
    //   }
    // });

    // TAB BAR
    // bottom: TabBar(
    //   controller: _tabController,
    //   indicatorColor: Theme.of(context).primaryColor,
    //   // indicatorPadding: EdgeInsets.all(8),
    //   indicatorSize: TabBarIndicatorSize.tab,
    //   indicatorWeight: 3,
    //   tabs: [
    //     Tab(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [Text("  TOPICS", style: Theme.of(context).textTheme.headline3)],
    //       ),
    //     ),
    //     Tab(
    //       icon: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [Text("  BOOKS", style: Theme.of(context).textTheme.headline3)],
    //       ),
    //     ),
    //     Tab(
    //       icon: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [Text("  FAVORITE", style: Theme.of(context).textTheme.headline3)],
    //       ),
    //     ),
    //   ],
    // ),

    // TabBarView(
    //   controller: _tabController,
    //   children: const [
    //     SubjectListPage(),
    //     PdfsPage(),
    //     StarredMessagesPage(from: "HomePage"),
    //   ],
    // ),
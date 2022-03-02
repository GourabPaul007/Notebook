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

    _tabController = TabController(vsync: this, length: 3);
    /**
     *  when the tab changes, reset all the states(if subject or documents on hold)
     */
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        debugPrint("tab is animating. from active (getting the index) to inactive(getting the index) ");
      } else {
        debugPrint("tab index: " + _tabController.index.toString());
        ref.read(documentServiceProvider).disposeStates();
        ref.read(subjectServiceProvider).resetHoldSubjectEffects();
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectServiceProvider).subjects;
    return _sharedFiles != null
        ? ReceiveSharedIntentPage(
            sharedFiles: _sharedFiles,
            clearIntentData: clearIntentData,
          )
        : DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
                elevation: Theme.of(context).appBarTheme.elevation,

                title: Text('WhatsNote', style: Theme.of(context).textTheme.headline1),
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
                            if (result == 3) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text(
                                "Settings",
                                style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16),
                              ),
                              value: 3,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                // TAB BAR
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  // indicatorPadding: EdgeInsets.all(8),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // IconTheme(
                          //   data: Theme.of(context).iconTheme,
                          //   child: const Icon(Icons.library_books_rounded),
                          // ),
                          Text(
                            "  TOPICS",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // IconTheme(
                          //   data: Theme.of(context).iconTheme,
                          //   child: const Icon(Icons.picture_as_pdf_rounded),
                          // ),
                          Text(
                            "  BOOKS",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // IconTheme(
                          //   data: Theme.of(context).iconTheme,
                          //   child: const Icon(Icons.star_rounded),
                          // ),
                          Text(
                            "  FAVORITE",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: const [
                  SubjectListPage(),
                  PdfsPage(),
                  StarredMessagesPage(from: "HomePage"),
                ],
              ),
            ),
          );
  }
}

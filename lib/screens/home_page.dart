import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/documents_page.dart';
import 'package:frontend/screens/documents_page/document_delete_button.dart';
import 'package:frontend/screens/documents_page/document_share_button.dart';
import 'package:frontend/screens/subject_search_page.dart';
import 'package:frontend/screens/receive_shared_intent_page.dart';
import 'package:frontend/screens/starred_messages_page.dart';
import 'package:frontend/screens/subject_list_page.dart';
import 'package:frontend/screens/subject_list_page/subject_delete_button.dart';
import 'package:frontend/screens/subject_list_page/subject_edit_button.dart';
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
      // switch (_tabController.index) {
      //   case 0:
      //     ref.read(documentServiceProvider).disposeStates();
      //     break;
      //   case 1:
      //     ref.read(subjectServiceProvider).resetHoldSubjectEffects();
      //     break;
      //   default:
      //     ref.read(documentServiceProvider).disposeStates();
      //     ref.read(subjectServiceProvider).resetHoldSubjectEffects();
      //     break;
      // }
      if (_tabController.indexIsChanging) {
        print("tab is animating. from active (getting the index) to inactive(getting the index) ");
      } else {
        //tab is finished animating you get the current index
        //here you can get your index or run some method once.
        print("**************" + _tabController.index.toString());
        ref.read(documentServiceProvider).disposeStates();
        ref.read(subjectServiceProvider).resetHoldSubjectEffects();
      }

      // debugPrint("************************************ Selected Index: " + _tabController.index.toString());
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
    final subjectService = ref.watch(subjectServiceProvider);
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
                  // Subject Delete Button
                  subjectService.subjectsOnHold ? const SubjectDeleteButton() : const SizedBox(),

                  // Subject Edit Button
                  subjectService.selectedSubjects.length == 1 ? const SubjectEditButton() : const SizedBox(),

                  // Document Delete Button
                  ref.watch(documentServiceProvider).selectedDocuments.isNotEmpty
                      ? const DocumentDeleteButton()
                      : const SizedBox(),

                  // Document Share Button
                  ref.watch(documentServiceProvider).selectedDocuments.isNotEmpty
                      ? const DocumentShareButton()
                      : const SizedBox(),

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
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              child: Text(
                                "View Details",
                                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              value: 1,
                            ),
                            const PopupMenuItem(
                              child: Text(
                                "Second",
                                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              value: 2,
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
                  indicatorColor: Colors.black,
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

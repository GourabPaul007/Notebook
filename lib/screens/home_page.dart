import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/subject_list_page.dart';

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         bottom: const TabBar(
//           tabs: [
//             Tab(icon: Icon(Icons.directions_car)),
//             Tab(icon: Icon(Icons.directions_transit)),
//             Tab(icon: Icon(Icons.directions_bike)),
//           ],
//         ),
//         title: const Text('Flutter Demo Home Page'),
//       ),
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             // const NavigationTabBar(),
//             ChatList(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.amber[900],
//         unselectedItemColor: Colors.grey.shade600,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
//         unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.message),
//             label: "Subjects",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.group_work),
//             label: "Chats",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_box),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  // CameraDescription camera;

  MyHomePage({
    Key? key,
    // required this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
          // toolbarHeight: 0,
          elevation: Theme.of(context).appBarTheme.elevation,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            // indicatorPadding: EdgeInsets.all(8),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.library_books_rounded)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: const Text('Lite Note'),
        ),
        body: const TabBarView(
          children: [
            // Icon(Icons.directions_car),
            SubjectListPage(
                // camera: camera,
                ),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}

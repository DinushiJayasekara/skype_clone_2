import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone_2/enum/user_state.dart';
import 'package:skype_clone_2/provider/member_provider.dart';
import 'package:skype_clone_2/resources/firebase_methods.dart';
import 'package:skype_clone_2/screens/callscreens/pickup/pickup_layout.dart';
import 'package:skype_clone_2/screens/pageviews/chat_list_screen.dart';
import 'package:skype_clone_2/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;

  MemberProvider memberProvider;

  FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      memberProvider = Provider.of<MemberProvider>(context, listen: false);
      await memberProvider.refreshMember();

      _firebaseMethods.setUserState(
        userId: memberProvider.getMember.uid,
        userState: UserState.Online,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (memberProvider != null && memberProvider.getMember != null)
            ? memberProvider.getMember.uid
            : '';
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _firebaseMethods.setUserState(
                userId: currentUserId,
                userState: UserState.Online,
              )
            : print('resumed state');
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _firebaseMethods.setUserState(
                userId: currentUserId,
                userState: UserState.Offline,
              )
            : print('inactive state');
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _firebaseMethods.setUserState(
                userId: currentUserId,
                userState: UserState.Waiting,
              )
            : print('paused state');
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _firebaseMethods.setUserState(
                userId: currentUserId,
                userState: UserState.Offline,
              )
            : print('detached state');
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            Container(
              child: ChatListScreen(),
            ),
            Center(
                child: Text(
              'Call Logs',
              style: TextStyle(color: Colors.white),
            )),
            Center(
                child: Text(
              'Contact Screen',
              style: TextStyle(color: Colors.white),
            )),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat,
                      color: (_page == 0)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor,
                    ),
                    label: 'Chats',
                    backgroundColor: (_page == 0)
                        ? UniversalVariables.lightBlueColor
                        : Colors.grey),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.call,
                      color: (_page == 1)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor,
                    ),
                    label: 'Call',
                    backgroundColor: (_page == 1)
                        ? UniversalVariables.lightBlueColor
                        : Colors.grey),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.contact_page,
                      color: (_page == 2)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor,
                    ),
                    label: 'Contacts',
                    backgroundColor: (_page == 2)
                        ? UniversalVariables.lightBlueColor
                        : Colors.grey),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}

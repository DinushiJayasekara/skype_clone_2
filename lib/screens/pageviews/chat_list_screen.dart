import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone_2/models/contact.dart';
import 'package:skype_clone_2/provider/member_provider.dart';
import 'package:skype_clone_2/resources/firebase_methods.dart';
// import 'package:skype_clone_2/resources/firebase_repository.dart';
import 'package:skype_clone_2/screens/pageviews/widgets/contact_view.dart';
import 'package:skype_clone_2/screens/pageviews/widgets/new_chat_button.dart';
import 'package:skype_clone_2/screens/pageviews/widgets/quiet_box.dart';
import 'package:skype_clone_2/screens/pageviews/widgets/user_circle.dart';
import 'package:skype_clone_2/utils/universal_variables.dart';
// import 'package:skype_clone_2/utils/utilities.dart';
import 'package:skype_clone_2/widgets/appbar.dart';
// import 'package:skype_clone_2/widgets/custom_tile.dart';

class ChatListScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
        title: UserCircle(),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/search_screen');
              }),
          IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        centerTitle: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    final MemberProvider memberProvider = Provider.of<MemberProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firebaseMethods.fetchContacts(
          userId: memberProvider.getMember.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data.docs;

            if (docList.isEmpty) {
              return QuietBox();
            }
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: docList.length,
              itemBuilder: (context, index) {
                Contact contact = Contact.fromMap(docList[index].data());
                return ContactView(contact);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

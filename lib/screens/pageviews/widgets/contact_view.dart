import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone_2/models/contact.dart';
import 'package:skype_clone_2/models/member.dart';
import 'package:skype_clone_2/provider/member_provider.dart';
import 'package:skype_clone_2/resources/firebase_methods.dart';
import 'package:skype_clone_2/screens/chatscreens/chat_screen.dart';
import 'package:skype_clone_2/screens/chatscreens/widgets/cached_image.dart';
import 'package:skype_clone_2/screens/pageviews/widgets/last_message_container.dart';
import 'package:skype_clone_2/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:skype_clone_2/widgets/custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Member>(
      future: _firebaseMethods.getMemberDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Member member = snapshot.data;
          return ViewLayout(contact: member);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final Member contact;
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final MemberProvider memberProvider = Provider.of<MemberProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          ),
        );
      },
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
      title: Text(
        contact?.name ?? '..',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Arial',
          fontSize: 19.0,
        ),
      ),
      subtitle: LastMessageContainer(
        stream: _firebaseMethods.fetchLastMessageBetween(
          senderId: memberProvider.getMember.uid,
          receiverId: contact.uid,
        ),
      ),
    );
  }
}

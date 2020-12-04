import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skype_clone_2/models/call.dart';
import 'package:skype_clone_2/models/member.dart';
import 'package:skype_clone_2/resources/call_methods.dart';
import 'package:skype_clone_2/screens/callscreens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({Member from, Member to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            call: call,
          ),
        ),
      );
    }
  }
}

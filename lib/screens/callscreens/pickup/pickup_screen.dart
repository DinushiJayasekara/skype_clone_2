import 'package:flutter/material.dart';
import 'package:skype_clone_2/models/call.dart';
import 'package:skype_clone_2/resources/call_methods.dart';
import 'package:skype_clone_2/screens/callscreens/call_screen.dart';
import 'package:skype_clone_2/screens/chatscreens/widgets/cached_image.dart';
import 'package:skype_clone_2/utils/permissions.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  PickupScreen({
    @required this.call,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Incoming...',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CachedImage(
              call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  onPressed: () async {
                    await callMethods.endCall(call: call);
                  },
                  color: Colors.redAccent,
                ),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  onPressed: () async {
                    // await Permissions.cameraAndMicrophonePermissionsGranted();
                    if (await Permissions
                        .cameraAndMicrophonePermissionsGranted()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreen(
                            call: call,
                          ),
                        ),
                      );
                    }
                  },
                  color: Colors.greenAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

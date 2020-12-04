import 'package:flutter/material.dart';
import 'package:skype_clone_2/utils/universal_variables.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        Icons.edit,
        size: 30.0,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(20),
    );
  }
}

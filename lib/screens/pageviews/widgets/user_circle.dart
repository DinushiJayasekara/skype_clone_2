import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone_2/provider/member_provider.dart';
import 'package:skype_clone_2/screens/pageviews/widgets/user_details_container.dart';
import 'package:skype_clone_2/utils/universal_variables.dart';
import 'package:skype_clone_2/utils/utilities.dart';

class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MemberProvider memberProvider = Provider.of<MemberProvider>(context);

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => UserDetailsContainer(),
        backgroundColor: UniversalVariables.blackColor,
        isScrollControlled: true,
      ),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: UniversalVariables.seperatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                Utils.getInitials(memberProvider.getMember.name),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: UniversalVariables.lightBlueColor,
                  fontSize: 13.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: UniversalVariables.blackColor,
                    width: 2,
                  ),
                  color: UniversalVariables.onlineDotColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone_2/models/member.dart';
import 'package:skype_clone_2/provider/member_provider.dart';
import 'package:skype_clone_2/utils/universal_variables.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MemberProvider memberProvider = Provider.of<MemberProvider>(context);
    final Member member = memberProvider.getMember;

    return Container(
      height: 50,
      width: 50,
      child: Shimmer.fromColors(
        // child: Image.asset('assets/app_logo.png'),
        child: Text(
          member.name.substring(0, 1),
          style: TextStyle(
            fontSize: 45,
          ),
        ),
        baseColor: UniversalVariables.blackColor,
        highlightColor: Colors.white,
      ),
    );
  }
}

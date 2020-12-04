import 'package:flutter/material.dart';
import 'package:skype_clone_2/models/member.dart';
import 'package:skype_clone_2/resources/firebase_repository.dart';

class MemberProvider with ChangeNotifier {
  Member _member;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  Member get getMember => _member;

  void refreshMember() async {
    Member member = await _firebaseRepository.getMemberDetails();
    _member = member;
    notifyListeners();
  }
}

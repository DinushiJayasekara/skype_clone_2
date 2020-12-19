import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone_2/constants/strings.dart';
import 'package:skype_clone_2/enum/user_state.dart';
import 'package:skype_clone_2/models/contact.dart';
import 'package:skype_clone_2/models/member.dart';
import 'package:skype_clone_2/models/message.dart';
import 'package:skype_clone_2/provider/image_upload_provider.dart';
import 'package:skype_clone_2/utils/utilities.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();

  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  final CollectionReference _messageCollection =
      _firebaseFirestore.collection(MESSAGES_COLLECTION);

  static final CollectionReference _userCollection =
      _firebaseFirestore.collection(USERS_COLLECTION);

  Reference _storageReference;

  Member member = Member();

  Future<User> getCurrentUser() async {
    User currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<Member> getMemberDetails() async {
    User currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();

    return Member.fromMap(documentSnapshot.data());
  }

  Future<Member> getMemberDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      return Member.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    User user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result =
        await _userCollection.where(EMAIL_FIELD, isEqualTo: user.email).get();

    final List<DocumentSnapshot> docs = result.docs;

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    member = Member(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoURL,
      username: username,
    );

    _userCollection.doc(currentUser.uid).set(member.toMap(member));
  }

  Future<bool> signOut() async {
    // await _googleSignIn.disconnect();
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.doc(userId).update({'state': stateNum});
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) {
    return _userCollection.doc(uid).snapshots();
  }

  Future<List<Member>> fetchAllUsers(User currentUser) async {
    List<Member> memberList = List<Member>();

    QuerySnapshot querySnapshot = await _userCollection.get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        memberList.add(Member.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return memberList;
  }

  Future<void> addMessageToDb(
      Message message, Member sender, Member receiver) async {
    var map = message.toMap();

    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactsDocument({String of, String forContact}) {
    return _userCollection
        .doc(of)
        .collection(CONTACTS_COLLECTION)
        .doc(forContact);
  }

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    _userCollection
        .doc(senderId)
        .collection(CONTACTS_COLLECTION)
        .doc(receiverId);

    await addToSendersContact(senderId, receiverId, currentTime);
    await addToReceiversContact(senderId, receiverId, currentTime);
  }

  Future<void> addToSendersContact(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiversContact(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) {
    return _userCollection
        .doc(userId)
        .collection(CONTACTS_COLLECTION)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) {
    return _messageCollection
        .doc(senderId)
        .collection(receiverId)
        .orderBy('timestamp')
        .snapshots();
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      String url = '';
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');

      final UploadTask uploadTask = _storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        url = await _storageReference.getDownloadURL();
      });
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;

    _message = Message.imageMessage(
      message: 'IMAGE',
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: 'image',
    );

    var map = _message.toImageMap();

    await _messageCollection
        .doc(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await _messageCollection
        .doc(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();

    String url = await uploadImageToStorage(image);

    imageUploadProvider.setToIdle();

    setImageMsg(url, receiverId, senderId);
  }
}

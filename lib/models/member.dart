class Member {
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  Member(
      {this.uid,
      this.name,
      this.email,
      this.username,
      this.status,
      this.state,
      this.profilePhoto});

  Map toMap(Member member) {
    var data = Map<String, dynamic>();
    data['uid'] = member.uid;
    data['name'] = member.name;
    data['email'] = member.email;
    data['username'] = member.username;
    data['status'] = member.status;
    data['state'] = member.state;
    data['profile_photo'] = member.profilePhoto;
    return data;
  }

  Member.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
  }
}

class UserModel {
  String? fName;
  String? lName;
  String? email;
  String? uid;
  String? image;
  List? myTeams;
//DateTime? onCreated;
  UserModel({
    this.uid,
    this.email,
    this.fName,
    this.lName,
    this.image,
    this.myTeams,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    fName = json['fName'];
    lName = json['lName'];
    email = json['email'];
    uid = json['uid'];
    image = json['image'];
    myTeams = json['myTeams'];
  }

  Map<String, dynamic> toMap() {
    return {
      'fName': fName,
      'lName': lName,
      'email': email,
      'uid': uid,
      'image': image,
      'myTeams': myTeams,
    };
  }
}

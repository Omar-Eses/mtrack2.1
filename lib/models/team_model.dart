class TeamModel {
  String? name;
  String? desc;
  String? owner;
  String? ownerName;
  String? ownerImageUrl;
  String? teamId;
  List? members;
  List? tasks;

  TeamModel({
    this.name,
    this.desc,
    this.owner,
    this.members,
    this.teamId,
    this.tasks,
    this.ownerName,
    this.ownerImageUrl,
  });

  TeamModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    desc = json['desc'];
    owner = json['owner'];
    members = json['members'];
    tasks = json['tasks'];
    teamId = json['teamId'];
    ownerName = json['ownerName'];
    ownerImageUrl = json['ownerImageUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'desc': desc,
      'owner': owner,
      'members': members,
      'tasks': tasks,
      'teamId': teamId,
      'ownerName': ownerName,
      'ownerImageUrl': ownerImageUrl,
    };
  }
}
// DateTime? onCreated;
//

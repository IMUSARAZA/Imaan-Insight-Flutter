
class UserDB{
  String userID;
  String Name;
  String Gender;

UserDB({
  required this.userID,
  required this.Name,
  required this.Gender,
});


UserDB.fromJson(Map<String, Object?> json)
      : this(
          userID: json['userID']! as String,
          Name: json['Name']! as String,
          Gender: json['Gender']! as String,
        );

  UserDB copyWith({
    String? userID,
    String? Name,
    String? Gender,
  }) {
    return UserDB(
        userID: userID ?? this.userID,
        Name: Name ?? this.Name,
        Gender: Gender ?? this.Gender,
);
  }

  Map<String, Object?> toJson() {
    return {
      'userID': userID,
      'Name': Name,
      'Gender': Gender,
    };
  }
}
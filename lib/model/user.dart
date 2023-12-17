class UserClass {
  final String email;
  final String uid;

  UserClass({
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
    };
  }

  static UserClass fromMap(Map<String, dynamic> map) {
    return UserClass(
      email: map['email'],
      uid: map['uid'],
    );
  }
}

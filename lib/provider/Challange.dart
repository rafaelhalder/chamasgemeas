class Challenge {
  Challenge({required this.age});

  String age;

  static Challenge fromMap(Map<String, dynamic> data) {
    return Challenge(
      age: data['age'],
    );
  }
}

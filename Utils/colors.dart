import 'package:flutter/material.dart';

LinearGradient background() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.1, 0.4, 0.7, 0.9],
    colors: [
      Color.fromARGB(255, 131, 53, 221),
      Color.fromARGB(255, 147, 69, 219),
      Color.fromARGB(255, 139, 54, 213),
      Color(0xFF5B16D0),
    ],
  );
}

LinearGradient backgroundnew() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.1, 0.4, 0.7, 0.9],
    colors: [
      Color.fromARGB(255, 9, 5, 15),
      Color.fromARGB(255, 28, 2, 52),
      Color.fromARGB(255, 21, 5, 36),
      Color.fromARGB(255, 9, 5, 15),
    ],
  );
}

LinearGradient backgroundnew2() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.1, 0.4, 0.7, 0.9],
    colors: [
      Color.fromARGB(255, 9, 5, 15),
      Color.fromARGB(255, 0, 0, 0),
      Color.fromARGB(255, 1, 1, 2),
      Color.fromARGB(255, 16, 15, 16),
    ],
  );
}

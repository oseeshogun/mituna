import 'dart:math';

T randomElement<T>(List<T> list) {
  final random = Random();
  final i = random.nextInt(list.length);
  return list[i];
}

num degToRad(num deg) => deg * (pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / pi);


bool get isDecember => DateTime.now().month == DateTime.december; 
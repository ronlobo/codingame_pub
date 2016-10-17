import 'dart:io' show stdin;

void main() {
  // the length of the road before the gap.
  int R = int.parse(stdin.readLineSync());
  // the length of the gap.
  int G = int.parse(stdin.readLineSync());
  // the length of the landing platform.
  int L = int.parse(stdin.readLineSync());

  // game loop
  while (true) {
    // the motorbike's speed.
    int S = int.parse(stdin.readLineSync());
    // the position on the road of the motorbike.
    int X = int.parse(stdin.readLineSync());

    bool jump = R - X - 1 == 0;
    bool slow = R + G <= X || S - 1 > G;
    bool speed = G + 1 != S && !slow;

    if (jump) {
      print('JUMP');
    } else if (speed) {
      print('SPEED');
    } else if (slow) {
      print('SLOW');
    } else {
      print('WAIT');
    }
  }
}

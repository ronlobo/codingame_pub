import 'dart:io' show stdin;

void main() {
  List inputs;

  while (true) {
    inputs = stdin.readLineSync().split(' ');
    int SX = int.parse(inputs[0]);
    int SY = int.parse(inputs[1]);
    int MAX = 0;
    int POS_X = 0;

    for (int i = 0; i < 8; i++) {
      int MH = int.parse(stdin.readLineSync());
      if (MH > MAX) {
        MAX = MH;
        POS_X = i;
      }
    }

    if (MAX < SY && POS_X == SX) {
      print('FIRE');
    } else {
      print('HOLD');
    }
  }
}

import 'dart:io' show stdin;

void main() {
  List inputs;
  inputs = stdin.readLineSync().split(' ');
  int LX = int.parse(inputs[0]); // the X position of the light of power
  int LY = int.parse(inputs[1]); // the Y position of the light of power
  int TX = int.parse(inputs[2]); // Thor's starting X position
  int TY = int.parse(inputs[3]); // Thor's starting Y position

  int steps_X = LX - TX;
  int steps_Y = LY - TY;

  // game loop
  while (true) {
    int E = int.parse(stdin.readLineSync());

    if (steps_X == 0 && steps_Y > 0) {
      steps_Y--;
      print('S');
    } else if (steps_X == 0 && steps_Y < 0) {
      steps_Y++;
      print('N');
    } else if (steps_Y == 0 && steps_X > 0) {
      steps_X--;
      print('E');
    } else if (steps_Y == 0 && steps_X < 0) {
      steps_X++;
      print('W');
    } else if (steps_X > 0 && steps_Y > 0) {
      steps_X--;
      steps_Y--;
      print('SE');
    } else if (steps_X > 0 && steps_Y < 0) {
      steps_X--;
      steps_Y++;
      print('NE');
    } else if (steps_X < 0 && steps_Y > 0) {
      steps_X--;
      steps_Y--;
      print('SW');
    } else if (steps_X < 0 && steps_Y < 0) {
      steps_X--;
      steps_Y++;
      print('NW');
    }
  }
}

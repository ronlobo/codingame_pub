import 'dart:io';

void main() {
    // game loop
    while (true) {
        String enemy1 = stdin.readLineSync();
        int dist1 = int.parse(stdin.readLineSync());
        String enemy2 = stdin.readLineSync();
        int dist2 = int.parse(stdin.readLineSync());

        if (dist1 < dist2) {
            print(enemy1);
        } else {
            print(enemy2);
        }
    }
}
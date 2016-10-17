import 'dart:io';

void main() {
  int L = int.parse(stdin.readLineSync());
  int H = int.parse(stdin.readLineSync());
  String T = stdin.readLineSync();

  List<String> letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ?".split("");
  List<List<String>> ascii_letters = new List(letters.length);

  for (int i = 0; i < H; i++) {
    String ROW = stdin.readLineSync();

    for (int j = 0; j < letters.length; j++) {
      if (i == 0) {
        ascii_letters[j] = new List(H);
      }

      ascii_letters[j][i] = ROW.substring(j * L, j * L + L);
    }
  }

  Map<String, List<String>> ascii_letters_map =
      new Map.fromIterables(letters, ascii_letters);

  List<String> ascii_rows_to_print =
      new List<String>.generate(H, (int index) => "");

  for (int f = 0; f < H; f++) {
    for (int k = 0; k < T.length; k++) {
      String msg_key = T[k].toUpperCase();
      String ascii_letter_to_print;

      if (ascii_letters_map.containsKey(msg_key)) {
        ascii_letter_to_print = ascii_letters_map[msg_key][f];
      } else {
        ascii_letter_to_print = ascii_letters_map["?"][f];
      }

      ascii_rows_to_print[f] += ascii_letter_to_print;
    }

    print(ascii_rows_to_print[f]);
  }
}

import 'dart:io' show stdin;
import 'dart:convert';

void main() {
  String MESSAGE = stdin.readLineSync();
  String answer = "";

  // we have at least one 1 or one 0
  String zero_start = "00 0";
  String one_start = "0 0";

  AsciiCodec ascii_codec = new AsciiCodec();

  List<int> ascii_msg_int_list = ascii_codec.encode(MESSAGE);

  String ascii_msg_radix2_string = "";

  for (int i in ascii_msg_int_list) {
    String radix_str = i.toRadixString(2);

    while (radix_str.length != 7) radix_str = "0" + radix_str;

    ascii_msg_radix2_string += radix_str;
  }

  int len = ascii_msg_radix2_string.length;

  for (int i = 0; i < len;) {
    String char = ascii_msg_radix2_string[i];

    if (i != 0) answer += " ";

    answer += char == "0" ? zero_start : one_start;

    if (i + 1 == len) break;

    while (char == ascii_msg_radix2_string[++i]) {
      answer += "0";
      if (i + 1 == len) {
        i += 1;
        break;
      }
    }
  }

  print(answer);
}

import 'dart:io' show stdin;

void main() {
  List inputs;
  Map<String, String> mimeTypes = new Map<String, String>();

  // Number of elements which make up the association table.
  int N = int.parse(stdin.readLineSync());
  // Number Q of file names to be analyzed.
  int Q = int.parse(stdin.readLineSync());

  for (int i = 0; i < N; i++) {
    inputs = stdin.readLineSync().split(' ');
    String EXT = inputs[0]; // file extension
    String MT = inputs[1]; // MIME type.
    mimeTypes[EXT.toLowerCase()] = MT;
  }

  for (int i = 0; i < Q; i++) {
    List<String> FNAME = stdin.readLineSync().split(".");
    String key = FNAME.last.toLowerCase();
    if (FNAME.length > 1 && mimeTypes.containsKey(key)) {
      print('${mimeTypes[key]}');
    } else {
      print('UNKNOWN');
    }
  }
}

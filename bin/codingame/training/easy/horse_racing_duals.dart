import 'dart:io' show stdin;

void main() {
  int N = int.parse(stdin.readLineSync());
  List<int> Pis = [];

  for (int i = 0; i < N; i++) {
    int Pi = int.parse(stdin.readLineSync());
    Pis.add(Pi);
  }

  Pis.sort();

  int D = Pis[1] - Pis[0];

  for (int j = 1; j < Pis.length - 1; j++) {
    int D_new = Pis[j + 1] - Pis[j];

    if (D > D_new) D = D_new;
  }

  print(D);
}

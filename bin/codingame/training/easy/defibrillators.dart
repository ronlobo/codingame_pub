import 'dart:io' show stdin;
import 'dart:math';

void main() {
  double LON =
      double.parse(stdin.readLineSync().replaceAll(new RegExp(r','), '.'));
  double LAT =
      double.parse(stdin.readLineSync().replaceAll(new RegExp(r','), '.'));

  int N = int.parse(stdin.readLineSync());

  List<Defib> defibs = new List<Defib>();

  double d = double.INFINITY;
  double tmp;
  String answer = "";

  for (int i = 0; i < N; i++) {
    String DEFIB = stdin.readLineSync();
    defibs.add(new Defib.fromString(DEFIB));

    tmp = defibs[i].getDefibDistanceToPoint(LON, LAT);

    if (tmp < d) {
      d = tmp;
      answer = defibs[i].name;
    }
  }

  print(answer);
}

class Defib {
  int id;
  String name;
  String address;
  String phone;
  double lon;
  double lat;

  Defib.fromString(String DEFIB) {
    List<String> tmp = DEFIB.split(";");
    this.id = int.parse(tmp[0]);
    this.name = tmp[1];
    this.address = tmp[2];
    this.phone = tmp[3];
    this.lon = double.parse(tmp[4].replaceAll(new RegExp(r','), '.'));
    this.lat = double.parse(tmp[5].replaceAll(new RegExp(r','), '.'));
  }

  double getDefibDistanceToPoint(double lon, double lat) {
    double x = (lon - this.lon) * cos((lon + this.lon) / 2);
    double y = lat - this.lat;
    double d = sqrt(x * x + y * y) * 6371;
    return d;
  }

  String toString() {
    String tmp = "";
    tmp += "ID: ${this.id}\n";
    tmp += "Name: ${this.name}\n";
    return tmp;
  }
}

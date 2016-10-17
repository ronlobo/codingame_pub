import 'dart:io';
import 'dart:math';

final log              = true;
final elitism          = true;
final generationsCount = 10;
final populationSize   = 20;
final genomeSize       = 1200;

var uniformRate        = .5;
var mutationRate       = .06;
var selectionRatio     = .4;

var GRAVITY            = acceleration(0.0, -3.711);
int maxX               = 6999;
int minX               = 0;

Line mars1Ground;
State marsLander1InitState;

void main()
{
  mars1Ground               = codingGameGroundInputsToLine();
  marsLander1InitState      = codingGameLanderInitialState();
  GenomeAndResult bestChimp = findBestChimp(
      createMarsLander1FromGenome, marsLander1Fitness);

  bestChimp.result.trajectory
    ..removeAt(0);

  for (var i = 0; i < bestChimp.result.trajectory.length; i++) {
    print(bestChimp.result.trajectory[i]);
  }
}

Lander createMarsLander1FromGenome(List<Gene> genome)
{
  var previousPower = 0,
      cmds = new List<ControlCmd>();

  for (int i = 1; i < genome.length + 1; i++)
  {
    var tmpPower = previousPower + genome[i - 1].asInt(1),
        power = coerceAtMost(4, tmpPower);

    cmds.add(new ControlCmd(power, 0));
    previousPower = power;
  }

  return new Lander(marsLander1InitState, cmds, mars1Ground);
}

double marsLander1Fitness(Lander lander)
{
  double fitness = -0x40000000.toDouble();

  switch (lander.flyState)
  {
    case FlyState.Landed:
      fitness = lander.trajectory.last.fuel.toDouble();

      break;
    case FlyState.Flying:
      var negPosY   = -lander.trajectory.last.position.y,
          landZoneY = mars1Ground.landingZone.first.y;

      fitness = negPosY + landZoneY;

      break;
    case FlyState.Crashed:
      var last = lander.trajectory.last,
          pos1 = mars1Ground.landingZone.first.y,
          pos2 = last.position.y,
          pos3 = last.speed.ySpeed + 40;

      fitness = pos1 - pos2 + pos3;

      break;
  }

  return fitness;
}

Angle intToAngle(int integer) =>
    new Angle(toRadians(integer.toDouble()));

Speed speed(double xSpeed, double ySpeed) =>
    new Speed(new Vector(xSpeed, ySpeed));

Acceleration acceleration(double xAcc, double yAcc) =>
    new Acceleration(new Vector(xAcc, yAcc));

Particule particule(double x, double y, Speed s) =>
    new Particule(new Point(x, y), s);

Line codingGameGroundInputsToLine()
{
  List inputs;
  var points = new List<Point>(),
      surfaceN = int.parse(stdin.readLineSync());

  for (int i = 0; i < surfaceN; i++)
  {
    inputs = stdin.readLineSync().split(' ');
    double landX = int.parse(inputs[0]).toDouble();
    double landY = int.parse(inputs[1]).toDouble();
    points.add(new Point(landX, landY));
  }

  return new Line(points);
}

State codingGameLanderInitialState()
{
  List inputs   = stdin.readLineSync().split(' ');
  double X      = double.parse(inputs[0]);
  double Y      = double.parse(inputs[1]);
  double hSpeed = double.parse(inputs[2]);
  double vSpeed = double.parse(inputs[3]);
  int fuel      = int.parse(inputs[4]);
  int rotate    = int.parse(inputs[5]);
  int power     = int.parse(inputs[6]);

  return new State(fuel, power, rotate, particule(X, Y, speed(hSpeed, vSpeed)));
}

GenomeAndResult findBestChimp(Function create, Function fitness)
{
  List<GenomeAndResult> population = new List<GenomeAndResult>(populationSize);

  for (var i = 0; i < populationSize; i++)
  {
    population[i] = new GenomeAndResult(buildGenome(genomeSize), create);
  }

  population..sort((a, b) => fitness(b.result) - fitness(a.result));

  logFitness(population, fitness);

  var chimpsFewGenerationsLater =
  new List(generationsCount).fold(population, (pop, next)
  {
    var nextGen = buildNextGeneration(pop, create)..sort((a, b) =>
                    fitness(b.result) - fitness(a.result));

    logFitness(nextGen, fitness);

    return nextGen;
  });

  return chimpsFewGenerationsLater.first;
}

List<Gene> buildGenome(int size)
{
  var genome = new List<Gene>(size);

  for (var i = 0; i < size; i++) {
    genome[i] = new Gene();
  }

  return genome;
}

List<GenomeAndResult> buildNextGeneration(
    List<GenomeAndResult> population,
    Function create
    )
{
  var newPop = new List<GenomeAndResult>.from(population),
      elitismOffset = elitism == true ? 1 : 0;

  for (var i = elitismOffset; i < population.length; i++)
  {
    var genome1 = select(population).genome,
        genome2 = select(population).genome,
        genome  = mutate(crossover(genome1, genome2));

    newPop[i] = new GenomeAndResult(genome, create);
  }

  return newPop;
}

GenomeAndResult select(List<GenomeAndResult> population)
{
  for (var i = 0; i < population.length; i++)
  {
    if (new Random().nextDouble() <=
        selectionRatio * (population.length - i) / population.length) {
      return population[i];
    }
  }

  return population.first;
}

List<Gene> crossover(List<Gene>genome1, List<Gene> genome2)
{
  var genome = new List<Gene>(genome1.length);

  for (var i = 0; i < genome1.length; i++) {
    if (new Random().nextDouble() <= uniformRate)
    {
      genome[i] = genome1[i];
    }
    else
    {
      genome[i] = genome2[i];
    }
  }

  return genome;
}

List<Gene> mutate(List<Gene> genome)
{
  for (var i = 0; i < genome.length; i++)
  {
    if (new Random().nextDouble() <= mutationRate)
    {
      genome[i] = new Gene();
    }
  }

  return genome;
}

num toRadians(num degrees) => degrees * PI / 180.0;

num toDegrees(num radians) => radians * 180.0 / PI;

int coerceAtLeast(int minimumValue, int checkValue) =>
    checkValue < minimumValue ? minimumValue : checkValue;

int coerceAtMost(int maximumValue, int checkValue) =>
    checkValue > maximumValue ? maximumValue : checkValue;

void logFitness(List<GenomeAndResult> population, Function fitness)
{
  if (log) {
    var msg = '';

    for (var i = 0; i < population.length; i++) {
      msg += fitness(population[i].result).toInt().toString().padRight(5) + ' ';
    }

    stderr.writeln(msg);
  }
}

class Point
{

  double x;
  double y;

  Point(this.x, this.y);

  Point operator +(Vector vector) => new Point(x + vector.dx, y + vector.dy);

  Vector operator -(Point point) => new Vector(x - point.x, y - point.y);

  double distanceTo(Point point) => (point - this).length;
}

class Vector
{

  double dx;
  double dy;

  double get length => sqrt(dx * dx + dy * dy);

  Vector(this.dx, this.dy);

  Vector operator +(Vector vector) =>
      new Vector(dx + vector.dx, dy + vector.dy);

  Vector operator *(double times) => new Vector(dx * times, dy * times);

  Vector rotate(Angle angle) => new Vector(
      dx * cos(angle.rad) - dy * sin(angle.rad),
      dx * sin(angle.rad) + dy * cos(angle.rad));
}

class Angle
{
  double _rad;

  num get rad => toDegrees(_rad);

  Angle(this._rad);
}

class Line
{

  List<Point> points;

  Line(List<Point> points) {
    if (points.length < 2) {
      throw new Exception('Should have 2 points at minimum.');
    }

    this.points = points;
  }

  operator >(Point point) {
    var distance = (_getYforX(point.x) - point.y).toInt();
    return distance >= 0 ? true : false;
  }

  isHorizontalAtX(double x)
  {
    Pair segment = _getSegmentFor(x);

    if (segment == null) {
      return false;
    }

    return segment.first.y == segment.second.y;
  }

  Pair _getSegmentFor(double x)
  {
    var p1 = points.firstWhere((p1) {
      var isP1 = p1.x <= x,
          p2 = points.elementAt(points.indexOf(p1) + 1),
          isP2 = x <= p2.x;
      return isP1 && isP2;
    });

    var p2 = points.elementAt(points.indexOf(p1) + 1);

    return new Pair(p1, p2);
  }

  double _getYforX(double x)
  {
    Pair segment = _getSegmentFor(x);

    if (segment == null) {
      return 0.0;
    }

    return segment.first.y +
           (x - segment.first.x) * (segment.second.y - segment.first.y) /
           (segment.second.x - segment.first.x);
  }

  Pair get landingZone {
    Pair pair;

    for (var i = 0; i < points.length - 1; i++) {
      if (points[i].y == points[i + 1].y) {
        pair = new Pair(points[i], points[i + 1]);
      }
    }

    return pair;
  }
}

class Pair
{
  var first;
  var second;

  Pair(this.first, this.second);

  toString() => '${first} ${second}';

  toList() => [first, second];
}

class Gene
{
  double random;

  Gene([random]) {
    if (random == null || !random is double)
    {
      this.random = new Random().nextDouble();
    }
    else
    {
      this.random = random;
    }
  }

  asInt(int max) => (random * (max + 1)).toInt();
}

class GenomeAndResult
{

  List<Gene> genome;
  var result;

  GenomeAndResult(List<Gene>genome, Function create)
  {
    this.genome = genome;
    this.result = create(genome);
  }
}

class ControlCmd
{
  int power;
  int angle;

  ControlCmd([this.power = 0, this.angle = 0]);
}

class State
{
  int fuel;
  int power;
  int angle;
  Particule particule;

  State(this.fuel, this.power, this.angle, this.particule);

  Point get position => particule.position;

  Speed get speed => particule.speed;

  State computeNextState(ControlCmd cmd, [Time time])
  {
    if (time == null)
    {
      time = new Time(1.0);
    }

    var tmpNewAngle        = coerceAtMost(15, coerceAtLeast(-15, cmd.angle - angle)),
        newAngle           = angle + tmpNewAngle,
        tmpNewPower        = coerceAtLeast(-1, coerceAtMost(1, cmd.power - power)),
        newPower           = power + tmpNewPower,
        thrustAcceleration = new Acceleration(
            (new Vector(0.0, 1.0) * newPower.toDouble()).rotate(
                intToAngle(newAngle))),
        acceleration       = GRAVITY + thrustAcceleration,
        newParticule       = particule.accelerate(acceleration, time),
        newFuel            = fuel - newPower;

    return new State(newFuel, newPower, newAngle, newParticule);
  }

  toString() => '$angle $power';
}

enum FlyState
{
  Landed,
  Crashed,
  Flying
}

class Lander
{
  State initState;
  List<ControlCmd> cmds;
  Line ground;

  List<State> trajectory = [];
  var flyState           = FlyState.Flying;

  Lander(initState, cmds, ground)
  {
    this.initState = initState;
    this.cmds      = cmds;
    this.ground    = ground;

    trajectory.add(initState);

    computeTrajectory();
  }

  void computeTrajectory()
  {
    for (var i = 0; i < cmds.length; i++)
    {
      var nextState = trajectory[i].computeNextState(cmds[i]);

      trajectory.add(nextState);

      if (evaluateOutside(nextState)) return;
      if (evaluateHitTheGround(nextState)) return;
      if (evaluateNoFuel(nextState)) return;
    }
  }

  bool evaluateOutside(State state)
  {
    if (state.position.x > maxX || state.position.x < minX)
    {
      flyState = FlyState.Crashed;

      return true;
    }

    return false;
  }

  bool evaluateHitTheGround(State nextState)
  {
    if (ground > nextState.position)
    {
      if (nextState.angle == 0
          && nextState.speed.ySpeed > -40
          && nextState.speed.xSpeed.abs() <= 20
          && ground.isHorizontalAtX(nextState.position.x))
      {
        flyState = FlyState.Landed;
      }
      else
      {
        flyState = FlyState.Crashed;
      }

      return true;
    }

    return false;
  }

  bool evaluateNoFuel(State nextState)
  {
    if (nextState.fuel <= 0)
    {
      flyState = FlyState.Crashed;

      return true;
    }

    return false;
  }
}

class Time
{
  final double sec;

  Time(this.sec);
}

class Speed
{
  Vector direction;

  double get xSpeed => direction.dx;
  double get ySpeed => direction.dy;

  Speed(this.direction);

  operator +(Speed speed) => new Speed(direction + speed.direction);

  toString() => "(${xSpeed.toStringAsFixed(2)}, ${ySpeed.toStringAsFixed(2)})";
}

class Acceleration
{

  Vector vector;

  Acceleration(this.vector);

  operator *(Time time) => new Speed(vector * time.sec);

  operator +(Acceleration acceleration) =>
      new Acceleration(vector + acceleration.vector);

}

class Particule
{
  Point position;
  Speed speed;

  Particule(this.position, this.speed);

  Particule accelerate(Acceleration acceleration, Time time)
  {
    Speed newSpeed    = speed + acceleration * time;
    Point newPosition = position +
                        speed.direction * time.sec +
                        acceleration.vector * time.sec * time.sec * 0.5;

    return new Particule(newPosition, newSpeed);
  }

  toString() =>
      " x=${position.x.toStringAsFixed(2)}"
      " y=${position.y.toStringAsFixed(2)}"
      " speed=${speed}";
}

enum Weighting { bronze, silver, gold , platinum }

class WeightValue {
  static const List<double> bronze =  [1.4, 1.19, 1.03, 0.92, 0.98];
  static const List<double> silver =  [1.25, 1.17, 1.05, 0.93, 0.99];
  static const List<double> gold =    [1.20, 1.15, 1.10, 0.95, 1];
  static const List<double> platinum =[1.30, 1.12, 1.15, 0.98, 1.02];

  static const List<double> weight = [0.9, 0.95, 1, 1.15, 1.05];
}

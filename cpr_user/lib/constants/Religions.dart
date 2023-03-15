class Religions {

  int id;
  String name;

  Religions(this.id, this.name);

  static List<Religions> getReligionsList(){
    List<Religions> religions = [];
    religions.add(new Religions(0, "Christian"));
    religions.add(new Religions(1, "Jewish"));
    religions.add(new Religions(3, "Islamic"));
    religions.add(new Religions(4, "Buddhist"));
    religions.add(new Religions(5, "Hindu"));
    religions.add(new Religions(6, "Sikh"));
    religions.add(new Religions(7, "agnostic"));
    religions.add(new Religions(8, "atheist"));
    religions.add(new Religions(9, "other"));
    return religions;
  }
}
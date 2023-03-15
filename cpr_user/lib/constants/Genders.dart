class Genders {

  int id;
  String name;

  Genders(this.id, this.name);

  static List<Genders> getGendersList(){
    List<Genders> genders = [];
    genders.add(new Genders(0, "Male"));
    genders.add(new Genders(1, "Female"));
    genders.add(new Genders(2, "Other"));
    return genders;
  }
}

class PreviousMedAid {
  String name;
  String package;
  String number;
  DateTime joined;
  DateTime terminated;

  PreviousMedAid({
    this.name,
    this.package,
    this.number,
    this.joined,
    this.terminated
  });

  Map toMap() {
    return {
      'name': this.name,
      'package': this.package,
      'number': this.number,
      'joined': this.joined,
      'termination': this.terminated
    };
  }
}


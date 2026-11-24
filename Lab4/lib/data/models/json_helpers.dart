Map<String, dynamic> readMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! Map) {
    throw FormatException('Campul "$key" lipseste sau nu este un obiect.');
  }
  return Map<String, dynamic>.from(value);
}

Map<String, dynamic> asMap(Object? value) {
  if (value is! Map) {
    throw const FormatException('Elementul JSON nu este un obiect.');
  }
  return Map<String, dynamic>.from(value);
}

List<dynamic> readList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) {
    throw FormatException('Campul "$key" lipseste sau nu este o lista.');
  }
  return value;
}

String readString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String) {
    throw FormatException('Campul "$key" lipseste sau nu este text.');
  }
  return value;
}

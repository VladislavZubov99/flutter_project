import 'dart:convert';

class FromJson {
  toJson() {}

  @override
  String toString() {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final jsonObject = toJson();
    return encoder.convert(jsonObject);
  }
}


import 'package:project/domain/models/fromJson.dart';

class Tenant extends FromJson {
  late int id;
  late int number;
  late String name;
  String? phoneNumber;
  int? portalCompanyId;
  String? email;
  String? contactPerson;
  String? city;
  String? street;
  String? houseNumber;
  String? postcode;
  int? index;
  String? color;
  bool? saphir3Connected;
  String? portalTenantLogoDto;

  Tenant(
      {required this.id,
        required this.number,
        this.name = '',
        this.phoneNumber,
        this.portalCompanyId,
        this.email,
        this.contactPerson,
        this.city,
        this.street,
        this.houseNumber,
        this.postcode,
        this.index,
        this.color,
        this.saphir3Connected,
        this.portalTenantLogoDto});

  Tenant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    name = json['name'] ?? '';
    phoneNumber = json['phoneNumber'];
    portalCompanyId = json['portalCompanyId'];
    email = json['email'];
    contactPerson = json['contactPerson'];
    city = json['city'];
    street = json['street'];
    houseNumber = json['houseNumber'];
    postcode = json['postcode'];
    index = json['index'];
    color = json['color'];
    saphir3Connected = json['saphir3Connected'];
    portalTenantLogoDto = json['portalTenantLogoDto'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['number'] = number;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['portalCompanyId'] = portalCompanyId;
    data['email'] = email;
    data['contactPerson'] = contactPerson;
    data['city'] = city;
    data['street'] = street;
    data['houseNumber'] = houseNumber;
    data['postcode'] = postcode;
    data['index'] = index;
    data['color'] = color;
    data['saphir3Connected'] = saphir3Connected;
    data['portalTenantLogoDto'] = portalTenantLogoDto;
    return data;
  }
}
import 'package:newsapp/domain/models/location_model.dart';

class RegisterData {
  String? uName;
  String? email;
  String? password1;
  String? password2;
  UserLocation? location;
  RegisterData({
    this.uName,
    this.email,
    this.password1,
    this.password2,
    this.location,
  });
}

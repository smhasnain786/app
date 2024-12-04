class UpdateUser {
  String? phone;
  String? email;
  String? name;

  UpdateUser({
    this.phone,
    this.email,
    this.name,
  });

  UpdateUser.fromMap(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (data['phone'] != null) {
      data['phone'] = phone;
    }
    if (data['email'] != null) {
      data['email'] = email;
    }
    if (data['name'] != null) {
      data['name'] = name;
    }
    return data;
  }
}

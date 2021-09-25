class user {
  int userId;
  String email;
  String name;
  String password;
  String tp;
  int userRate;
  String topratedstatus;
  String resetcode;

  user(
      {this.userId,
        this.email,
        this.name,
        this.password,
        this.tp,
        this.userRate,
        this.topratedstatus,
        this.resetcode});

  user.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    tp = json['tp'];
    userRate = json['user_rate'];
    topratedstatus = json['topratedstatus'];
    resetcode = json['resetcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['email'] = this.email;
    data['name'] = this.name;
    data['password'] = this.password;
    data['tp'] = this.tp;
    data['user_rate'] = this.userRate;
    data['topratedstatus'] = this.topratedstatus;
    data['resetcode'] = this.resetcode;
    return data;
  }
}
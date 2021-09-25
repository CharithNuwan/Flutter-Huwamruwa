class category {
  List<Categorylist> categorylist;

  category({this.categorylist});

  category.fromJson(Map<String, dynamic> json) {
    if (json['categorylist'] != null) {
      categorylist = new List<Categorylist>();
      json['categorylist'].forEach((v) {
        categorylist.add(new Categorylist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categorylist != null) {
      data['categorylist'] = this.categorylist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categorylist {
  int categoryID;
  String categoryName;

  Categorylist({this.categoryID, this.categoryName});

  Categorylist.fromJson(Map<String, dynamic> json) {
    categoryID = json['categoryID'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryID'] = this.categoryID;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
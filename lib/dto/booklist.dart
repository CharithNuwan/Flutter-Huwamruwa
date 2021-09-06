

class Book {
  List<Booklist> booklist;

  Book({this.booklist});

  Book.fromJson(Map<String, dynamic> json) {
    if (json['booklist'] != null) {
      booklist = new List<Booklist>();
      json['booklist'].forEach((v) {
        booklist.add(new Booklist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.booklist != null) {
      data['booklist'] = this.booklist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Booklist {
  int categoryid;
  String province;
  String district;
  String city;
  String description;
  int listingBookId;
  int userId;
  String isbn;
  String bookName;
  String publishedYear;
  String eBookFile;
  String listingType;
  int quantity;
  String image;
  String author;
  double price;

  Booklist(
      {this.categoryid,
        this.province,
        this.district,
        this.city,
        this.description,
        this.listingBookId,
        this.userId,
        this.isbn,
        this.bookName,
        this.publishedYear,
        this.eBookFile,
        this.listingType,
        this.quantity,
        this.image,
        this.author,
        this.price});

  Booklist.fromJson(Map<String, dynamic> json) {
    categoryid = json['categoryid'];
    province = json['province'];
    district = json['district'];
    city = json['city'];
    description = json['description'];
    listingBookId = json['listing_book_id'];
    userId = json['user_id'];
    isbn = json['isbn'];
    bookName = json['book_name'];
    publishedYear = json['published_year'];
    eBookFile = json['e_book_file'];
    listingType = json['listing_type'];
    quantity = json['quantity'];
    image = json['image'];
    author = json['author'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryid'] = this.categoryid;
    data['province'] = this.province;
    data['district'] = this.district;
    data['city'] = this.city;
    data['description'] = this.description;
    data['listing_book_id'] = this.listingBookId;
    data['user_id'] = this.userId;
    data['isbn'] = this.isbn;
    data['book_name'] = this.bookName;
    data['published_year'] = this.publishedYear;
    data['e_book_file'] = this.eBookFile;
    data['listing_type'] = this.listingType;
    data['quantity'] = this.quantity;
    data['image'] = this.image;
    data['author'] = this.author;
    data['price'] = this.price;
    return data;
  }
}
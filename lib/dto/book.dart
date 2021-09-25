class book1 {
  int listingBookId;
  String isbn;
  String bookName;
  String description;
  String author;
  String image;
  String listingType;
  Null publishedYear;
  Null eBookFile;
  int quantity;
  int price;
  int userId;
  int categoryid;
  String district;
  String city;
  String tp;

  book1(
      {this.listingBookId,
        this.isbn,
        this.bookName,
        this.description,
        this.author,
        this.image,
        this.listingType,
        this.publishedYear,
        this.eBookFile,
        this.quantity,
        this.price,
        this.userId,
        this.categoryid,
        this.district,
        this.city,
        this.tp});

  book1.fromJson(Map<String, dynamic> json) {
    listingBookId = json['listing_book_id'];
    isbn = json['isbn'];
    bookName = json['book_name'];
    description = json['description'];
    author = json['author'];
    image = json['image'];
    listingType = json['listing_type'];
    publishedYear = json['published_year'];
    eBookFile = json['e_book_file'];
    quantity = json['quantity'];
    price = json['price'];
    userId = json['user_id'];
    categoryid = json['categoryid'];
    district = json['district'];
    city = json['city'];
    tp = json['tp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_book_id'] = this.listingBookId;
    data['isbn'] = this.isbn;
    data['book_name'] = this.bookName;
    data['description'] = this.description;
    data['author'] = this.author;
    data['image'] = this.image;
    data['listing_type'] = this.listingType;
    data['published_year'] = this.publishedYear;
    data['e_book_file'] = this.eBookFile;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['user_id'] = this.userId;
    data['categoryid'] = this.categoryid;
    data['district'] = this.district;
    data['city'] = this.city;
    data['tp'] = this.tp;
    return data;
  }
}
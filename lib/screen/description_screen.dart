import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:huwamaruwa/custom_widgets/custom_app_bar.dart';
import 'package:huwamaruwa/custom_widgets/custom_drawer.dart';
import 'package:huwamaruwa/custom_widgets/custom_progress_indicator.dart';
import 'package:huwamaruwa/custom_widgets/profile_clipper.dart';
import 'package:huwamaruwa/dto/book.dart';
import 'package:huwamaruwa/dto/cart_dto.dart';
import 'package:huwamaruwa/dto/user.dart';
import 'package:huwamaruwa/routes/routes.dart';
import 'package:huwamaruwa/screen/add_new_post_screen.dart';
import 'package:huwamaruwa/services/UI_Data.dart';


class Description extends StatefulWidget {

  static const String routeName = '/des';
  String Id = Get.parameters['Id'];
  String SellerId = Get.parameters['SellerId'];
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {

  ScrollController _scrollController = new ScrollController();
  bool isLoading=false;
  bool isLoadingLoadMore = false;
  List<Cart> ca = [];
  int _itemCount = 1;
  int index;
  book1 book=null;
  String username="";
  String userseller="";
  user u;

  final TextEditingController _userSeller = new TextEditingController();


  @override
  void initState() {
    super.initState();
    print(widget.Id);
    index=int.parse(widget.Id);
    getCivilStatus(widget.Id);
    getSellerUser(widget.SellerId);
  }


  Future getCivilStatus(id) async {
    var parsedData;
    // print("getCivilStatus "+id);
    Map data = {
      "listing_book_id": id
    };

    var response = await post("https://huwamaruwa-app.herokuapp.com/getbook", headers: <String, String>{
      'Content-Type': 'application/json',
    },body:jsonEncode(data)).then((response){
      // print(response.body);
      if(response.statusCode == 200) {
        Map<String, dynamic> userDataMap = jsonDecode(response.body);
        // print(response.body);
        setState(() {
          book = book1.fromJson(userDataMap);
        });
        // user_suppler=book.userId;
      } else {
        print(response.statusCode);
        print("---ERRO1---");
      }
    }).catchError((e){
      print("---ERRO2---");
      print("----- "+e.toString()+" -----");
    });
  }

  Future getSellerUser(id) async {
    var parsedData;
    print("getSellerUser "+id);
    Map data = {
      "user_id": id
    };

    var response = await post("https://huwamaruwa-app.herokuapp.com/getuser", headers: <String, String>{
      'Content-Type': 'application/json',
    },body:jsonEncode(data)).then((response){
      // print(response.body);
      if(response.statusCode == 200) {
        Map<String, dynamic> userDataMap = jsonDecode(response.body);
        print(response.body);
        setState(() {
          u = user.fromJson(userDataMap);
          // userseller=u.name;
          _userSeller.text=u.name;
          print("Set Seller");
        });
      } else {
        print(response.statusCode);
        print("---ERRO1---");
      }
    }).catchError((e){
      print("---ERRO2---");
      print("----- "+e.toString()+" -----");
    });
  }


  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
//    String location = widget.location == "ALL" ? "All Island" : widget.city;
    return Scaffold(
      appBar: CustomAppBar(title: "HUWAMARUWA", bell_icon: true,),
      drawer: CustomDrawer(),
      body: isLoading ? CustomProgressIndicator() :
      true ?
      Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child:ClipPath(
              clipper: ProfileClipper(),
              child: Container(
                width: size.width,
                height: 200,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          UI_Data.Custom_App_Header_color1,
                          UI_Data.Custom_App_Header_color2
                        ]
                    )
                ),
                child: SizedBox(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 5.0,),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount:  1,
                    itemBuilder: (context, index) {
                      return resultWidget();
                      // return resultLocation(serviceTypeLocationList[index]);
                    },
                  )
                ),
                isLoadingLoadMore ?
                Container(
                    width: 20.0,
                    height: 20.0,
                    margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                    child: CircularProgressIndicator()
                ) : SizedBox(),
                SizedBox(height: 100.0,),
              ],
            ),
          ),
          SizedBox(height: 20.0,),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(backgroundColor: Colors.orange, child: Icon(Icons.add), elevation: 0.1, onPressed: () {
                      Get.toNamed("/add_new_screen");
                    }),
                  ),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color: currentIndex == 0 ? Colors.orange : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            print("1");
                            setBottomBarIndex(0);
                            Get.toNamed("/home_screen");
                          },
                          splashColor: Colors.white,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.account_balance_sharp,
                              color: currentIndex == 1 ? Colors.orange : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              Get.toNamed("/request_screen");
                              setBottomBarIndex(1);
                            }),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: currentIndex == 2 ? Colors.orange : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(2);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.person,
                              color: currentIndex == 3 ? Colors.orange : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(3);
                              Get.toNamed("/Profile");
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ) :
      Center(
        child: Text(
          "No Data Available",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: Get.height < 680 ? 15.0 : 18.0,
                  fontWeight: FontWeight.w700
              )
          ),
          maxLines: 2,
        ),
      ),
    );
  }
  double tempRating = 0;
  Widget resultWidget() {
    return (book!=null)?Container(
      padding: EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 5),
      child: Column(
        children: [
          RaisedButton(
            color: Colors.black54,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                side: BorderSide(
                    color: Colors.black54
                )
            ),
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        book.bookName,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: Get.height < 680 ? 18.0 : 21.0,
                            )),
                      ),
                      SizedBox(
                        width: Get.height < 680 ? 10.0 : 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Text(book.listingType,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                    Get.height < 680 ? 12.0 : 15.0,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  ClipRRect(
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                    child:  Image.memory(base64Decode(UI_Data.addImg),
                      colorBlendMode: BlendMode.darken,
                      color: Colors.black12,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600,
                              fontSize: Get.height < 680 ? 10.0 : 14.0,
                            )),
                      ),
                      SizedBox(
                        width: Get.height < 680 ? 10.0 : 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Text("LKR "+book.price.toString()+"0",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                    Get.height < 680 ? 10.0 : 14.0,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ISBN",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600,
                              fontSize: Get.height < 680 ? 10.0 : 14.0,
                            )),
                      ),
                      SizedBox(
                        width: Get.height < 680 ? 10.0 : 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Text(book.isbn,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                    Get.height < 680 ? 10.0 : 14.0,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Author",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600,
                              fontSize: Get.height < 680 ? 10.0 : 14.0,
                            )),
                      ),
                      SizedBox(
                        width: Get.height < 680 ? 10.0 : 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Text(book.author,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                    Get.height < 680 ? 10.0 : 14.0,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ISBN",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600,
                              fontSize: Get.height < 680 ? 10.0 : 14.0,
                            )),
                      ),
                      SizedBox(
                        width: Get.height < 680 ? 10.0 : 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Text(book.isbn,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                    Get.height < 680 ? 10.0 : 14.0,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: RaisedButton(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10.0,),
                          Text(
                            "Call Now",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: Get.height < 680 ? 10.0 : 15.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      onPressed: (){
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 40.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: RaisedButton(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10.0,),
                          Text(
                            "Chat Now",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: Get.height < 680 ? 10.0 : 15.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      onPressed: (){
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child:  TextFormField(
                            controller: _userSeller,
                            cursorColor: Theme.of(context).cursorColor,
                            enabled: false,
                            // initialValue: userseller,
                            maxLength: 20,
                            decoration: InputDecoration(
                              icon: Icon(Icons.verified_user),
                              labelText: 'Seller',
                              labelStyle: TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              helperText: 'Charitha Nuwan',
                              // suffixIcon: Icon(
                              //   Icons.check_circle,
                              // ),
                              // enabledBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(color: Color(0xFF6200EE)),
                              // ),
                            ),

                          ),
                        ),
                      ],
                    ),
                    onTap: (){
                      Get.toNamed("/SellerProfile?Id="+u.userId.toString()+"&UserId="+u.userId.toString());
                    },
                  ),
                  SizedBox(height: 5.0,),
                  RatingBar.builder(
                    initialRating:tempRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(
                        horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (val){
                      tempRating=val;
                    },
                    ignoreGestures: false,
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 40.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10.0,),
                          Text(
                            "Reviews",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: Get.height < 680 ? 12.0 : 18.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      onPressed: (){
                      },
                    ),
                  ),
                  SizedBox(height: 10.0,),
//                    serviceFacility.serviceShortDescription != null ?
                  ExpandText(
                    "Harry Potter is a series of seven fantasy novels written by British author J. K. Rowling. The novels chronicle the lives of a young wizard, Harry Potter, and his friends Hermione Granger and Ron Weasley, all of whom are students at Hogwarts School of Witchcraft and Wizardry. ",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: Get.height < 680 ? 10.0 : 12.0,
                            fontWeight: FontWeight.w500)),
                    textAlign: TextAlign.start,
                    collapsedHint: "See More",
                    expandedHint: "See Less",
                    expandArrowStyle: ExpandArrowStyle.both,
                    arrowSize: 15.0,
                    hintTextStyle: TextStyle(fontSize: 12.0),
                    expandOnGesture: false,
                    maxLines: 3,
                  )
                ],
              ),
            ),
            onPressed: (){
            },
          ),
        ],
      ),
    ):SizedBox();
  }


}

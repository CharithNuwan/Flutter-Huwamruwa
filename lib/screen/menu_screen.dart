import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:huwamaruwa/custom_widgets/custom_app_bar.dart';
import 'package:huwamaruwa/custom_widgets/custom_drawer.dart';
import 'package:huwamaruwa/custom_widgets/custom_floating_action_button.dart';
import 'package:huwamaruwa/custom_widgets/profile_clipper.dart';
import 'package:huwamaruwa/dto/ListingBook.dart';
import 'package:huwamaruwa/dto/booklist.dart';
import 'package:huwamaruwa/dto/cart_dto.dart';
import 'package:huwamaruwa/routes/routes.dart';
import 'package:huwamaruwa/screen/login_screen.dart';
import 'package:huwamaruwa/services/UI_Data.dart';
import 'package:intl/intl.dart';
import 'dart:ui';



class HomeScreen extends StatefulWidget {
  static const String routeName = '/home_screen';
  String Id = (Get.parameters['Id']!=null)?Get.parameters['Id']:"0";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


bool isLoading=false;

List<Cart> activityHistoryList = [];

Book book_map;

class _HomeScreenState extends State<HomeScreen> {


  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  int categoryID=0;

  @override
  void initState() {
    super.initState();
    categoryID=(widget.Id!="0")?int.parse(widget.Id):0;
    // if(LoginScreen.flage){
    // }
    (categoryID!=0)?getBookBySategory(categoryID):getCivilStatus();
  }

  Future getCivilStatus() async {
    var parsedData;
    print("getCivilStatus");
    Map data = {
      "sessionId": "sessionId",
      "apiVersion": "1.0.00",
      "paylord":{}
    };

    var response = await post("https://huwamaruwa-app.herokuapp.com/booklist", headers: <String, String>{
      'Content-Type': 'application/json',
    },body:jsonEncode(data)).then((response){
      if(response.statusCode == 200) {
        Map<String, dynamic> userDataMap = jsonDecode(response.body);
        print(response.body);
        setState(() {
          book_map = Book.fromJson(userDataMap);
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

  Future getBookBySategory(id) async {
    var parsedData;
    print("getCivilStatus"+id.toString());
    Map data = {
      "categoryid": id
    };

    var response = await post("https://huwamaruwa-app.herokuapp.com/bookscategory", headers: <String, String>{
      'Content-Type': 'application/json',
    },body:jsonEncode(data)).then((response){
      if(response.statusCode == 200) {
        Map<String, dynamic> userDataMap = jsonDecode(response.body);
        print(response.body);
        setState(() {
          book_map = Book.fromJson(userDataMap);
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

  void onTabTapped(int index) {
    setState(() {
      print(index.toString());
    });
  }



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(title: "HUWAMARUWA", bell_icon: true,),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white.withAlpha(70),
      body: Stack(
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
          Positioned(
          top: 10,
          left: 5,
          right:0.0,
          bottom:0.0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: locationPicker(),
                ),
                Container(
                  padding:EdgeInsets.only(top: 20,left: 35,right: 35),
                  child: (book_map!=null)?activityHistory():SizedBox(),
                ),
                SizedBox(
                  height: 100.0,
                ),
              ],
            ),
          ),
        ),
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
                            Get.toNamed('/home_screen');
                            setBottomBarIndex(0);
                          },
                          splashColor: Colors.white,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.collections_bookmark,
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
                              // Get.toNamed("/complain_screen");
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
      ),
      // floatingActionButton: CustomFloatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, // new

    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


Widget activityHistory() {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: book_map.booklist.length,
    itemBuilder: (context, index) {
     if (book_map.booklist.length != 0) {
      return Container(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.grey[900],
                border: Border.all(color: Colors.amber[600])),
            child: Column(
              children: [
                GestureDetector(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              book_map.booklist[index].bookName,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.amber[600],
                                  fontSize: Get.height < 680 ? 12.0 : 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                book_map.booklist[index].listingType,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: Get.height < 680 ? 10.0 : 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
//                              Text(
//                                "2021/05/18",
//                                style: GoogleFonts.poppins(
//                                  textStyle: TextStyle(
//                                    color: Colors.grey[400],
//                                    fontSize: Get.height < 680 ? 10.0 : 12.0,
//                                    fontWeight: FontWeight.w500,
//                                  ),
//                                ),
//                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: 250,
                        height: 180,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0))),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          child:  Image.memory(base64Decode(book_map.booklist[index].image),
                            colorBlendMode: BlendMode.darken,
                            color: Colors.black12,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: (){
                    UI_Data.addImg=book_map.booklist[index].image;
                    Get.toNamed("/des?Id="+book_map.booklist[index].listingBookId.toString()+"&SellerId="+book_map.booklist[index].userId.toString());
                  },
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      ],
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
//                          Text(
//                            "Slot",
//                            style: GoogleFonts.poppins(
//                              textStyle: TextStyle(
//                                color: Colors.grey[400],
//                                fontSize: Get.height < 680 ? 12.0 : 14.0,
//                                fontWeight: FontWeight.w700,
//                              ),
//                            ),
//                            textAlign: TextAlign.start,
//                          ),
                      ],
                    ),
                     // SizedBox(
                     //   height: 15.0,
                     // ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 10.0),
//                       child: Column(
//                         children: [
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
                                    Text("LKR "+book_map.booklist[index].price.toString()+".00",
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
                                    Text(book_map.booklist[index].author,
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
                          SizedBox(
                            height: 5.0,
                          ),
//                           Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "View More..",
//                                 style: GoogleFonts.poppins(
//                                     textStyle: TextStyle(
//                                       color: Colors.grey[400],
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: Get.height < 680 ? 10.0 : 14.0,
//                                     )),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.all(2.0),
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: Colors.amber[600],
//                                     ),
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(10.0))),
//                                 child: Row(
//                                   children: [
//                                     SizedBox.fromSize(
//                                       size: Size(56, 40), // button width and height
//                                       child: ClipOval(
//                                         child: Material(
//                                           color: Colors.redAccent, // button color
//                                           child: InkWell(
//                                             splashColor: Colors.redAccent, // splash color
//                                             onTap: () {
// //                                                Navigator.pushReplacementNamed(context, Routes.des);
//                                               Get.toNamed("/des?Id="+index.toString());
//                                             }, // button pressed
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: <Widget>[
//                                                 Icon(Icons.work), // icon
//                                                 Text("Buy"), // text
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     )
// //                                      Text(
// //                                        DateFormat.Hm().format(DateTime.parse(
// //                                            activityHistoryList[index]
// //                                                .slotStartTime)) +
// //                                            " - " +
// //                                            DateFormat.Hm().format(
// //                                                DateTime.parse(
// //                                                    activityHistoryList[index]
// //                                                        .slotEndTime)),
// //                                        style: GoogleFonts.poppins(
// //                                            textStyle: TextStyle(
// //                                              color: Colors.amber[600],
// //                                              fontWeight: FontWeight.w600,
// //                                              fontSize:
// //                                              Get.height < 680 ? 10.0 : 14.0,
// //                                            )),
// //                                      ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10.0,
//                           ),
// //                            Row(
// //                              mainAxisAlignment: MainAxisAlignment.end,
// //                              children: [
// //                                Text(
// //                                  activityHistoryList[index].slotPrice,
// //                                  style: GoogleFonts.poppins(
// //                                      textStyle: TextStyle(
// //                                          color: Colors.white,
// //                                          fontSize:
// //                                          Get.height < 680 ? 12.0 : 16.0,
// //                                          fontWeight: FontWeight.w700)),
// //                                ),
// //                              ],
// //                            ),
//                         ],
//                       ),
//                     ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
     } else {
       return SizedBox();
     }
    },
  );
}

Widget locationPicker() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40.0,
        width: Get.width - 85,
        decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey[900],
                  blurRadius: 10.0
              )
            ]
        ),
        child: OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.search,
                  color: Colors.amber[600],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.list,
                        size: Get.height < 680 ? 10.0 : 15.0,
                        color: Colors.amber[600],
                      ),
                      onTap: (){
                        Get.toNamed("/ad_search_screen");
                      },
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Search",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.amber[600],
                              fontSize: Get.height < 680 ? 10.0 : 15.0,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              )
            ],
          ),
          highlightedBorderColor: Colors.transparent,
          borderSide: BorderSide(
              color: Colors.transparent
          ),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)
          ),
          onPressed: () {
            print("On Tap");
////            showSearch(
//                context: context,
//                delegate: SearchDataProcessCategory()
//            );
            // Get.toNamed('/service-types-with-category');
          },
        ),
      ),
//      SizedBox(width: 10.0,),
//      Container(
//        height: 40.0,
//        width: 40.0,
//        decoration: BoxDecoration(
//            color: Colors.grey[800],
//            borderRadius: BorderRadius.all(Radius.circular(10.0)),
//            boxShadow: <BoxShadow>[
//              BoxShadow(
//                  color: Colors.grey[900],
//                  blurRadius: 10.0
//              )
//            ]
//        ),
//        child: OutlineButton(
//          padding: EdgeInsets.all(5.0),
//          child: Center(
//            child: Icon(
//              Icons.gps_fixed,
//              color: Colors.red[400],
//            ),
//          ),
//          highlightedBorderColor: Colors.transparent,
//          borderSide: BorderSide(
//              color: Colors.transparent
//          ),
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(10.0)
//          ),
//          onPressed: () {
////            showXMileRadius();
//          },
//        ),
//      ),
    ],
  );
}

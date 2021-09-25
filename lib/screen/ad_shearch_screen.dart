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
import 'package:huwamaruwa/dto/category.dart';
import 'package:huwamaruwa/routes/routes.dart';
import 'package:huwamaruwa/screen/login_screen.dart';
import 'package:huwamaruwa/services/UI_Data.dart';
import 'package:intl/intl.dart';
import 'dart:ui';



class AdSearchScreen extends StatefulWidget {
  static const String routeName = '/ad_search_screen';
  @override
  _AdSearchScreenState createState() => _AdSearchScreenState();
}


bool isLoading=false;

List<Cart> activityHistoryList = [];

Book book_map;

class _AdSearchScreenState extends State<AdSearchScreen> {


  int currentIndex = 0;
  category c;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if(LoginScreen.flage){
    }
    getCivilStatus();
    getCategory();
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



  Future getCategory() async {
    // setState(() {
    //   isLoading=true;
    // });
    var parsedData;
    print("getCategory");
    Map data = {
      "user_id": "b"
    };

    var response = await post("https://huwamaruwa-app.herokuapp.com/allcategory", headers: <String, String>{
      'Content-Type': 'application/json',
    },).then((response){
      // print(response.body);
      if(response.statusCode == 200) {
        Map<String, dynamic> userDataMap = jsonDecode(response.body);
        print(response.body);
        c=category.fromJson(userDataMap);
        // for(int i=0;i<c.categorylist.length;i++){
        //   _categoryTypes.add(c.categorylist[i].categoryName);
        //   _categoryTypesid.add(c.categorylist[i].categoryID);
        // }
        setState(() {
          isLoading=false;
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
      appBar: CustomAppBar(title: "Category Search", bell_icon: true,),
      // drawer: CustomDrawer(),
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
            top: 50,
            left: 5,
            right:5.0,
            bottom:0.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Container(
                  //   padding: EdgeInsets.only(top: 20),
                  //   child: locationPicker(),
                  // ),
                  Container(
                    padding:EdgeInsets.all(10),
                    child: (c!=null)?activityHistory():SizedBox(),
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


  Widget activityHistory() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: c.categorylist.length,
      itemBuilder: (context, index) {
        if (c.categorylist != null) {
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
                    // Divider(),
                    // Divider(),
                    Column(
                      children: [
                        SizedBox(height: 5,),
                        GestureDetector(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.menu_book,
                                      size: Get.height < 680 ? 12.0 : 18.0,
                                      color: Colors.amber[600],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Text(c.categorylist[index].categoryName,
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
                              Container(
                                padding: EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: Material(
                                        color: Colors.grey, // Button color
                                        child: InkWell(
                                          splashColor: Colors.red, // Splash color
                                          onTap: () {},
                                          child: SizedBox(width: 23, height: 23, child: Icon(Icons.arrow_forward_ios)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: (){
                            Get.toNamed("/home_screen?Id="+c.categorylist[index].categoryID.toString());
                          },
                        ),
                        SizedBox(height: 5,),
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

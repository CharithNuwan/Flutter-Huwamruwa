import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:huwamaruwa/custom_widgets/custom_app_bar.dart';
import 'package:huwamaruwa/custom_widgets/custom_drawer.dart';
import 'package:huwamaruwa/custom_widgets/custom_progress_indicator.dart';
import 'package:huwamaruwa/custom_widgets/profile_clipper.dart';
import 'package:huwamaruwa/dto/booklist.dart';
import 'package:huwamaruwa/dto/user.dart';
import 'package:huwamaruwa/services/UI_Data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/Profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  bool isLoading = false;
  bool _reSized = false;
  bool _visible = false;
  bool readOnly = false;


  int user_id=0;
  int user_rate=0;
  String email="";
  String name="";
  String tp="";
  String toprate="";

  Book book_map;






  @override
  void initState() {
    super.initState();
    getUserStatus();
    getCivilStatus();
  }
  SharedPreferences sharedPreferences;
  Future getUserStatus() async {
    setState(() {
      isLoading=true;
    });
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      user_id=sharedPreferences.getInt("user");
      user_rate=sharedPreferences.getInt("user_rate");
      email=sharedPreferences.getString("email");
      name=sharedPreferences.getString("name");
      tp=sharedPreferences.getString("tp");
      toprate=sharedPreferences.getString("toprate");
    });


    setState(() {
      isLoading=false;
    });

  }

  Future getCivilStatus() async {
    int userid=0;
    setState(() {
      isLoading=false;
    });
    print("--- getCivilStatus---");
    sharedPreferences = await SharedPreferences.getInstance();
    userid=sharedPreferences.getInt("user");
    Map data = {
      "user_id":userid
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


  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
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
      appBar: CustomAppBar(title: "My Profile", bell_icon: true,),
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
                top: 15,
                left: 15,
                child: profileName(),
          ),
          Positioned(
                  top: 25,
                  left: Get.width * 0.35,
                  child: profileWidget()
          ),
          Positioned(
            top: 200,
            left: 5,
            right:0.0,
            bottom:0.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: personalInformation(),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: myadd(),
                  ),
                  // Container(
                  //   padding:EdgeInsets.only(top: 20,left: 35,right: 35),
                  //   child: activityHistory(),
                  // ),
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
                              Get.toNamed("/complain_screen");
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
      itemCount:book_map.booklist.length,
      itemBuilder: (context, index) {
        if (book_map.booklist.length!=0) {
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
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              book_map.booklist[index].bookName,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize: Get.height < 680 ? 8.0 : 12.0,
                                  )),
                            ),
                            // Text(
                            //   book_map.booklist[index].author,
                            //   style: GoogleFonts.poppins(
                            //       textStyle: TextStyle(
                            //         color: Colors.grey[400],
                            //         fontWeight: FontWeight.w600,
                            //         fontSize: Get.height < 680 ? 10.0 : 14.0,
                            //       )),
                            // ),
                            Text(
                              "LKR "+book_map.booklist[index].price.toString()+".00",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize: Get.height < 680 ? 10.0 : 14.0,
                                  )),
                            ),
                            ClipOval(
                              child: Material(
                                color: Colors.redAccent, // Button color
                                child: InkWell(
                                  splashColor: Colors.red, // Splash color
                                  onTap: () {},
                                  child: SizedBox(width: 23, height: 23, child: Icon(Icons.delete)),
                                ),
                              ),
                            ),
                          ],
                        ),
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
    // }

  }

  Widget profileWidget() {
    return Container(
      child: Column(
        children: [
          Container(
            width: Get.width,
            height: 200,
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
//                 Badge(
//                     badgeColor: Colors.black54,
//                     shape: BadgeShape.circle,
//                     toAnimate: false,
//                     // badgeContent: Icon(
//                     //   Icons.camera_enhance,
//                     //   color: Colors.white30,
//                     //   size: Get.height < 680 ? 15.0 : 18.0,
//                     // ),
// //                    position: BadgePosition.bottomRight(bottom: 0,right: 0,),
//                     child: GestureDetector(
//                       onTap: (){
// //                        if(!readOnly){
// //                          print("Photo tap");
// //                         SweetAlert.show(context,
// //                             cancelButtonText: "label.proxone.sign.up.page.screen.camera".trArgs(),
// //                             cancelButtonColor: Colors.amber[600],
// //                             confirmButtonText: "label.proxone.sign.up.page.screen.gallery".trArgs(),
// //                             confirmButtonColor: Colors.amber[600],
// //                             showCancelButton: true,
// //                             onPress: (bool isConfirm) {
// //                               if(isConfirm){
// //                                 imgTypeProfile="Profile";
// //                                 imgTypebase="Profile";
// //                                 openGalary(context);
// //                               }else{
// //                                 imgTypeProfile="Profile";
// //                                 imgTypebase="Profile";
// //                                 openCamara(context);
// //                               }
// //                               return false;
// //                             });
// //                        }
//                       },
//                       child: Container(
//                         width: Get.height < 680 ? 80.0 : 100.0,
//                         height: Get.height < 680 ? 80.0 : 100.0,
//                         // child: setProfile(),
//                       ),
//                     )
//                 ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileName() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0,),
          Container(
            width: Get.width - 50,
            child: AutoSizeText(
              name,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.grey[700],
                  fontSize: Get.height < 680 ? 15.0 : 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              minFontSize: Get.height < 680 ? 12.0 : 15.0,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            width: Get.width - 50,
            child: AutoSizeText(
              email,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.grey[700],
                  fontSize: Get.height < 680 ? 12.0 : 15.0,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2.85,
                ),
              ),
              minFontSize: Get.height < 680 ? 10.0 : 12.0,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget informationBox() {
    return Visibility(
      visible: _reSized,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 1000),
        onEnd: () {
          setState(() {
            _reSized = false;
          });
          // readInfo();
        },
        child: Container(
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
                color: Colors.amber[600],
                width: 2
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  "profile edit",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.amber[600],
                          fontSize: Get.height < 680 ? 10.0 : 12.0,
                          fontWeight: FontWeight.w500)),
                  maxLines: 2,
                ),
              ),
              IconButton(
                splashColor: Colors.amber[800],
//                splashRadius: 5.0,
                icon: Icon(
                  Icons.highlight_off,
                  size: Get.height < 680 ? 15.0 : 20.0,
                  color: Colors.amber[600],
                ),
                onPressed: () {
                  setState(() {
                    _visible = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget personalInformation() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
          )
        ],
      ),
      child: Container(
//        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.grey[600],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.amber[400],
                      Colors.amber[600]
                    ]
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Details",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: Get.height < 680 ? 12.0 : 15.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    splashColor: Colors.amber[600],
//                    splashRadius: 5.0,

                    icon: Icon(
                      Icons.verified_user,
                      size: Get.height < 680 ? 15.0 : 20.0,
                      color: readOnly ? Colors.grey[600] : Colors.grey[900],
                    ),
                    onPressed: () {
                      setState(() {
                        readOnly = !readOnly;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)
                  ),
                  border: Border.all(
                      color: Colors.amber
                  )
              ),
              child: Form(
                // key: _formKey_pi,
                child: Column(
                  children: [
                    Container(
                      child: TextFormField(
                        // controller: _tf_pi_fn,
                        // focusNode: focus_tf_pi_fn,
                        readOnly: readOnly,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: Get.height < 680 ? 12.0 : 15.0,
                                fontWeight: FontWeight.w600)),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                          prefixIcon: Icon(
                            Icons.person,
                            size: 22.0,
                          ),
                          hintText: name,
                          hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: Get.height < 680 ? 12.0 : 15.0,
                              fontWeight: FontWeight.w600),
                          enabledBorder: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber[600], width: 2.0),
                          ),
                        ),
                        validator: (value){
// //                          print("First Name");
//                           if(value.isEmpty){
//                             validate_fn=false;
//                             return "label.proxone.sign.up.page.screen.please.enter.your.first.name".trArgs();
//                           }else{
//                             validate_fn=true;
//                           }
                        },
                      ),
                    ),
                    // SizedBox(height: 5.0,),
//                     Container(
//                       child: TextFormField(
//                         // controller: _tf_pi_ln,
//                         // focusNode: focus_tf_pi_ln,
//                         readOnly: readOnly,
//                         style: GoogleFonts.poppins(
//                             textStyle: TextStyle(
//                                 color: Colors.grey[400],
//                                 fontSize: Get.height < 680 ? 12.0 : 15.0,
//                                 fontWeight: FontWeight.w600)),
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
//                           prefixIcon: Icon(
//                             Icons.person,
//                             size: 22.0,
//                           ),
//                           hintText: "Bandara",
//                           hintStyle: TextStyle(
//                               color: Colors.grey[400],
//                               fontSize: Get.height < 680 ? 12.0 : 15.0,
//                               fontWeight: FontWeight.w600),
//                           enabledBorder: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.amber[600], width: 2.0),
//                           ),
//                         ),
//                         validator: (value){
// // //                          print("Last Name ");
// //                           if(value.isEmpty){
// //                             validate_ln=false;
// //                             return "label.proxone.sign.up.page.screen.please.enter.your.last.name".trArgs();
// //                           }else{
// //                             validate_ln=true;
// //                           }
//                         },
//                       ),
//                     ),
                    SizedBox(height: 5.0,),
                    Container(
                      child: TextFormField(
                        // controller: _tf_pi_email,
                        // focusNode: focus_tf_pi_email,
                        readOnly: true,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: Get.height < 680 ? 12.0 : 15.0,
                                fontWeight: FontWeight.w600)),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                            prefixIcon: Icon(
                              Icons.email,
                              size: 22.0,
                            ),
                            hintText: email,
                            hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: Get.height < 680 ? 12.0 : 15.0,
                                fontWeight: FontWeight.w600),
                            enabledBorder: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber[600], width: 2.0),
                            )
                        ),
                        validator: (value){
// //                          print("email");
//                           if(value.isEmpty){
//                             validate_email=false;
//                             return "label.proxone.sign.up.page.screen.please.enter.your.email".trArgs();
//                           }else{
//                             if(!EmailValidator.validate(_tf_pi_email.text)){
//                               validate_email=false;
//                               return "label.proxone.sign.up.page.screen.please.enter.valid.email".trArgs();
//                             }else{
//                               validate_email=true;
//                             }
//                           }
                        },
                      ),
                    ),
//                     SizedBox(height: 5.0,),
//                     Container(
//                       child: TextFormField(
//                         // controller: _tf_pi_email,
//                         // focusNode: focus_tf_pi_email,
//                         readOnly: true,
//                         style: GoogleFonts.poppins(
//                             textStyle: TextStyle(
//                                 color: Colors.grey[400],
//                                 fontSize: Get.height < 680 ? 12.0 : 15.0,
//                                 fontWeight: FontWeight.w600)),
//                         decoration: InputDecoration(
//                             contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
//                             prefixIcon: Icon(
//                               Icons.map,
//                               size: 22.0,
//                             ),
//                             hintText: "Rathnapura",
//                             hintStyle: TextStyle(
//                                 color: Colors.grey[400],
//                                 fontSize: Get.height < 680 ? 12.0 : 15.0,
//                                 fontWeight: FontWeight.w600),
//                             enabledBorder: InputBorder.none,
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.amber[600], width: 2.0),
//                             )
//                         ),
//                         validator: (value){
// // //                          print("email");
// //                           if(value.isEmpty){
// //                             validate_email=false;
// //                             return "label.proxone.sign.up.page.screen.please.enter.your.email".trArgs();
// //                           }else{
// //                             if(!EmailValidator.validate(_tf_pi_email.text)){
// //                               validate_email=false;
// //                               return "label.proxone.sign.up.page.screen.please.enter.valid.email".trArgs();
// //                             }else{
// //                               validate_email=true;
// //                             }
// //                           }
//                         },
//                       ),
//                     ),
                    SizedBox(height: 5.0,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget myadd() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
          )
        ],
      ),
      child: Container(
//        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.grey[600],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.amber[400],
                      Colors.amber[600]
                    ]
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Adds",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: Get.height < 680 ? 12.0 : 15.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    splashColor: Colors.amber[600],
//                    splashRadius: 5.0,

                    icon: Icon(
                      Icons.add_circle_outline_sharp,
                      size: Get.height < 680 ? 15.0 : 20.0,
                      color: readOnly ? Colors.grey[600] : Colors.grey[900],
                    ),
                    onPressed: () {
                      setState(() {
                        readOnly = !readOnly;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)
                  ),
                  border: Border.all(
                      color: Colors.amber
                  )
              ),
              child: (book_map!=null)?activityHistory():Container(),
            ),
          ],
        ),
      ),
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


// Widget activityHistory() {
//   return ListView.builder(
//     shrinkWrap: true,
//     physics: NeverScrollableScrollPhysics(),
//     itemCount: book_map.booklist.length,
//     itemBuilder: (context, index) {
//       if (book_map.booklist.length != 0) {
//         return Container(
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(10.0),
//               ),
//             ),
//             elevation: 2.0,
//             child: Container(
//               padding: EdgeInsets.all(10.0),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                   color: Colors.grey[900],
//                   border: Border.all(color: Colors.amber[600])),
//               child: Column(
//                 children: [
//                   GestureDetector(
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: AutoSizeText(
//                                 book_map.booklist[index].bookName,
//                                 style: GoogleFonts.poppins(
//                                   textStyle: TextStyle(
//                                     color: Colors.amber[600],
//                                     fontSize: Get.height < 680 ? 12.0 : 15.0,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                                 maxLines: 2,
//                                 textAlign: TextAlign.start,
//                               ),
//                             ),
//                             Column(
//                               children: [
//                                 Text(
//                                   book_map.booklist[index].listingType,
//                                   style: GoogleFonts.poppins(
//                                     textStyle: TextStyle(
//                                       color: Colors.grey[400],
//                                       fontSize: Get.height < 680 ? 10.0 : 12.0,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
// //                              Text(
// //                                "2021/05/18",
// //                                style: GoogleFonts.poppins(
// //                                  textStyle: TextStyle(
// //                                    color: Colors.grey[400],
// //                                    fontSize: Get.height < 680 ? 10.0 : 12.0,
// //                                    fontWeight: FontWeight.w500,
// //                                  ),
// //                                ),
// //                              ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10.0,
//                         ),
//                         Container(
//                           width: 250,
//                           height: 180,
//                           decoration: BoxDecoration(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(10.0))),
//                           child: ClipRRect(
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(10.0)),
//                             child:  Image.memory(base64Decode(book_map.booklist[index].image),
//                               colorBlendMode: BlendMode.darken,
//                               color: Colors.black12,
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: (){
//                       UI_Data.addImg=book_map.booklist[index].image;
//                       Get.toNamed("/des?Id="+book_map.booklist[index].listingBookId.toString()+"&SellerId="+book_map.booklist[index].userId.toString());
//                     },
//                   ),
//                   Divider(),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                         ],
//                       ),
//                     ],
//                   ),
//                   Divider(),
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
// //                          Text(
// //                            "Slot",
// //                            style: GoogleFonts.poppins(
// //                              textStyle: TextStyle(
// //                                color: Colors.grey[400],
// //                                fontSize: Get.height < 680 ? 12.0 : 14.0,
// //                                fontWeight: FontWeight.w700,
// //                              ),
// //                            ),
// //                            textAlign: TextAlign.start,
// //                          ),
//                         ],
//                       ),
//                       // SizedBox(
//                       //   height: 15.0,
//                       // ),
// //                     Padding(
// //                       padding: EdgeInsets.only(left: 10.0),
// //                       child: Column(
// //                         children: [
//                       Row(
//                         mainAxisAlignment:
//                         MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Price",
//                             style: GoogleFonts.poppins(
//                                 textStyle: TextStyle(
//                                   color: Colors.grey[400],
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: Get.height < 680 ? 10.0 : 14.0,
//                                 )),
//                           ),
//                           SizedBox(
//                             width: Get.height < 680 ? 10.0 : 15.0,
//                           ),
//                           Container(
//                             padding: EdgeInsets.all(2.0),
//                             child: Row(
//                               children: [
//                                 Text("LKR "+book_map.booklist[index].price.toString()+"0",
//                                   style: GoogleFonts.poppins(
//                                       textStyle: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontWeight: FontWeight.w600,
//                                         fontSize:
//                                         Get.height < 680 ? 10.0 : 14.0,
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment:
//                         MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Author",
//                             style: GoogleFonts.poppins(
//                                 textStyle: TextStyle(
//                                   color: Colors.grey[400],
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: Get.height < 680 ? 10.0 : 14.0,
//                                 )),
//                           ),
//                           SizedBox(
//                             width: Get.height < 680 ? 10.0 : 15.0,
//                           ),
//                           Container(
//                             padding: EdgeInsets.all(2.0),
//                             child: Row(
//                               children: [
//                                 Text(book_map.booklist[index].author,
//                                   style: GoogleFonts.poppins(
//                                       textStyle: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontWeight: FontWeight.w600,
//                                         fontSize:
//                                         Get.height < 680 ? 10.0 : 14.0,
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 5.0,
//                       ),
// //                           Row(
// //                             mainAxisAlignment:
// //                             MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Text(
// //                                 "View More..",
// //                                 style: GoogleFonts.poppins(
// //                                     textStyle: TextStyle(
// //                                       color: Colors.grey[400],
// //                                       fontWeight: FontWeight.w600,
// //                                       fontSize: Get.height < 680 ? 10.0 : 14.0,
// //                                     )),
// //                               ),
// //                               Container(
// //                                 padding: EdgeInsets.all(2.0),
// //                                 decoration: BoxDecoration(
// //                                     border: Border.all(
// //                                       color: Colors.amber[600],
// //                                     ),
// //                                     borderRadius: BorderRadius.all(
// //                                         Radius.circular(10.0))),
// //                                 child: Row(
// //                                   children: [
// //                                     SizedBox.fromSize(
// //                                       size: Size(56, 40), // button width and height
// //                                       child: ClipOval(
// //                                         child: Material(
// //                                           color: Colors.redAccent, // button color
// //                                           child: InkWell(
// //                                             splashColor: Colors.redAccent, // splash color
// //                                             onTap: () {
// // //                                                Navigator.pushReplacementNamed(context, Routes.des);
// //                                               Get.toNamed("/des?Id="+index.toString());
// //                                             }, // button pressed
// //                                             child: Column(
// //                                               mainAxisAlignment: MainAxisAlignment.center,
// //                                               children: <Widget>[
// //                                                 Icon(Icons.work), // icon
// //                                                 Text("Buy"), // text
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     )
// // //                                      Text(
// // //                                        DateFormat.Hm().format(DateTime.parse(
// // //                                            activityHistoryList[index]
// // //                                                .slotStartTime)) +
// // //                                            " - " +
// // //                                            DateFormat.Hm().format(
// // //                                                DateTime.parse(
// // //                                                    activityHistoryList[index]
// // //                                                        .slotEndTime)),
// // //                                        style: GoogleFonts.poppins(
// // //                                            textStyle: TextStyle(
// // //                                              color: Colors.amber[600],
// // //                                              fontWeight: FontWeight.w600,
// // //                                              fontSize:
// // //                                              Get.height < 680 ? 10.0 : 14.0,
// // //                                            )),
// // //                                      ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                           SizedBox(
// //                             height: 10.0,
// //                           ),
// // //                            Row(
// // //                              mainAxisAlignment: MainAxisAlignment.end,
// // //                              children: [
// // //                                Text(
// // //                                  activityHistoryList[index].slotPrice,
// // //                                  style: GoogleFonts.poppins(
// // //                                      textStyle: TextStyle(
// // //                                          color: Colors.white,
// // //                                          fontSize:
// // //                                          Get.height < 680 ? 12.0 : 16.0,
// // //                                          fontWeight: FontWeight.w700)),
// // //                                ),
// // //                              ],
// // //                            ),
// //                         ],
// //                       ),
// //                     ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       } else {
//         return SizedBox();
//       }
//     },
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: CustomAppBar(title:"My Profile",bell_icon: true,),
//       body: isLoading ? CustomProgressIndicator() :
//       Column(
//         children: [
//           Stack(
//             children: [
//               ClipPath(
//                 clipper: ProfileClipper(),
//                 child: Container(
//                   width: size.width,
//                   height: 200,
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                           begin: Alignment.bottomLeft,
//                           end: Alignment.topRight,
//                           colors: [
//                             UI_Data.Custom_App_Header_color1,
//                             UI_Data.Custom_App_Header_color2,
//                           ]
//                       )
//                   ),
//                   child: SizedBox(),
//                 ),
//               ),
//               Positioned(
//                 top: 15,
//                 left: 15,
//                 child: profileName(),
//               ),
//               Positioned(
//                   top: 25,
//                   left: Get.width * 0.35,
//                   child: profileWidget()
//               ),
//               Positioned(
//                 top: 10,
//                 left: 5,
//                 right:0.0,
//                 bottom:0.0,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Container(
//                         padding:EdgeInsets.only(top: 20,left: 35,right: 35),
//                         child: activityHistory(),
//                       ),
//                       SizedBox(
//                         height: 100.0,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Positioned(
//               //   top: 200,
//               //   left: 0,
//               //   // right: 20,
//               //   width: Get.width,
//               //   height: 500,
//               //   child: Container(
//               //     padding: EdgeInsets.all(15.0),
//               //     child: Column(
//               //       children: [
//               //         // informationBox(),
//               //         // _reSized ? SizedBox(height: 10.0,) : SizedBox(),
//               //         personalInformation(),
//               //         SizedBox(height: 15.0,),
//               //         myadd(),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//

//

//





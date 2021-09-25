import 'dart:convert';

import 'dart:io' as img_io;

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
import 'package:huwamaruwa/custom_widgets/custom_progress_indicator.dart';
import 'package:huwamaruwa/custom_widgets/profile_clipper.dart';
import 'package:huwamaruwa/dto/ListingBook.dart';
import 'package:huwamaruwa/dto/booklist.dart';
import 'package:huwamaruwa/dto/cart_dto.dart';
import 'package:huwamaruwa/dto/category.dart';
import 'package:huwamaruwa/routes/routes.dart';
import 'package:huwamaruwa/screen/login_screen.dart';
import 'package:huwamaruwa/services/UI_Data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import 'package:sweetalert/sweetalert.dart';



class AddNewScreen2 extends StatefulWidget {
  static const String routeName = '/add_new_screen2';
  @override
  _AddNewScreen2State createState() => _AddNewScreen2State();
}


bool isLoading=false;

List<Cart> activityHistoryList = [];

Book book_map;

class _AddNewScreen2State extends State<AddNewScreen2> {


  int currentIndex = 0;

  String _professionType = null;
  List<String> _professionTypes=new List<String>();

  final TextEditingController des= new TextEditingController();
  final TextEditingController _price = new TextEditingController();


  String pathImgProfile="";
  String imgTypebase="Not_Available";
  String imgTypeProfile="Not_Available";
  img_io.File imageFile,profile;
  String img_profile=null;
  final picker = ImagePicker();
  bool validateprofile=false;
  bool isErrorProfile = false;
  double profile_hight=200;
  String profileUrl;
  category c;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _professionTypes.add("Red");
    _professionTypes.add("Black");
    if(LoginScreen.flage){
    }
    if(profileUrl==null){
      profileUrl=profileUrlDefolt;
    }
    getCategory();
  }

  List<String> _categoryTypes=new List<String>();
  List<int> _categoryTypesid=new List<int>();

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
        for(int i=0;i<c.categorylist.length;i++){
          _categoryTypes.add(c.categorylist[i].categoryName);
          _categoryTypesid.add(c.categorylist[i].categoryID);
        }
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



  openGalary(BuildContext context) async {
    try{
      setState(() {
        isLoading=true;
      });
      final picture =  await picker.getImage(source: ImageSource.gallery,maxHeight: 300,maxWidth: 650);
//      print(""+picture.path.toString());
      if(picture!=null){
        this.setState((){
          if(imgTypebase=="Profile"){
            if(picture!=null){
              // profileDataEdit.profileUrlExtension = picture.path.toString().split('.').last;
              profile = img_io.File(picture.path);
              final bytes = profile.readAsBytesSync();
              String base64Image = base64Encode(bytes);
              setState(() {
                img_profile=base64Image;
                isLoading=false;
              });
              // profileDataEdit.profileUrl=img_profile;
              // editProfileImage();
            }else{
              // profileDataEdit.profileUrl="";
              imgTypeProfile="Not_Available";
              imgTypebase = "Not_Available";
            }
          }else{
              // profileDataEdit.nicpictureback="";
              // imgTypeNIC2="Not_Available";
              // imgTypebase = "Not_Available";
            }
          }
      );
      }else{
      }
      profile =null;
    }catch(e){
    }
  }

  String profileUrlDefolt = "https://image.flaticon.com/icons/png/512/18/18601.png";



  void onTabTapped(int index) {
    setState(() {
      print(index.toString());
    });
  }


  void _changeProfessionType(String value){
    setState(() {
      _professionType="Aaa";
      // for(int i=0;i<ptr.payload.length;i++){
      //   if(ptr.payload[i].name==value){
      //     _professionTypeID=ptr.payload[i].id.toString();
      //     break;
      //   }
      // }
    });
  }

  Widget profileWidget() {
    return Container(
      child: Column(
        children: [
          Container(
            width: Get.width,
            height: 150,
            // padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Badge(
                  badgeColor: Colors.black54,
                  shape: BadgeShape.circle,
                  toAnimate: false,
                  badgeContent: Icon(
                    Icons.file_upload,
                    color: Colors.white30,
                    size: Get.height < 680 ? 12.0 : 18.0,
                  ),
                  position: BadgePosition.bottomEnd(bottom: 0,end: 0),
                  child:GestureDetector(
                    child:Container(
                      child:Container(
                        width: Get.height < 680 ? 60.0 : 100.0,
                        height: Get.height < 680 ? 60.0 : 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(style: BorderStyle.solid,color: Colors.white,width:3.5),
                          color:  Colors.grey[200],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:Image.network(profileUrl).image,
                          ),
                        ),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            // Icon(Icons.add_a_photo,color:Colors.white,size: 25,),
                          ],
                        ),
                      ),
                      // child: setProfile(),
                    ),
                    onTap: (){
                      print("Photo tap");
                      SweetAlert.show(context,
                          cancelButtonText: "Open Camera",
                          cancelButtonColor: Colors.amber[600],
                          confirmButtonText: "Open Gallery",
                          confirmButtonColor: Colors.amber[600],
                          showCancelButton: true,
                          onPress: (bool isConfirm) {
                            if(isConfirm){
                              imgTypeProfile="Profile";
                              imgTypebase="Profile";
                              setState(() {
                                isLoading=true;
                              });
                               openGalary(context);
                              Navigator.pop(context);
                            }else{
                              // setState(() {
                              //   isLoading=true;
                              // });
                              // imgTypeProfile="Profile";
                              // imgTypebase="Profile";
                              // openCamara(context);
                            }
                            return false;
                          });
                      // Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _listing_type;
  String _listing_type1;
  String _catogrory;
  int _catogroryid;
  String _district;
  bool checkedValue=false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(title: "HUWAMARUWA", bell_icon: true,),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white.withAlpha(70),
      body: isLoading ? CustomProgressIndicator() : Stack(
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
            width: MediaQuery.of(context).size.width,
            top: 20,
            left: 0,
            child:Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Colors.black38,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: des,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      // enabled: false,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.transparent),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.transparent),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          // prefixIcon: Icon(Icons.file_upload),
                          hintText: "Desceription",
                          filled: true,
                          fillColor: Colors.grey[200]),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.white,width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white),
                      child: Center(
                        child: DropdownButton<String>(
                          focusColor:Colors.white,
                          value: _listing_type,
                          // elevation: 5,
                          style: TextStyle(color: Colors.grey[800]),
                          iconEnabledColor:Colors.grey[800],
                          items: <String>[
                            'Shareable',
                            'Sell',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style:TextStyle(color:Colors.black),),
                            );
                          }).toList(),
                          hint:Text(
                            "Please choose a Listing Type",
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (String value) {
                            print(value.toString());
                            setState(() {
                              _listing_type = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _price,
                      enabled: false,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.transparent),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.transparent),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          // prefixIcon: Icon(Icons.file_upload),
                          hintText: 'please upload book image below',
                          filled: true,
                          fillColor: Colors.grey[200]),
                    ),
                    SizedBox(height: 5),
                    profileWidget(),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.white,width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white),
                      child: Center(
                        child: DropdownButton<String>(
                          focusColor:Colors.white,
                          value: _listing_type1,
                          // elevation: 5,
                          style: TextStyle(color: Colors.grey[800]),
                          iconEnabledColor:Colors.grey[800],
                          items: _categoryTypes.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style:TextStyle(color:Colors.black),),
                            );
                          }).toList(),
                          hint:Text(
                            "Please Select Category",
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _listing_type1 = value;
                            });
                            for(int f=0;f<_categoryTypes.length;f++){
                              if(value==_categoryTypes[f]){
                                _catogroryid=_categoryTypesid[f];
                                break;
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    updateButton(context),
                    SizedBox(height: 100),
                  ],
                ),
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
                    child: FloatingActionButton(backgroundColor: Colors.orange, child: Icon(Icons.add), elevation: 0.1, onPressed: () {}),
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
                              Icons.account_balance_sharp,
                              color: currentIndex == 1 ? Colors.orange : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(1);
                              Get.toNamed("/request_screen");
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
      ),
      // floatingActionButton: CustomFloatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, // new

    );
  }

  Widget updateButton(context) {
    return Container(
      height: 50.0,
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
              "Next",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.grey[900],
                      fontSize: Get.height < 680 ? 12.0 : 18.0,
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(width: 10,),
            // Icon(
            //   Icons.navigate_next_outlined,
            //   size: Get.height < 680 ? 18.0 : 25.0,
            //   color: Colors.grey[900],
            // ),
          ],
        ),
        onPressed: (){
          print(_listing_type);
          print(_listing_type1);
          UI_Data.listingType=_listing_type;
          UI_Data.catogory= _catogroryid;
          UI_Data.addImg= img_profile;
          UI_Data.des= des.text.toString();

          Get.toNamed("/add_new_screen3");
          // AddBook(context);
        },
      ),
    );
  }

  Future AddBook(context) async {
    // setState(() {
    //   isLoading=false;
    // });
    // print("---signupStep---");
    // sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.setString("email", email.toString());
    // // print("get Key "+prefs.getString(UiData.signup_authKey).toString());
    // Map data = {
    //   "email":email.toString(),
    //   "password":pass.toString()
    // };
    // Map<String, dynamic> userDataMap;
    // print(data);
    //
    //
    // // var response = await http.post(url);
    // // print('Response status: ${response.statusCode}');
    // // print('Response body: ${response.body}');
    //
    // var response = await post("https://huwamaruwa-app.herokuapp.com/user/verify", headers: <String, String>{
    //   'Content-Type': 'application/json',
    // },body:jsonEncode(data)).then((response){
    //   print(data);
    //   print(response.body.toString());
    //   userDataMap = jsonDecode(response.body.toString());
    //   print("---Response Status Code "+response.statusCode.toString()+"---");
    //   if(response.statusCode == 200) {
    //     Navigator.pushReplacementNamed(context, Routes.home);
    //     setState(() {
    //       isLoading=false;
    //     });
    //     // print(response.body);
    //   } else if(response.statusCode == 404) {
    //     print("---else---");
    //     setState(() {
    //       isLoading=false;
    //     });
    //     AwesomeDialog(context: context,
    //         dialogType: DialogType.ERROR,
    //         animType: AnimType.BOTTOMSLIDE,
    //         title: "Unsuccessful",
    //         desc: "login Unsuccessful",
    //         dismissOnTouchOutside: false,
    //         btnOkOnPress: () {
    //
    //         }).show();
    //     // print("---ERRO---");
    //   }else{
    //     setState(() {
    //       isLoading=false;
    //     });
    //     AwesomeDialog(context: context,
    //         dialogType: DialogType.ERROR,
    //         animType: AnimType.BOTTOMSLIDE,
    //         title: "Unsuccessful",
    //         desc: "Unexpected Error Occurred",
    //         dismissOnTouchOutside: false,
    //         btnOkOnPress: () {
    //         }).show();
    //     // print("---ERRO---");
    //   }
    // }).catchError((e){
    //   setState(() {
    //     isLoading=false;
    //   });
    //   print("---ERRO---");
    //   print("----- "+e+" -----");
    // });
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









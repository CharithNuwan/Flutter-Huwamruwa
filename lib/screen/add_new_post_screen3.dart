import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:huwamaruwa/routes/routes.dart';
import 'package:huwamaruwa/screen/login_screen.dart';
import 'package:huwamaruwa/services/UI_Data.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';



class AddNewScreen3 extends StatefulWidget {
  static const String routeName = '/add_new_screen3';
  @override
  _AddNewScreen3State createState() => _AddNewScreen3State();
}


bool isLoading=false;

List<Cart> activityHistoryList = [];

Book book_map;

class _AddNewScreen3State extends State<AddNewScreen3> {


  int currentIndex = 0;

  String _professionType = null;
  List<String> _professionTypes=new List<String>();

  final TextEditingController _book_title = new TextEditingController();
  final TextEditingController _author = new TextEditingController();
  final TextEditingController _isbn = new TextEditingController();
  final TextEditingController _qty = new TextEditingController();
  final TextEditingController _price = new TextEditingController();
  final TextEditingController _city = new TextEditingController();
  final TextEditingController _phone = new TextEditingController();
  // final TextEditingController _BookList = new TextEditingController();

  String listing_type = "";

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
    getCivilStatus();
  }

  Future getCivilStatus() async {
    var parsedData;
    print("getCivilStatus");
    Map data = {
      "sessionId": "sessionId",
      "apiVersion": "1.0.00",
      "paylord":{}
    };

    var response = await post("http://10.0.2.2:8090/booklist", headers: <String, String>{
      'Content-Type': 'application/json',
    },body:jsonEncode(data)).then((response){
      if(response.statusCode == 200) {
        Map<String, dynamic> userDataMap = jsonDecode(response.body);
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
      child:Column(
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
                            image:AssetImage("assets/images/user.png"),
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
                      // print("Photo tap");
                      // SweetAlert.show(context,
                      //     cancelButtonText: "label.proxone.sign.up.page.screen.camera".trArgs(),
                      //     cancelButtonColor: Colors.amber[600],
                      //     confirmButtonText: "label.proxone.sign.up.page.screen.gallery".trArgs(),
                      //     confirmButtonColor: Colors.amber[600],
                      //     showCancelButton: true,
                      //     onPress: (bool isConfirm) {
                      //       if(isConfirm){
                      //         imgTypeProfile="Profile";
                      //         imgTypebase="Profile";
                      //         setState(() {
                      //           isLoading=true;
                      //         });
                      //         openGalary(context);
                      //       }else{
                      //         setState(() {
                      //           isLoading=true;
                      //         });
                      //         imgTypeProfile="Profile";
                      //         imgTypebase="Profile";
                      //         openCamara(context);
                      //       }
                      //       return false;
                      //     });
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
  String _catogrory;
  String _district;
  bool checkedValue=false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(title: "HUWAMARUWA", bell_icon: true,),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white.withAlpha(70),
      body: Stack(
        children:[
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
                            'Colombo',
                            'Kandy',
                            'Kaluthara',
                            'Matara',
                            'Rathnapura',
                            'Gampaha',
                            'Galle',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style:TextStyle(color:Colors.black),),
                            );
                          }).toList(),
                          hint:Text(
                            "Please Select District",
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (String value) {
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
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
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
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Price',
                          filled: true,
                          fillColor: Colors.grey[200]),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _city,
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
                          prefixIcon: Icon(Icons.person),
                          hintText: 'City',
                          filled: true,
                          fillColor: Colors.grey[200]),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _phone,
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
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Phone No',
                          filled: true,
                          fillColor: Colors.grey[200]),
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
              "Submit",
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
          print(_district);
          print(_city.text.toString());
          print(_phone.text.toString());
          UI_Data.distric=_listing_type;
          UI_Data.city=_city.text.toString();
          UI_Data.phonr=_phone.text.toString();
          UI_Data.price=_price.text.toString();
          AwesomeDialog(context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              title: "Are You Sure?",
              desc: "",
              dismissOnTouchOutside: false,
              btnOkOnPress: () {
                AddBook(context);
              }).show();

        },
      ),
    );
  }

  SharedPreferences sharedPreferences;

 Future AddBook(context) async {
    setState(() {
      isLoading=true;
    });

    sharedPreferences = await SharedPreferences.getInstance();
    int user_id=sharedPreferences.getInt("user");

    Map data = {
      "book_name":UI_Data.bookTitle,
      "user_id":user_id,
      "author":UI_Data.auther,
      "isbn":UI_Data.isbn,
      "quantity":int.parse(UI_Data.qty),
      "e_book_file":null,
      "listing_type":UI_Data.listingType,
      "image":UI_Data.addImg,
      "categoryid":UI_Data.catogory,
      "district":UI_Data.distric,
      "price":int.parse(UI_Data.price),
      "description":UI_Data.des,
      "city":UI_Data.city,
      "tp":UI_Data.phonr
    };
    Map<String, dynamic> userDataMap;
    print(data);


    // var response = await http.post(url);
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    // http://192.168.8.100:8080

    var response = await post("https://huwamaruwa-app.herokuapp.com/book", headers: <String, String>{
      'Content-Type': 'application/json',
    },body:jsonEncode(data)).then((response){
      // print(data);
      // print(response.body.toString());
      // userDataMap = jsonDecode(response.body.toString());
      print("---Response Status Code "+response.statusCode.toString()+"---");
      if(response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, Routes.home);
        setState(() {
          isLoading=false;
        });
        // print(response.body);
      } else if(response.statusCode == 404) {
        print("---else---");
        setState(() {
          isLoading=false;
        });
        AwesomeDialog(context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: "Unsuccessful",
            desc: "login Unsuccessful",
            dismissOnTouchOutside: false,
            btnOkOnPress: () {

            }).show();
        // print("---ERRO---");
      }else{
        setState(() {
          isLoading=false;
        });
        AwesomeDialog(context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: "Unsuccessful",
            desc: "Unexpected Error Occurred",
            dismissOnTouchOutside: false,
            btnOkOnPress: () {
            }).show();
        // print("---ERRO---");
      }
    }).catchError((e){
      setState(() {
        isLoading=false;
      });
      print("---ERRO---");
      print("----- "+e+" -----");
    });
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









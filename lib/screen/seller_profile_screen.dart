import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:huwamaruwa/custom_widgets/custom_app_bar.dart';
import 'package:huwamaruwa/custom_widgets/custom_progress_indicator.dart';
import 'package:huwamaruwa/custom_widgets/profile_clipper.dart';
import 'package:huwamaruwa/dto/user.dart';
import 'package:huwamaruwa/services/UI_Data.dart';

class SellerProfileScreen extends StatefulWidget {
  static const String routeName = '/SellerProfile';

  String Id = Get.parameters['Id'];

  @override
  _SellerProfileScreenState createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {

  bool readOnly = true;
  bool isLoading = false;
  bool _visible = true;
  bool _reSized = true;
  user u;


  @override
  void initState() {
    super.initState();
    getSellerUser(widget.Id);
  }

  Future getSellerUser(id) async {
    setState(() {
      isLoading=true;
    });
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(title:"Seller Profile",bell_icon: true,),
      body: isLoading ? CustomProgressIndicator() :
      Column(
        children: [
          Stack(
            children: [
              ClipPath(
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
                            UI_Data.Custom_App_Header_color2,
                          ]
                      )
                  ),
                  child: SizedBox(),
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
            ],
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                // informationBox(),
                // _reSized ? SizedBox(height: 10.0,) : SizedBox(),
                personalInformation(),
                // SizedBox(height: 15.0,),
                // professionalInformation(),
                // SizedBox(height: 15.0,),
                // emergencyInformation(),
                // SizedBox(height: 15.0,),
                // sportinterest(),
                // SizedBox(height: 15.0,),
                // updateButton(),
              ],
            ),
          ),
        ],
      ),
    );
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
//                     badgeContent: Icon(
//                       Icons.camera_enhance,
//                       color: Colors.white30,
//                       size: Get.height < 680 ? 15.0 : 18.0,
//                     ),
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
              u.name,
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
              u.email,
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
                  Text(
                    "",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: Get.height < 680 ? 12.0 : 15.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  Text(
                    "",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: Get.height < 680 ? 12.0 : 15.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  Text(
                    "",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: Get.height < 680 ? 12.0 : 15.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  GestureDetector(
                    child: Text(
                      "Report This Seller",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.grey[800],
                              fontSize: Get.height < 680 ? 12.0 : 15.0,
                              fontWeight: FontWeight.w700)),
                    ),
                    onTap: (){
                      Get.toNamed("/complain_screen");
                    },
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
                          hintText: u.name,
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
                            hintText: u.email,
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
                    SizedBox(height: 5.0,),
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
//                             hintText: "Homagama",
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
//                     SizedBox(height: 5.0,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}


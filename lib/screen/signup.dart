import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huwamaruwa/routes/mainparems.dart';
import 'package:huwamaruwa/routes/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/signup';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SharedPreferences sharedPreferences;
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  String cuntry_code="+94";
  int i=0;
  bool isLoading = false;
  bool validateprofile=false;
  bool isErrorProfile = false;
  bool isFoces=true;
  bool internetStatus=true;
  bool emilAuth=true;
  bool signup=false;

  String _gender = null;
  String focesType="";
  List<String> _genders=new List<String>();

  String pathImgProfile="";
  String imgTypebase="Not_Available";
  String imgTypeProfile="Not_Available";
  File imageFile,profile;
  String img_profile=null;

  static Pattern mobile =r'^(?:[+0]9)?[0-9]{10}$';
  static Pattern nic =r'^[0-9]{9}[vVxX]|[0-9]{12}$';
  RegExp regex = new RegExp(mobile);
  RegExp regexnic = new RegExp(nic);


  var firstNamefocusNode = new FocusNode();
  var lastNamefocusNode = new FocusNode();
  var dobfocusNode = new FocusNode();
  var emailfocusNode = new FocusNode();
  var mobilefocusNode = new FocusNode();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController mobileController = new TextEditingController();
  final TextEditingController AddressController = new TextEditingController();
  final TextEditingController genderController = new TextEditingController();
  final TextEditingController idOrPassportController = new TextEditingController();
  final TextEditingController createController = new TextEditingController();
  final TextEditingController repeatController = new TextEditingController();
  final TextEditingController home= new TextEditingController();

  final picker = ImagePicker();


  @override
  void initState() {
    isLoading=false;
//    checkNetworkStatus();
    _genders.addAll(["Male","Female"]);
    super.initState();
  }

  @override
  void dispose() {
//    firstNameController.dispose();
    super.dispose();
  }

  void _changeGender(String value){
    setState(() {
      _gender=value;
//      if(focesType=="firstNamefocusNode"){
//        FocusScope.of(context).requestFocus(firstNamefocusNode);
//        firstNamefocusNode.unfocus(disposition: disposition);
//      }else if(focesType=="lastNamefocusNode"){
//        FocusScope.of(context).requestFocus(lastNamefocusNode);
//        lastNamefocusNode.unfocus(disposition: disposition);
//      }else if(focesType=="dobfocusNode"){
//        FocusScope.of(context).requestFocus(dobfocusNode);
//        dobfocusNode.unfocus(disposition: disposition);
//      }
    });
  }

  openCamara(BuildContext context) async {
    try{
     final picture =  await picker.getImage(source: ImageSource.camera,maxHeight: 600,maxWidth: 600);
     if(picture!=null){
       this.setState((){
         if(imgTypebase=="Profile"){
           if(picture!=null){
             profile = File(picture.path);
             final bytes = profile.readAsBytesSync();
             String base64Image = base64Encode(bytes);
             print(base64Image);
             saveProfile(base64Image);
             setState(() {
               validateprofile=false;
             });
             img_profile=base64Image;
           }else{
             imgTypeProfile="Not_Available";
             imgTypebase = "Not_Available";
           }
         }
       });
     }else{
     }
     profile =null;
    }catch(e){
    }
  }

  saveProfile(String value) async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(UiData.userimg, value);
  }

  openGalary(BuildContext context) async {
    try{
      final picture =  await picker.getImage(source: ImageSource.gallery,maxHeight: 600,maxWidth: 600);
      if(picture!=null){
        this.setState((){
          if(imgTypebase=="Profile"){
            if(picture!=null){
              profile = File(picture.path);
              final bytes = profile.readAsBytesSync();
              String base64Image = base64Encode(bytes);
              setState(() {
                validateprofile=false;
              });
              img_profile=base64Image;
            }else{
              imgTypeProfile="Not_Available";
              imgTypebase = "Not_Available";
            }
          }
        });
      }else{
      }
      profile =null;
    }catch(e){
    }
  }


  Widget setProfile(){
    if(imgTypeProfile=="Not_Available"){
      return Column(
        children: <Widget>[
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(style: BorderStyle.solid,color: Colors.white,width:3.5),
              color:  Colors.grey[200],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/user.png"),
              ),
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.add_a_photo,color:Colors.white,size: 25,),
              ],
            ),
          ),
          Visibility(
            maintainSize: this.isErrorProfile,
            maintainAnimation: true,
            maintainState: true,
            visible: this.isErrorProfile,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.redAccent[100],
                border:
                Border.all(color: Colors.red[900]),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Please Take A Selfie",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900]),
                    ),
                  ]),
            ),
          ),
        ],
      );
    }else if(imgTypeProfile=="Profile"){
      if(img_profile==null){
      }else{
        setState(() {
          this.isErrorProfile=false;
        });
      }
      return Column(
        children: <Widget>[
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(style: BorderStyle.solid,color: Colors.white,width:3.5),
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: img_profile != null ? Image.memory(base64Decode(img_profile)).image :
                AssetImage("assets/images/user.png"),
              ),
            ),
            child: img_profile == null?Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.add_a_photo,color:Colors.white,size: 25,),
              ],
            ):Container(),
          ),
          Visibility(
            maintainSize: this.isErrorProfile,
            maintainAnimation: true,
            maintainState: true,
            visible: this.isErrorProfile,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.redAccent[100],
                border:
                Border.all(color: Colors.red[900]),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Please Take A Selfie",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900]),
                    ),
                  ]),
            ),
          ),
        ],
      );
    }else{
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacementNamed(context, Routes.login);
      },
      child: Scaffold(
        body:  Container(
          width: double.infinity,
          child:isLoading
              ? Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              internetStatus?CircularProgressIndicator():
              signup?CircularProgressIndicator():Text("Network Not Available, Please Try Again."),
              signup?Container():RaisedButton(
                onPressed: () {
//                  checkNetworkStatus();
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                color: Colors.red,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child:
                  const Text('Retry', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
          )
              : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black87,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 23),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      "Create an Account",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Please Sign-Up for ShoeBay",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10,left: 10, top: 10),
                                    child: Divider(
                                      color: Colors.white24,
                                      thickness: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(left: 30,right: 30,top: 20),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: <Widget>[
                                         Padding(
                                           padding: const EdgeInsets.only(),
                                           child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                            border: Border.all(color: Colors.white10),
                                            borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: TextFormField(
                                            style: TextStyle(color: Colors.white,),
                                            autofocus: true,
                                            controller: fullNameController,
                                            keyboardType: TextInputType.text,
                                            validator: (value){
                                              if(value.isEmpty){
                                                return "Please Enter Your Full name";
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                hintStyle: TextStyle(color: Colors.white60),
                                                hintText: "User Name",
                                                border: InputBorder.none,
                                                prefixIcon:Icon(Icons.person,)
                                            ),
                                        ),
                                      ),
                                         ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white10,
                                            border: Border.all(color: Colors.white10),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: TextFormField(
                                            style: TextStyle(color: Colors.white,),
                                            autofocus: true,
                                            controller: emailController,
                                            keyboardType: TextInputType.text,
                                            validator: (value){
                                              if(value.isEmpty){
                                                return "Please Enter Your Email Address";
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                hintText: "Email Address",
                                                hintStyle: TextStyle(color: Colors.white60),
                                                border: InputBorder.none,
                                                suffixIcon: Icon(Icons.star,color: Colors.red,size: 13,),
                                                prefixIcon:Icon(Icons.email)
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white10,
                                            border: Border.all(color: Colors.white10),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: TextFormField(
                                            autofocus: true,
                                            style: TextStyle(color: Colors.white,),
                                            controller: idOrPassportController,
                                            keyboardType: TextInputType.phone,
                                            validator: (value){
                                              if(value.isEmpty){
                                                return "Please Enter Your Moblie Number";
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                hintText: "Mobile",
                                                hintStyle: TextStyle(color: Colors.white60,),
                                                border: InputBorder.none,
                                                prefixIcon:Icon(Icons.phone)
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white10,
                                            border: Border.all(color: Colors.white10),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: TextFormField(
                                            autofocus: true,
                                            obscureText: true,
                                            style: TextStyle(color: Colors.white,),
                                            controller: createController,
                                            keyboardType: TextInputType.text,
                                            validator: (value){
                                              if(value.isEmpty){
                                                return "Please Enter Your Create Password";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                hintStyle: TextStyle(color: Colors.white60,),
                                                hintText: "Create Password",
                                                border: InputBorder.none,
                                                prefixIcon:Icon(Icons.lock)
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white10,
                                            border: Border.all(color: Colors.white10),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: TextFormField(
                                            autofocus: true,
                                            obscureText: true,
                                            style: TextStyle(color: Colors.white,),
                                            controller: repeatController,
                                            keyboardType: TextInputType.text,
                                            validator: (value){
                                              if(value.isEmpty){
                                                return "Please Enter Your Repeat password";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                hintStyle: TextStyle(color: Colors.white60,),
                                                hintText: "Repeat password",
                                                border: InputBorder.none,
                                                prefixIcon:Icon(Icons.lock)
                                            ),
                                          ),
                                        ),
                                      ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 8.0),
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             color: Colors.white10,
//                                             border: Border.all(color: Colors.white10),
//                                             borderRadius: BorderRadius.circular(10),
//                                           ),
//                                           padding: EdgeInsets.all(2),
//                                           child: Row(
//                                             children: <Widget>[
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(color: Colors.white10),
//                                                   borderRadius: BorderRadius.circular(1),
//                                                 ),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(2.0),
//                                                   child:GestureDetector(
//                                                     onTap: () {
// //                                                          openCamara(context);
//                                                     }, // handle your image tap here
//                                                           child: setProfile(),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 30),
//                                                 child: GestureDetector(
//                                                   onTap: (){
//                                                     print("Camara_tap");
//                                                      imgTypeProfile="Profile";
//                                                      imgTypebase="Profile";
//                                                     openCamara(context);
//                                                   },
//                                                   child: Container(
//                                                     child: Icon(
//                                                       Icons.camera_alt,
//                                                       color: Colors.blue,
//                                                       size: 35.0,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 30),
//                                                 child: GestureDetector(
//                                                   onTap: (){
//                                                     print("Galary_tap");
//                                                     imgTypeProfile="Profile";
//                                                     imgTypebase="Profile";
//                                                     openGalary(context);
//                                                   },
//                                                   child: Container(
//                                                     child: Icon(
//                                                       Icons.file_upload,
//                                                       color: Colors.blue,
//                                                       size: 35.0,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           )
//                                         ),
//                                       ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(right: 30.0,left: 30.0,bottom: 30.0,top: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.blue
                                      ),
                                      child: OutlineButton(
                                        splashColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0)
                                        ),
                                        onPressed: () {
                                          if(formKey.currentState.validate()){
                                            print("fullname "+fullNameController.text);
                                            print("email "+emailController.text);
                                            print("mobile "+mobileController.text);
                                            print("gender "+_gender);
                                            print("nic "+idOrPassportController.text);
                                            print("create "+createController.text);
                                            print("repeat "+repeatController.text);
                                            signup=true;
//                                            signUp();
                                          }
                                        },
                                        child: Text(
                                          "SIGN UP",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20, bottom: 8),
                                      child: Divider(
                                        color: Colors.white24,
                                        thickness: 2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        "OR",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.blue
                                      ),
                                      child: OutlineButton(
                                        splashColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0)
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(context, Routes.login);
                                        },
                                        child: Text(
                                          "LOG IN",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future login() async {

     sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setString("email", emailController.text.toString());
    // print("get Key "+prefs.getString(UiData.signup_authKey).toString());
    Map data = {
      "email":emailController.text,
      "password":repeatController.text,
      "mobile":mobileController.text,
      "tp":'one',
      "reset_code":'one',
      "user_rate":187.0,
      "payment_email":null
    };
    Map<String, dynamic> userDataMap;
    print(data);

    var response = await post("http://10.0.2.2:8090/user/verify", headers: <String, String>{
      'Content-Type': 'application/json',
    },body:jsonEncode(data)).then((response){
      print(data);
      print(response.body.toString());
      userDataMap = jsonDecode(response.body.toString());
      print("---Response Status Code "+response.statusCode.toString()+"---");
      if(response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, Routes.home);
        setState(() {
          isLoading=false;
        });
        print(response.body);
      } else {
        print("---else---");
        AwesomeDialog(context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: "Sing-Up Unsuccessful",
            desc: userDataMap["status"],
            dismissOnTouchOutside: false,
            btnOkOnPress: () {
            }).show();
        print("---ERRO---");
        setState(() {
          isLoading=false;
        });
      }
    }).catchError((e){
      setState(() {
        isLoading=false;
      });
      print("---ERRO---");
      print("----- "+e+" -----");
    });
  }

//
//  Future checkNetworkStatus() async{
//    try {
//      final result = await InternetAddress.lookup('google.com');
//      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//        setState(() {
//          isLoading=false;
//          internetStatus = true;
//        });
//        if(signup){
//        }
//      }
//    } on SocketException catch (_) {
//      setState(() {
//        internetStatus=false;
//      });
//    }
//  }

//  signUp() async {
//    sharedPreferences = await SharedPreferences.getInstance();
//    try{
//
//    }catch(e){
//      print(e.toString());
//    }
//    Map data = {
//        "name":fullNameController.text,
//        "address":"",
//        "gender":_gender,
//        "mobilenumber":mobileController.text,
//        "ssn":idOrPassportController.text,
//        "password":createController.text,
//        "email": emailController.text,
//        "profilepicture":img_profile
//    };
//    setState(() {
//      isLoading=true;
//    });
//
//    Map<String, dynamic> userDataMap;
//    signup_respons_success srs;
//    var response = await post(UIData.baseURL + "member", headers: <String, String>{
//      'Content-Type': 'application/json; charset=UTF-8',
//    },body:jsonEncode(data)).then((response){
//      sharedPreferences.setString("USER_NAME", fullNameController.text);
//      print("SignUp");
//      print(response.body);
//      userDataMap = jsonDecode(response.body);
//      print(response.statusCode);
//      if(response.statusCode == 200) {
//        srs=signup_respons_success.fromJson(userDataMap);
//        if(srs.statusCode=="201"){
//          AwesomeDialog(
//              context: context,
//              dialogType: DialogType.SUCCES,
//              headerAnimationLoop: false,
//              animType: AnimType.TOPSLIDE,
//              title: 'Created Successfully',
//              desc: srs.message,
//              dismissOnTouchOutside: false,
//              btnOkOnPress: () {
//                Navigator.pushReplacementNamed(context, Routes.login);
//              })
//              .show();
//        }else if(srs.statusCode=="409"){
//          AwesomeDialog(
//              context: context,
//              dialogType: DialogType.WARNING,
//              headerAnimationLoop: false,
//              animType: AnimType.TOPSLIDE,
//              title: 'Warning',
//              desc: srs.message,
//              btnOkText: "OK",
//              btnOkColor: Colors.amber,
//              dismissOnTouchOutside: false,
//              btnOkOnPress: () {
//                Navigator.pushReplacementNamed(context, Routes.login);
//              })
//              .show();
//        }
//        setState(() {
//          isLoading=false;
//        });
//      } else if(response.statusCode == 400) {
//        print("400");
//      }else{
//        print(response.statusCode);
//      }
//    }).catchError((e,s){
//      print("erro2"+e.toString());
//      Crashlytics.instance.recordError(e, s, context: 'sign up');
//    });
//  }
}



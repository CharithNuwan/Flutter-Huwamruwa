

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huwamaruwa/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ForgotPassword extends StatefulWidget {
  static const String routeName = '/forgot-password';
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  SharedPreferences sharedPreferences;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController mobileNumberController = new TextEditingController();

  bool isLoading = false;
  bool validateprofile=false;
  bool isErrorProfile = false;
  bool isFoces=true;
  bool internetStatus=true;
  bool emilAuth=true;
  bool signup=false;

  @override
  void initState() {
//    isLoading=true;
//    checkNetworkStatus();
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacementNamed(context, Routes.login);
      },
      child: Scaffold(
        body:  Container(
          color: Colors.black87,
          width: double.infinity,
//          ),
          child:isLoading
              ? Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
//              internetStatus?CircularProgressIndicator():
//              signup?CircularProgressIndicator():Text("Network Not Available, Please Try Again."),
//              signup?Container():RaisedButton(
//                onPressed: () {
//                  checkNetworkStatus();
//                },
//                textColor: Colors.white,
//                padding: const EdgeInsets.all(0.0),
//                color: Colors.red,
//                child: Container(
//                  padding: const EdgeInsets.all(10.0),
//                  child:
//                  const Text('Retry', style: TextStyle(fontSize: 20)),
//                ),
//              ),
            ],
          ),
          )
              : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30,),
                Expanded(
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey[200],
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 60),
                                    child: Text(
                                      "Forgot Password",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      "Please Submit Your Email",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10,left: 10),
                                    child: Divider(
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
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: TextFormField(
                                            autofocus: true,
                                            controller: mobileNumberController,
                                            keyboardType: TextInputType.number,
                                            validator: (value){
                                              if(value.isEmpty){
                                                return "Please Enter Your Email";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                hintText: "Email",
                                                border: InputBorder.none,
                                                prefixIcon:Icon(Icons.phone)
                                            ),
                                          ),
                                        ),
                                      ),
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
                                          color: Colors.orange
                                      ),
                                      child: OutlineButton(
                                        splashColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0)
                                        ),
                                        onPressed: () {
                                          if(formKey.currentState.validate()){
//                                            forgot_password();
                                          }
                                        },
                                        child: Text(
                                          "Submit",
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

//  void forgot_password() async {
//    setState(() {
//      isLoading = true;
//    });
//    try{
//      var jsonResponse;
//      var response = await http.post(
//        UIData.baseURL + "/auth/forgot-password/" + mobileNumberController.text,
//        headers: <String, String>{
//          'Content-Type': 'application/json; charset=UTF-8',
//        },
//      );
//      jsonResponse = json.decode(response.body);
//      print(jsonResponse['statusCode']);
//      if (jsonResponse['statusCode'] == "200") {
//        sharedPreferences = await SharedPreferences.getInstance();
//        setState(() {
//          isLoading = false;
//        });
//        AwesomeDialog(
//            context: context,
//            dialogType: DialogType.SUCCES,
//            headerAnimationLoop: false,
//            animType: AnimType.TOPSLIDE,
//            title: 'Successfull',
//            desc: jsonResponse['message'],
//            btnOkText: "OK",
//            btnOkColor: Colors.redAccent,
//            dismissOnTouchOutside: false,
//            btnOkOnPress: () {
//              sharedPreferences.setBool("reset", true);
//              ResetPassword.mobileNumber=mobileNumberController.text;
//              Navigator.pushReplacementNamed(context, Routes.resetPassword);
//            })
//            .show();
//      }else if(jsonResponse['statusCode'] == "404"){
//        setState(() {
//          isLoading = false;
//        });
//        AwesomeDialog(
//            context: context,
//            dialogType: DialogType.WARNING,
//            headerAnimationLoop: false,
//            animType: AnimType.TOPSLIDE,
//            title: 'WARNING',
//            desc: jsonResponse['message'],
//            btnOkText: "OK",
//            btnOkColor: Colors.redAccent,
//            dismissOnTouchOutside: false,
//            btnOkOnPress: () {
//
//            })
//            .show();
//      }
//    }catch(e){
//      print(e.toString());
//    }
//  }

}

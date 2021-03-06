import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class AddVaccine extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AddVaccine();
  }

}
bool loading = false;
class _AddVaccine extends State<AddVaccine>{
  final key = GlobalKey<FormState>();
  TextEditingController vaccineId = new TextEditingController();
  TextEditingController aadhaarId = new TextEditingController();
  Future<void> addVaccine() async {
    http.Response response = await http.post("http://127.0.0.1:8545/makevaccinated",body: {
        'id': vaccineId.text,
        'aId': aadhaarId.text
    });
    var json = jsonDecode(response.body);
    if(json['success']==0)
    {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "There was some error please check Vaccine and Aadhaar Id");
    }
    else
    {
      print(response.body);
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "User data has been successfully updated");
      Navigator.pop(context);
    }
  }
  @override
  void initState() {
    loading = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      body: (loading)?Center(
        child: CircularProgressIndicator(),
      ):SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Container(
              height: MediaQuery.of(context).size.width-100,
              width: MediaQuery.of(context).size.width-100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("Assets/vaccineInfobg.png"),
                  )
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: key,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
                    child: TextFormField(
                      style: subheading1,
                      controller: vaccineId,
                      validator: RequiredValidator(errorText: "Vaccine Id is a required field"),
                      decoration: InputDecoration(
                        labelText: 'Vaccine Id',
                        labelStyle: GoogleFonts.aBeeZee(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.white,width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.white,width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.red,width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.red,width: 2),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
                    child: TextFormField(
                      style: subheading1,
                      controller: aadhaarId,
                      validator: RequiredValidator(errorText: "Aadhar Id is required Field"),
                      decoration: InputDecoration(
                        labelText: 'User Aadhaar Id',
                        labelStyle:  GoogleFonts.aBeeZee(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.white,width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.white,width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.red,width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.red,width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FlatButton(
              color: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              onPressed: () async {
                if(key.currentState.validate())
                {
                  setState(() {
                    loading = true;
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if(prefs.getBool('guest'))
                    {
                      Fluttertoast.showToast(msg: "Cannot add Vaccine as guest");
                      setState(() {
                        loading=false;
                      });
                    }
                  else
                    addVaccine();
                }
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Register",style: heading1),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

}
import 'package:blockchain/DiseaseFinder.dart';
import 'package:blockchain/EditProfile.dart';
import 'package:blockchain/QRCodeScanner.dart';
import 'package:blockchain/SupplierList.dart';
import 'package:blockchain/VaccineVerifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'MyDrawer.dart';

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}
bool clicked = false;
int index = 0;
dynamic screens = [EditProfile(),QRCodeScanner(),VaccineVerifier(),SupplierList(),DiseaseFinder()];
class _MainPage extends State<MainPage>{
  @override
  void initState() {
    clicked = false;
    index=0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.notes),
          color: Colors.white,
          onPressed: (){
            setState(() {
              clicked = !clicked;
            });
          },
        ),
        title: Text("Co-Shield",style: heading1,),
        backgroundColor: primaryBlue,
        elevation: 0,
      ),
     // drawer: buildDrawer(context),
      body: Stack(
        children: [
          buildDrawer(context,index,(data){
            setState(() {
              clicked=!clicked;
              if(data!=null)
              index=data;
            });
          }),
          Transform(
            transform: (clicked)?(Matrix4.identity()..scale(1.0)..translate(70.0)):Matrix4.identity(),
            alignment: Alignment.center,
            child: (index==0)?screens[index]:WillPopScope(child: screens[index], onWillPop: (){
              setState(() {
                index=0;
                clicked=false;
              });
              return Future.value(false);
            })
          )
        ],
      )
    );
  }

}
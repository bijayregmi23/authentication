import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth= FirebaseAuth.instance;
  FirebaseUser user;
  bool isSignedIn = false;

  checkAuthentication() async{
    _auth.onAuthStateChanged.listen((user){
      if(user==null){
          Navigator.pushReplacementNamed(context, '/SignInPage');
      }
      else{
        this.getUser();
      }
    });
  }

  signOut() async{
    await _auth.signOut();
    await googleSignIn.signOut();

  }

  getUser() async{
    FirebaseUser firebaseUser= await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser =await _auth.currentUser();

      if(firebaseUser != null){
        setState(() {
         this.user=firebaseUser;
         this.isSignedIn=true; 
        });
      }
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        child: Center(
          child: !isSignedIn?CircularProgressIndicator():Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(50),
                child: Image(image: AssetImage('images/logo.png'),width: 100.0,height: 100.0,),
              ),
              Container(
                padding: EdgeInsets.all(50.0),
                child: Text(
                   "Hello, ${user.displayName},you are logged in as ${user.email}",
                   style: TextStyle(fontSize: 20.0),),
              ),
              //LogOut Button
              Container(
                padding: EdgeInsets.all(20),
                child: RaisedButton(
                  color: Colors.indigoAccent,
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  onPressed: signOut,
                  child: Text('Log Out',
                  style: TextStyle(fontSize: 20.0,color: Colors.white),),
                ),)
            ],
          )
        ),
      ),
    );
  }
}
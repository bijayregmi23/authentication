import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey= GlobalKey <FormState>();

  String _name,_email,_password;

  checkAuthentication() async{
    _auth.onAuthStateChanged.listen((user) async {
      if(user!=null)
      {
        Navigator.pushReplacementNamed(context, '/HomePage');
      }
    });
  }

  navigateToSignInScreen(){
    Navigator.pushReplacementNamed(context, '/SignInPage');
  }

  signup() async{
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
      try {
         final FirebaseUser user= await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
        if(user!=null){
          Navigator.pushReplacementNamed(context, '/HomePage');
          UserUpdateInfo updateuser=UserUpdateInfo();
          updateuser.displayName=_name;
          user.updateProfile(updateuser);
        }        
      }
      catch (e){
        showError(e.message);
      }
    }
  }

  showError(String errorMessage){
    showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(child: Text('OK'),
          onPressed: (){
            Navigator.of(context).pop();
          } ,)
        ],
      );
    });
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
        title: Text('Sign Up'),
        backgroundColor: Colors.greenAccent,
      ),

      body: Container(
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10.0,20.0, 10.0, 20.0),
                child: Image(image: AssetImage('images/logo.png'),width: 100.0,height: 100.0,),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[

                      //Name
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          validator: (input){
                            if(input.isEmpty){
                              return 'Enter Name';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                          ),
                          onSaved: (input)=> _name=input,
                        ),
                      ),

                      //Email
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          validator: (input){
                            if(input.isEmpty){
                              return 'Enter e-mail id';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                          ),
                          onSaved: (input)=> _email=input,
                        ),
                      ),

                      //Password
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          validator: (input){
                            if(input.length<6){
                              return 'Password Must Be Greater than 6 characters';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                          ),
                          onSaved: (input)=> _password=input,
                          obscureText: true,
                        ),
                      ),

                      //SignUp Button
                      Container(
                        padding: EdgeInsets.only(top:20.0),
                        child:RaisedButton(
                          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                          color: Colors.indigoAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onPressed: signup,
                          child: Text(
                            'Sign Up',
                            style:TextStyle(color: Colors.white,
                            fontSize: 20.0)),
                        ) ,
                      ),

                      //SignIn
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: navigateToSignInScreen,
                          child: Text('Already have an account ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
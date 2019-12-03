import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final FirebaseAuth _auth =FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  String _email;

  sendEmail()async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
    }
    try {
      await _auth.sendPasswordResetEmail(email: _email);
      showSuccess("Email Sent Successfully ! ");
      
    } 
    catch (e){
      showError(e.message);
    }
  }

  showSuccess(String errorMessage){
    showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text('Success'),
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

  navigateToSignInScreen(){
    Navigator.pushReplacementNamed(context, '/SignInPage');
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
                  key: _formKey,
                  child: Column(
                    children: <Widget>[

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

                      //Send Email Button
                      Container(
                        padding: EdgeInsets.only(top:20.0),
                        child:RaisedButton(
                          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                          color: Colors.indigoAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onPressed:sendEmail,
                          child: Text(
                            'Send Email',
                            style:TextStyle(color: Colors.white,
                            fontSize: 20.0)),
                        ) ,
                      ),

                      //SignIn
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: navigateToSignInScreen,
                          child: Text('Sign In',
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
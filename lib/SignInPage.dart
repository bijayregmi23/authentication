import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  String _email,_password;


 checkAuthentication() async{
   _auth.onAuthStateChanged.listen((user) async{
     if(user!=null){
       Navigator.pushReplacementNamed(context,"/HomePage");
     }
   });
 }

  navigateToSignUpScreen() async{
    Navigator.pushReplacementNamed(context, "/SignUpPage");
  }

  navigateToForgotPasswordScreen() async{
    Navigator.pushReplacementNamed(context, "/ForgotPassword");
  }

  @override
  void initState(){
    super.initState();
  //  this.checkAuthentication();
  }

  void signIn() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
    }
    try {
      FirebaseUser user=await _auth.signInWithEmailAndPassword(email: _email,password: _password);
      if(user!=null){
       Navigator.pushReplacementNamed(context,"/HomePage");
     }
    } catch (e) {
      showError(e.message);
    }
  }

  showError(String errorMessage){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Sign In'),
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

                      //SignIn Button
                      Container(
                        padding: EdgeInsets.only(top:20.0),
                        child:RaisedButton(
                          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                          color: Colors.indigoAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onPressed:signIn,
                          child: Text(
                            'Sign In',
                            style:TextStyle(color: Colors.white,
                            fontSize: 20.0)),
                        ) ,
                      ),

                      //Create an Account
                      Container(
                          padding: EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: navigateToSignUpScreen,
                            child: Text('Create an account?',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                      ),

                      //Forgot Password
                      Container(
                          padding: EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: navigateToForgotPasswordScreen,
                            child: Text('Forgot Password?',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                      ),
                    ],
                  ), 
                ),
              ),

              //Google SignIn  
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: OutlineButton(
                  splashColor: Colors.grey,
                  onPressed: () {
                    signInWithGoogle().whenComplete(() {
                      Navigator.pushReplacementNamed(context, '/HomePage');
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  highlightElevation: 0,
                  borderSide: BorderSide(color: Colors.greenAccent),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(image: AssetImage("images/google.png"), height: 35.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    )
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
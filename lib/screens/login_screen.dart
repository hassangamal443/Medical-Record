import 'package:flutter/material.dart';
import 'package:personal_medical_record/main.dart';
import 'package:personal_medical_record/recources/auth_methods.dart';
import 'package:personal_medical_record/screens/signup_screen.dart';
import 'package:personal_medical_record/screens/splash_screen2.dart';
import 'package:personal_medical_record/utils/utils.dart';
import 'package:personal_medical_record/widgets/button2.dart';
import 'package:personal_medical_record/widgets/language_button.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void loginUser () async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
      showSnackBar(res, context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen()));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              FadeInDownBig(duration: Duration(milliseconds: 800),
                  child: Image.asset('Images/medical-record.png', height: deviceHeight(context)/8,
                  )),
              FadeInUp(duration: Duration(milliseconds: 800),delay: Duration(milliseconds: 800),
                child: Text(
                  'PMR',
                  style: TextStyle(
                    letterSpacing: 5,
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ),
              FadeInUp(duration: Duration(milliseconds: 400),delay: Duration(milliseconds: 1600),
                child: Text(
                  AppLocalizations.of(context)!.personal_Medical_Record,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ),
              SizedBox(height: deviceHeight(context)/10,),
              FadeInUp(duration: Duration(milliseconds: 400),delay: Duration(milliseconds: 2000),
                child: Text(
                  AppLocalizations.of(context)!.logIn,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ),
              SizedBox(height: 30,),
              FadeInLeftBig(duration: Duration(milliseconds: 800),delay: Duration(milliseconds: 2400),
                child: TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_your_Email,
                  textInputType: TextInputType.emailAddress,
                  textEditingController:  _emailController,
                ),
              ),
              SizedBox(height: 10,),
              FadeInRightBig(duration: Duration(milliseconds: 800),delay: Duration(milliseconds: 2400),
                child: TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_your_Password,
                  textInputType: TextInputType.text,
                  textEditingController:  _passwordController,
                  isPass: true,
                ),
              ),
              SizedBox(height: 10,),
              FadeInUpBig(duration: Duration(milliseconds: 800),delay: Duration(milliseconds: 2400),
                child: InkWell(
                  onTap: loginUser,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5, offset: Offset(-1, 1)),]
                    ),
                    child: Center(child: _isLoading ? Center(child: CircularProgressIndicator(),) :
                    Text(
                      AppLocalizations.of(context)!.logIn,
                      style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Oxanium',
                          fontSize: 15
                      ),
                    ),
                    ),
                    width: 140,
                    height: 40,
                  ),
                ),
              ),
              FadeInUp(duration: Duration(milliseconds: 800),delay: Duration(milliseconds: 3200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dont_have_an_account,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[300],
                        fontFamily: 'Oxanium',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) =>SignupScreen()));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.sign_up,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Oxanium',
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FadeInUp(duration: Duration(milliseconds: 800),delay: Duration(milliseconds: 3200),
                  child: LocaleToggleButton2()),
              Flexible(child: Container(), flex: 2,),
            ],
          ),
        ),
      ),
    );
  }
}

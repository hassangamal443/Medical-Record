import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_medical_record/main.dart';
import 'package:personal_medical_record/recources/auth_methods.dart';
import 'package:personal_medical_record/screens/login_screen.dart';
import 'package:personal_medical_record/screens/splash_screen2.dart';
import 'package:personal_medical_record/utils/utils.dart';
import 'package:personal_medical_record/widgets/text_field_input.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
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

  void selectImage() async{
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      file: _image!,
    );

    if(res != 'success') {
      showSnackBar(res, context);
    } else {
      showSnackBar(res, context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen()));
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
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              FadeInDownBig(duration: const Duration(milliseconds: 800),
                  child: Image.asset('Images/medical-record.png', height: deviceHeight(context)/8,
                  )),
              FadeInUp(duration: const Duration(milliseconds: 800),delay: const Duration(milliseconds: 800),
                child: const Text(
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
              FadeInUp(duration: const Duration(milliseconds: 400),delay: const Duration(milliseconds: 1600),
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
              SizedBox(height: deviceHeight(context)/30,),
              FadeInUp(duration: const Duration(milliseconds: 400),delay: const Duration(milliseconds: 2000),
                child: Text(
                  AppLocalizations.of(context)!.sign_up,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oxanium',
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              FadeInUp(duration: const Duration(milliseconds: 800),delay: const Duration(milliseconds: 2400),
                child: Stack(
                  children: [
                    _image!=null?CircleAvatar(
                      backgroundImage: MemoryImage(_image!),
                      backgroundColor: Colors.grey[200],
                      radius: 30,
                    )
                        : CircleAvatar(
                      backgroundImage: const AssetImage('Images/user (3).png'),
                      backgroundColor: Colors.grey[200],
                      radius: 30,
                    ),
                    Positioned(
                        bottom: -15,
                        left: 25,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              FadeInRightBig(duration: const Duration(milliseconds: 800),delay: const Duration(milliseconds: 2400),
                child: TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_your_Username,
                  textInputType: TextInputType.text,
                  textEditingController:  _usernameController,
                ),
              ),
              const SizedBox(height: 10,),
              FadeInLeftBig(duration: const Duration(milliseconds: 800),delay: const Duration(milliseconds: 2400),
                child: TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_your_Email,
                  textInputType: TextInputType.emailAddress,
                  textEditingController:  _emailController,
                ),
              ),
              const SizedBox(height: 10,),
              FadeInRightBig(duration: const Duration(milliseconds: 800),delay: const Duration(milliseconds: 2400),
                child: TextFieldInput(
                  hintText: AppLocalizations.of(context)!.enter_your_Password,
                  textInputType: TextInputType.text,
                  textEditingController:  _passwordController,
                  isPass: true,
                ),
              ),
              const SizedBox(height: 10,),
              FadeInUpBig(duration: const Duration(milliseconds: 800),delay: const Duration(milliseconds: 2400),
                child: InkWell(
                  onTap: signUpUser,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [const BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5, offset: Offset(-1, 1)),]
                    ),
                    child: Center(child: _isLoading ? const Center(child: CircularProgressIndicator(),):
                    Text(
                      AppLocalizations.of(context)!.sign_up,
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
              FadeInUp(duration: const Duration(milliseconds: 800),delay: const Duration(milliseconds: 3200),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>const LoginScreen()));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.i_have_an_account,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oxanium',
                    ),
                  ),
                ),
              ),
              Flexible(child: Container(), flex: 2,),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginscreen/animation_enum.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;

  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testEmail = 'mahmoud@gmail.com';
  String testPass = '666666';
  final passwordFoucsNode = FocusNode();
  bool isLookLeft = false;
  bool isLookRight = false;

  void removeAllController() {
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
  }

  void addControllerIdle() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerIdle);
  }

  void addControllerHandsUp() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerHandsUp);
  }

  void addControllerHandsDown() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerHandsDown);
  }

  void addControllerLookRight() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerLookRight);
  }

  void addControllerLookLeft() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerLookLeft);
  }

  void addControllerSuccess() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerSuccess);
  }

  void addControllerFail() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerFail);
  }
  void checkPasswordFocus(){
    passwordFoucsNode.addListener(() {
      if (passwordFoucsNode.hasFocus) {
        addControllerHandsUp();
      } else {
        addControllerHandsDown();
      }
    });
  }

  void validateEmailAndPassword(){

    Future.delayed(const Duration(seconds: 1),(){
      if (formKey.currentState!.validate()) {
        addControllerSuccess();
      } else {
        addControllerFail();
      }
    });

  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);

    rootBundle.load('assets/animated_login.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });
    checkPasswordFocus();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        back_Image(),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 2.2,
                    child: animation_Bear(context)),
                Form(
                  key: formKey,
                  child: loginInfo(context),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Container loginInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(.5),
      ),
      child: Column(
        children: [
          email_Field(),
          SizedBox(height: MediaQuery.of(context).size.height / 30),
          password_Field(),
          SizedBox(height: MediaQuery.of(context).size.height / 25),
          button_Text(context),
          SizedBox(height: MediaQuery.of(context).size.height / 30),
        ],
      ),
    );
  }

  Container button_Text(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: TextButton(
        onPressed: () {
          passwordFoucsNode.unfocus();
          validateEmailAndPassword();
        },
        style: TextButton.styleFrom(
            elevation: 5, shape: StadiumBorder(), backgroundColor: Colors.blue),
        child: const Text(
          'LOGIN',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  TextFormField password_Field() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      focusNode: passwordFoucsNode,
      validator: (value) => value != testPass ? "Worst Password" : null,
    );
  }

  TextFormField email_Field() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      validator: (value) => value != testEmail ? "Worst Email Address" : null,
      onChanged: (value) {
        if (value.isNotEmpty && value.length < 17 && !isLookLeft) {
          addControllerLookLeft();
        } else if (value.isNotEmpty && value.length > 17 && !isLookRight) {
          addControllerLookRight();
        }
      },
    );
  }

  Padding animation_Bear(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 50),
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.2,
          child: riveArtboard == null
              ? const SizedBox.shrink()
              : Rive(artboard: riveArtboard!)),
    );
  }

  Widget back_Image() {
    return Container(
      height: double.infinity,
      child: Image.asset(
        'assets/back.gif',
        fit: BoxFit.fitHeight,
      ),
    );
  }
}

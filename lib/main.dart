import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(
    const MaterialApp(
      home: LoginScreen(),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final animationLink = 'assets/login-bear.riv';
  SMITrigger? failTrigger, successTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;
  StateMachineController? stateMachineController;
  Artboard? artboard;

  final correctEmail = 'guba@gmail.com';
  final correctPassword = '0000';

  @override
  void initState() {
    rootBundle.load(animationLink).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(art, "Login Machine");

      if (stateMachineController != null) {
        art.addController(stateMachineController!);

        stateMachineController!.inputs.forEach((element) {
          if (element.name == "isChecking") {
            isChecking = element as SMIBool;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
          } else if (element.name == "trigSuccess") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "trigFail") {
            failTrigger = element as SMITrigger;
          } else if (element.name == "numLook") {
            lookNum = element as SMINumber;
          }
        });
      }
      setState(() => artboard = art);
    });
    super.initState();
  }

  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  void moveEyes(value) {
    lookNum?.change(value.length.toDouble());
  }

  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  void loginClick() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    if (emailController.text == correctEmail &&
        passController.text == correctPassword) {
      successTrigger?.fire();
    } else {
      failTrigger?.fire();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (artboard != null)
                SizedBox(
                  width: 500,
                  height: 400,
                  child: Rive(artboard: artboard!),
                ),
              Container(
                margin: const EdgeInsets.all(15.0),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8 * 4),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: TextFormField(
                      onTap: lookAround,
                      onChanged: ((value) => moveEyes(value)),
                      controller: emailController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                        focusColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8 * 4),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: TextFormField(
                      onTap: handsUpOnEyes,
                      obscureText: true,
                      controller: passController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                        focusColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () {},
                child: const Text(
                  'Not having account? Sign up!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: const Color(0xffb73e60),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: MaterialButton(
                  onPressed: () => {
                    loginClick(),
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
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

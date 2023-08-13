import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:beerstation/utils.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  final controllerMail = TextEditingController();
  final controllerPassword = TextEditingController();

  Widget email() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xff272727),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 6))
              ],
            ),
            height: 53,
            child: TextField(
              controller: controllerMail,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'Roboto'),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 10),
                prefixIcon: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                hintText: 'Inserisci la tua email',
                hintStyle: TextStyle(color: Color.fromARGB(255, 207, 207, 207)),
              ),
            ))
      ],
    );
  }

  Widget password() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Color(0xff272727),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              const BoxShadow(
                  color: Colors.black12, blurRadius: 5, offset: Offset(0, 6))
            ],
          ),
          height: 53,
          child: TextField(
            controller: controllerPassword,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 10),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Scegli una password',
                hintStyle:
                    TextStyle(color: Color.fromARGB(255, 207, 207, 207))),
          ),
        )
      ],
    );
  }

  Widget invia() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff0b0b0b), alignment: Alignment.center),
      onPressed: () async {},
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          Icons.mail,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        SizedBox(
          width: 5,
        ),
        Text('Sign Up ',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 20,
                fontFamily: 'Roboto'))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
              //Colors.deepOrange,
              Colors.amber,
              Colors.orange,
            ]))),
        Image.asset('assets/register.png'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 5),
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    //physics: NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 3,
                        ),
                        const Text(
                          'Inserisci \ni tuoi dati',
                          style: TextStyle(
                              color: Color.fromARGB(255, 233, 233, 233),
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.6),
                        ),
                        SizedBox(height: 30),
                        email(),
                        SizedBox(height: 10),
                        password(),
                        SizedBox(height: 12),
                        invia(),
                      ],
                    )),
              )),
        )
      ],
    );
  }
}

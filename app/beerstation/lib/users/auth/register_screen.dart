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
  final controllerNome = TextEditingController();
  final controllerCognome = TextEditingController();


  Widget cognome() {
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
              controller: controllerCognome,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'Roboto'),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 10),
                prefixIcon: Icon(
                  Icons.abc,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                hintText: 'Cognome',
                hintStyle: TextStyle(color: Color.fromARGB(255, 207, 207, 207)),
              ),
            ))
      ],
    );
  }

  Widget nome() {
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
              controller: controllerNome,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'Roboto'),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 10),
                prefixIcon: Icon(
                  Icons.abc,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                hintText: 'Nome',
                hintStyle: TextStyle(color: Color.fromARGB(255, 207, 207, 207)),
              ),
            ))
      ],
    );
  }

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
      onPressed: () async {
        print('Register Button Pressed');

        if (checkFields(controllerMail, controllerPassword)) {
          String mail = controllerMail.text;
          String psw = controllerPassword.text;
          String nome = controllerNome.text;
          String cognome = controllerCognome.text;
          Map<String, String> payload = {
            'email': mail,
            'psw': psw,
            'nome': nome,
            'cognome': cognome
          };
          var utente = await DBPost(url, registerUrl, header, payload);
          if (utente.id != '') {
            showWindowDialog("Utente registrato!", context);
          } else {
            showWindowDialog("Errore, riprova perfavore", context);
          }
        }
      },
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
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
              //Colors.deepOrange,
              Color.fromARGB(255, 248, 113, 50),
              Colors.amber,
            ]))),
        Image.asset('assets/register.png'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Container(
                //alignment: Alignment.center,
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
                          height: 100,
                        ),
                        const Text(
                          'Enter your data',
                          style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(90, 0, 0, 0),
                                ),
                              ],
                              color: Color.fromARGB(255, 233, 233, 233),
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.6),
                        ),
                        SizedBox(height: 30),
                        nome(),
                        SizedBox(height: 10),
                        cognome(),
                        SizedBox(height: 10),
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

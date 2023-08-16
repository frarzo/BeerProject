//import 'package:beerstation/obj/user.dart';
//import 'package:beerstation/screens/homepage.dart';
import 'package:beerstation/users/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beerstation/utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final controllerMail = TextEditingController();
  final controllerPassword = TextEditingController();

  // widget email
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
              color: Colors.white,
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
                  color: Color.fromARGB(255, 27, 27, 27), fontFamily: 'Roboto'),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 10),
                prefixIcon: Icon(
                  Icons.person,
                  color: Color(0xff272727),
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Color(0xff272727)),
              ),
            ))
      ],
    );
  }

  // widget per la psw
  Widget password() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Colors.white,
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
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 10),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: '*******',
                hintStyle: TextStyle(color: Colors.black)),
          ),
        )
      ],
    );
  }

  Widget buttons() {
    //final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ButtonBar(
      mainAxisSize: MainAxisSize.min,
      children: [
        //LoginButton
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff0b0b0b), alignment: Alignment.center),
          onPressed: () async {
            print('Login button pressed');

            if (checkFields(controllerMail, controllerPassword)) {
              //String mail = encrypt_string(controllerMail.text);
              //String psw = encrypt_string(controllerPassword.text);
              String mail = controllerMail.text;
              String psw = controllerPassword.text;

              Map<String, String> payload = {'email': mail, 'psw': psw};
              //Richiesta POST AL SERVER PHP
              var utente = await DBPost(url, loginUrl, header, payload);
              pippo = await DBGetCons(url,
                  retrieveConsumazioniUrl,utente.id, header);
              //print('dopo richiesta');
              print(utente.getId());
              //print(utente.saldo);
              if (!(utente.getId() == '')) {
                Navigator.pushReplacementNamed(context, "homepage",
                    arguments: utente);
              } else {
                final snackbar = SnackBar(
                  content: const Text('Login Fallito :('),
                  action: SnackBarAction(
                    label: 'Ok',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            }
          },
          child: const Row(children: [
            Icon(
              Icons.login,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text('Login ',
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: 'Roboto'))
          ]),
        ),
        SizedBox(
          height: 2,
          width: 1,
        ),
        //RegisterButton
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, alignment: Alignment.center),
          onPressed: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterScreen(),
                ))
          },
          child: const Row(
            children: [
              Icon(
                Icons.email,
                color: Colors.black,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Sign Up ',
                style: TextStyle(
                    color: Color(0xff0b0b0b),
                    fontSize: 20,
                    fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget credit() {
    return const Align(
        alignment: Alignment.bottomCenter,
        child: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                  child: Icon(
                Icons.developer_mode_rounded,
                color: Colors.grey,
              )),
              TextSpan(
                  text: 'Arzon Francesco',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ));
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
        Image.asset(
          'assets/mask.png',
          fit: BoxFit.fitHeight,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
              //decoration: BoxDecoration(image: DecorationImage(image: AssetImage('img/login_final.png'),)),
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  //physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      const Text(
                        'Benvenuto',
                        style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(20, 0, 0, 0),
                              ),
                            ],
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.6),
                      ),
                      SizedBox(height: 30),
                      email(),
                      SizedBox(height: 10),
                      password(),
                      SizedBox(height: 8),
                      buttons(),
                    ],
                  )),
            ),
          ),
        )
      ],
    );
  }
}

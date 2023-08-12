import 'package:beerstation/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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
                  color: Colors.black,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black),
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
              BoxShadow(
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

  bool checkFields(mail, psw) {
    return mail.text.isNotEmpty && psw.text.isNotEmpty;
  }

  Widget buttons() {
    //final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ButtonBar(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff0b0b0b), alignment: Alignment.center),
          onPressed: () async {
            print('Login button pressed');
            if (checkFields(controllerMail, controllerPassword)) {
              String mail = encrypt_string(controllerMail.text);
              String psw = encrypt_string(controllerPassword.text);

              Map<String, String> payload = {'email': mail, 'psw': psw};
              var res = await http.post(Uri.http(url, '/api.php'),
                  headers: header, body: payload);
              print(res.statusCode);
              if (res.statusCode != 200) {
                print('Qualcosa è andato storto');
              }
            }
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePageScreen(),
                ));
          },
          child: Row(children: [
            Icon(
              Icons.login,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text('Login ',
                style: TextStyle(
                    color: Colors.white, fontSize: 28, fontFamily: 'Roboto'))
          ]),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, alignment: Alignment.center),
          onPressed: () => {},
          child: Row(
            children: [
              Icon(
                Icons.email,
                color: Colors.black,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Sign Up ',
                style: TextStyle(
                    color: Color(0xff0b0b0b),
                    fontSize: 25,
                    fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget credit() {
    return Align(
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
    return MaterialApp(
        theme: ThemeData(
            colorScheme: Theme.of(context).colorScheme, useMaterial3: true),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) {
            return Scaffold(
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,

                //onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('img/login_final.png'),
                            //NetworkImage('https://i.imgur.com/NMudl4v.png'),
                            // Backup, AssetImage a volte non funziona, boh
                            fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 17),
                      height: double.infinity,
                      child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 100,
                              ),
                              Text(
                                'Hello',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 70,
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
                    credit()
                  ],
                ),
              ),
            );
          },
        });
  }
}

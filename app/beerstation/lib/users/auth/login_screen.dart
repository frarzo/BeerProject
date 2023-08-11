import 'package:beerstation/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:beerstation/main.dart';
import 'package:beerstation/utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final controllerMail = TextEditingController();
  final controllerPassword = TextEditingController();
  //TODO: di che tipo sono oltre che al generico var???

  // widget email
  Widget email() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 15,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 60,
          child: TextField(
            controller: controllerMail,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.pink),
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 10),
                icon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.blue)),
          ),
        )
      ],
    );
  }

  // widget per la psw
  Widget password() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 15,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 60,
          child: TextField(
            controller: controllerPassword,
            obscureText: true,
            style: const TextStyle(color: Colors.pink),
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 10),
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.blue)),
          ),
        )
      ],
    );
  }

  bool checkFields(mail, psw) {
    return mail.text.isNotEmpty && psw.text.isNotEmpty;
  }

  Widget buttons() {
    return Row(
      children: [
        //login
        Container(
          child: ElevatedButton(
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
              

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePageScreen(),
                  ));
            },
            child: Text('Login'),
          ),
        ),
        //registrazione
        Container(
          child: ElevatedButton(
            onPressed: () => {},
            child: Text('Sign Up'),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.amber),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 120),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        email(),
                        SizedBox(height: 10),
                        password(),
                        buttons(),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

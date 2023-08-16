//import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:beerstation/users/auth/login_screen.dart';
import 'package:beerstation/utils.dart';
import 'package:beerstation/obj/user.dart';
//import 'package:http/http.dart' as http;
//import 'package:beerstation/obj/consumazione.dart';

List<String> pages = <String>['Homepage', 'Consumazioni', 'Pagamento'];

String mailutente = '';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({
    super.key,
  });

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  //List consumazioni = [];

  Widget lista(utente) {
    final Color oddItemColor =
        const Color.fromARGB(0, 255, 243, 189).withOpacity(0.1);
    final Color evenItemColor = oddItemColor.withOpacity(0.3);
    //print(consumazioni);
    //print('Dimensione pippo:${pippo.length}');
    return ListView.builder(
      itemCount: pippo == [] ? 0 : pippo.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          tileColor: index.isOdd ? oddItemColor : evenItemColor,
          title: Text(
              '${(pippo[index])['importo']}€    at  ${pippo[index]['data_consumazione']}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final utente = ModalRoute.of(context)?.settings.arguments as User;

    //final ColorScheme colorScheme = Theme.of(context).colorScheme;
    String saldo = utente.saldo;
    const int tabsCount = 3;
    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.amber,
          title: const Text('BeerStation App'),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.history),
                text: pages[1],
              ),
              Tab(
                icon: const Icon(Icons.home),
                text: pages[0],
              ),
              Tab(
                icon: const Icon(Icons.credit_card),
                text: pages[2],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            lista(utente),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome ${utente.nome}! 😊',
                    style: TextStyle(color: Colors.black, fontSize: 35)),
                SizedBox(
                  height: 20,
                ),
                const Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                          child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      )),
                      TextSpan(
                          text:
                              'Per lo storico delle consumazioni, swipe a sinistra',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: 'Per pagare, swipe a destra',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      WidgetSpan(
                          child: Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ))
                    ],
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Totale:',
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  '${saldo} €',
                  style: TextStyle(fontSize: 35),
                ),
                SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Per pagare, usa il pulsante',
                  style: TextStyle(
                      color: Colors.black, fontSize: 30, fontFamily: 'Roboto'),
                ),
                IconButton(
                    onPressed: () async {
                      if (await resetdebt(url, resetUrl, utente.id, header)) {
                        showWindowDialog(
                            'Pagamento confermato! (se non si aggiorna riavvia l\'app)',
                            context);
                        setState(() {
                          saldo = '0';
                        });
                      } else {
                        showWindowDialog('Pagamento fallito', context);
                      }
                    },
                    icon: Image.asset(
                      'assets/gpay_small.png',
                      scale: 1.5,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

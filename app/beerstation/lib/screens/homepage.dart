import 'package:flutter/material.dart';
import 'package:beerstation/users/auth/login_screen.dart';
import 'package:beerstation/utils.dart';
import 'package:beerstation/obj/user.dart';

List<String> pages = <String>['Homepage', 'Consumazioni', 'Pagamento'];
List

List<Object> consumazioni = <Object>[String.fromCharCode(12536), 32];

String mailutente = '';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({
    super.key,
  });

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    final utente = ModalRoute.of(context)?.settings.arguments as User;

    //final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor =
        const Color.fromARGB(0, 255, 243, 189).withOpacity(0.1);
    final Color evenItemColor = oddItemColor.withOpacity(0.3);
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
            ListView.builder(
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  tileColor: index.isOdd ? oddItemColor : evenItemColor,
                  title: Text('${pages[1]} $index'),
                );
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome ${utente.nome}! 😊',
                    style: TextStyle(color: Colors.black, fontSize: 10)),
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
                          style: TextStyle(color: Colors.black, fontSize: 7)),
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
                          style: TextStyle(color: Colors.black, fontSize: 7)),
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
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Totale:',
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  '${utente.saldo} €',
                  style: TextStyle(fontSize: 35),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Per pagare, usa il pulsante',
                  style: TextStyle(
                      color: Colors.black, fontSize: 9, fontFamily: 'Roboto'),
                ),
                IconButton(
                    onPressed: () {},
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

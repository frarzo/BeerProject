import 'package:flutter/material.dart';
import 'package:beerstation/users/auth/login_screen.dart';

//import 'package:mysql_client/mysql_client.dart';

List<String> pages = <String>['Homepage', 'Consumazioni', 'Pagamento'];
List<Object> consumazioni = <Object>[String.fromCharCode(12536), 32];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeerStation',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 255, 0, 0),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

//class Login extends StatefulWidget{}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    const int tabsCount = 3;
    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
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
            const Text('Ti puzza il culo!'),
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Il totale è: ',
                  style: TextStyle(fontSize: 35),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    icon: Image.asset(
                      'assets/gpay.png',
                      scale: 2.5,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

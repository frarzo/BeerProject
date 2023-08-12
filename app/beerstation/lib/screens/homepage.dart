import 'package:flutter/material.dart';

List<String> pages = <String>['Homepage', 'Consumazioni', 'Pagamento'];
List<Object> consumazioni = <Object>[String.fromCharCode(12536), 32];

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor =
        Color.fromARGB(0, 255, 243, 189).withOpacity(0.1);
    final Color evenItemColor = oddItemColor.withOpacity(0.3);
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
                    onPressed: () {},
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

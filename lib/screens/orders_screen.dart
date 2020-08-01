import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' as or;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // List<or.OrderItem> orders = [];
  // bool _isInit = true;
  // bool _isLoading = false;

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     loadResources();
  //     _isInit = false;
  //   }
  //   super.didChangeDependencies();
  // }

  // Future<void> loadResources() async {
  //   final ordersData = Provider.of<or.Orders>(context);
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await ordersData.fetchAndSetOrders();
  //   setState(() {
  //     orders = ordersData.orders;
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    print("calling rebuild");
    return Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          builder: (ctx, futureSnapShot) {
            if (futureSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (futureSnapShot.error == null) {
                print("Getting the orders");
                // final orders = Provider.of<or.Orders>(context).orders;
                return Consumer<or.Orders>(
                  builder: (context, value, child) => ListView.builder(
                    itemCount: value.orders.length,
                    itemBuilder: (context, i) => OrderItem(value.orders[i]),
                  ),
                );
                //     ListView.builder(
                //   itemBuilder: (ctx, i) {
                //     return OrderItem(orders[i]);
                //   },
                //   itemCount: orders.length,
                // );
              } else {
                return Center(
                  child: Text("Couldn't load the data"),
                );
              }
            }
          },
          future: Provider.of<or.Orders>(context, listen: false)
              .fetchAndSetOrders(),
        )

        // _isLoading
        //     ? Center(child: CircularProgressIndicator())
        //     : ListView.builder(
        //         itemCount: orders.length,
        //         itemBuilder: (context, i) => OrderItem(orders[i]),
        //       ),
        );
  }
}
// class OrdersListView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final orders = Provider.of<or.Orders>(context, listen: false).orders;
//     return ListView.builder(
//       itemBuilder: (ctx, i) {
//         return OrderItem(orders[i]);
//       },
//       itemCount: orders.length,
//     );
//   }
// }

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
  List<or.OrderItem> orders = [];
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadResources();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> loadResources() async {
    final ordersData = Provider.of<or.Orders>(context);
    setState(() {
      _isLoading = true;
    });
    await ordersData.fetchAndSetOrders();
    setState(() {
      orders = ordersData.orders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, i) => OrderItem(orders[i]),
            ),
    );
  }
}

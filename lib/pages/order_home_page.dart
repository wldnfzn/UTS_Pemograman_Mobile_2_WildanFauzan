import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/menu_model.dart';
import '../widgets/menu_card.dart';
import '../blocs/order_cubit.dart';
import 'order_summary_page.dart';
import 'category_stack_page.dart';

class OrderHomePage extends StatefulWidget {
  const OrderHomePage({super.key});
  @override
  State<OrderHomePage> createState() => _OrderHomePageState();
}

class _OrderHomePageState extends State<OrderHomePage> {
  String selectedCategory = 'Makanan';

  final List<MenuModel> menus = const [
    MenuModel(id: 'm1', name: 'Nasi Goreng Spesial', price: 25000, category: 'Makanan', discount: 0.1),
    MenuModel(id: 'm2', name: 'Ayam Geprek', price: 20000, category: 'Makanan', discount: 0.15),
    MenuModel(id: 'm3', name: 'Mie Ayam', price: 18000, category: 'Makanan', discount: 0.0),
    MenuModel(id: 'd1', name: 'Es Teh Manis', price: 6000, category: 'Minuman', discount: 0.0),
    MenuModel(id: 'd2', name: 'Jus Alpukat', price: 15000, category: 'Minuman', discount: 0.05),
    MenuModel(id: 'c1', name: 'Pisang Goreng', price: 8000, category: 'Cemilan', discount: 0.1),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = menus.where((m) => m.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Warung Wildan — Kasir'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderSummaryPage())), icon: const Icon(Icons.receipt_long_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CategoryStackPage(onCategorySelected: (cat) => setState(() => selectedCategory = cat)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Menu — $selectedCategory', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
                  final qty = state.items.values.fold<int>(0, (p, e) => p + e.qty);
                  final subtotal = context.read<OrderCubit>().subtotal;
                  return InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderSummaryPage())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [const Icon(Icons.shopping_cart_outlined, size: 18), const SizedBox(width: 8), Text('$qty item'), const SizedBox(width: 12), Text('Rp $subtotal', style: const TextStyle(fontWeight: FontWeight.bold))]),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => MenuCard(menu: filtered[i]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderSummaryPage())),
        icon: const Icon(Icons.payment_rounded),
        label: const Text('Bayar'),
      ),
    );
  }
}
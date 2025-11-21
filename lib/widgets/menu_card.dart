import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/menu_model.dart';
import '../blocs/order_cubit.dart';

final _currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

class MenuCard extends StatefulWidget {
  final MenuModel menu;
  const MenuCard({super.key, required this.menu});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 220), vsync: this);
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onAdd() async {
    await _controller.forward();
    _controller.reverse();
    context.read<OrderCubit>().addToOrder(widget.menu);
    // small feedback
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(SnackBar(content: Text('${widget.menu.name} ditambahkan'), duration: const Duration(milliseconds: 800)));
  }

  @override
  Widget build(BuildContext context) {
    final discounted = widget.menu.getDiscountedPrice();

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 6))],
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [Colors.deepOrange.shade200, Colors.deepOrange.shade400]),
                ),
                child: Center(child: Text(widget.menu.name[0].toUpperCase(), style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.menu.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(children: [
                    if (widget.menu.discount > 0)
                      Text(_currency.format(widget.menu.price), style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.redAccent)),
                    if (widget.menu.discount > 0) const SizedBox(width: 8),
                    Text(_currency.format(discounted), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.green)),
                  ]),
                  const SizedBox(height: 6),
                  Text(widget.menu.category, style: TextStyle(color: Colors.grey.shade600)),
                ]),
              ),
              ElevatedButton.icon(
                onPressed: _onAdd,
                icon: const Icon(Icons.add_shopping_cart_rounded),
                label: const Text('Pesan'),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
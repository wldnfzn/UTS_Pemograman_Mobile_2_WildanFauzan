import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/order_cubit.dart';

final _currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Pesanan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
                if (state.items.isEmpty) {
                  return Center(child: Text('Belum ada pesanan', style: TextStyle(color: Colors.grey.shade700)));
                }

                return ListView.separated(
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (ctx, idx) {
                    final entry = state.items.values.elementAt(idx);
                    return Dismissible(
                      key: Key(entry.menu.id),
                      background: Container(color: Colors.redAccent, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete_forever, color: Colors.white)),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => context.read<OrderCubit>().removeFromOrder(entry.menu.id),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.orange.shade200, child: Text(entry.menu.name[0].toUpperCase())),
                        title: Text(entry.menu.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text('${entry.qty} x ${_currency.format(entry.menu.getDiscountedPrice())}'),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(onPressed: () => context.read<OrderCubit>().updateQuantity(entry.menu.id, entry.qty - 1), icon: const Icon(Icons.remove_circle_outline)),
                          Text('${entry.qty}', style: const TextStyle(fontWeight: FontWeight.w800)),
                          IconButton(onPressed: () => context.read<OrderCubit>().updateQuantity(entry.menu.id, entry.qty + 1), icon: const Icon(Icons.add_circle_outline)),
                        ]),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 12),
            BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
              final cubit = context.read<OrderCubit>();
              final subtotal = cubit.subtotal;
              final total = cubit.totalWithDiscount;
              final discountApplied = subtotal > 100000;

              return Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text(_currency.format(subtotal))]),
                  const SizedBox(height: 6),
                  if (discountApplied)
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Diskon 10% (promo)'), Text('- ' + _currency.format((subtotal * 0.1).toInt()))]),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(_currency.format(total.toInt()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Hapus Semua?'),
                                content: const Text('Anda yakin ingin menghapus seluruh pesanan?'),
                                actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')), TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus'))],
                              ),
                            );
                            if (confirmed == true) context.read<OrderCubit>().clearOrder();
                          },
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Hapus Semua'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: state.items.isEmpty ? null : () => _onPay(context, total.toInt()),
                          icon: const Icon(Icons.payment),
                          label: const Text('Konfirmasi & Bayar'),
                        ),
                      ),
                    ],
                  )
                ],
              );
            })
          ],
        ),
      ),
    );
  }

  void _onPay(BuildContext context, int amount) async {
    final paid = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final controller = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Bayar Sekarang', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Total yang harus dibayar: ${_currency.format(amount)}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            TextField(controller: controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Masukkan jumlah tunai')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // simple validation
                final value = int.tryParse(controller.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                if (value >= amount) {
                  Navigator.pop(ctx, true);
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Uang kurang!')));
                }
              },
              child: const Text('Bayar'),
            ),
            const SizedBox(height: 18),
          ]),
        );
      },
    );

    if (paid == true) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Berhasil'),
          content: Text('Pembayaran Rp ${_currency.format(amount)} berhasil'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
      context.read<OrderCubit>().clearOrder();
    }
  }
}
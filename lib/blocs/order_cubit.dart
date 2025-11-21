import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../models/menu_model.dart';

class OrderItem {
  final MenuModel menu;
  int qty;
  OrderItem({required this.menu, this.qty = 1});
  int get total => menu.getDiscountedPrice() * qty;
}

@immutable
class OrderState {
  final Map<String, OrderItem> items;
  const OrderState(this.items);

  OrderState copyWith({Map<String, OrderItem>? items}) {
    return OrderState(items ?? Map.from(this.items));
  }
}

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState({}));

  void addToOrder(MenuModel menu) {
    final newMap = Map<String, OrderItem>.from(state.items);
    if (newMap.containsKey(menu.id)) {
      newMap[menu.id]!.qty += 1;
    } else {
      newMap[menu.id] = OrderItem(menu: menu, qty: 1);
    }
    emit(state.copyWith(items: newMap));
  }

  void removeFromOrder(String menuId) {
    final newMap = Map<String, OrderItem>.from(state.items);
    newMap.remove(menuId);
    emit(state.copyWith(items: newMap));
  }

  void updateQuantity(String menuId, int qty) {
    final newMap = Map<String, OrderItem>.from(state.items);
    if (qty <= 0) {
      newMap.remove(menuId);
    } else if (newMap.containsKey(menuId)) {
      newMap[menuId]!.qty = qty;
    }
    emit(state.copyWith(items: newMap));
  }

  int get subtotal {
    int t = 0;
    state.items.values.forEach((it) => t += it.total);
    return t;
  }

  double get totalWithDiscount {
    final sub = subtotal;
    if (sub > 100000) return sub * 0.9;
    return sub.toDouble();
  }

  void clearOrder() => emit(const OrderState({}));
}
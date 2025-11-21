class MenuModel {
  final String id;
  final String name;
  final int price;
  final String category;
  final double discount; // 0..1

  const MenuModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.discount = 0.0,
  });

  int getDiscountedPrice() {
    return (price - (price * discount)).toInt();
  }
}
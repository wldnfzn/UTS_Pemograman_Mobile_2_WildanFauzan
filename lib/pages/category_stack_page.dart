import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<String> {
  CategoryCubit() : super('Makanan');
  void select(String cat) => emit(cat);
}

class CategoryStackPage extends StatelessWidget {
  final Function(String) onCategorySelected;
  const CategoryStackPage({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(),
      child: BlocBuilder<CategoryCubit, String>(
        builder: (context, selected) {
          return SizedBox(
            height: 160,
            child: Stack(
              children: [
                // background image
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      selected == 'Makanan' ? 'assets/images/makanan.jpg' : 'assets/images/minuman.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: [Colors.black.withOpacity(0.30), Colors.transparent]),
                    ),
                  ),
                ),

                // chips row
                Positioned(
                  left: 12,
                  top: 12,
                  right: 12,
                  child: Row(
                    children: [
                      _chip(context, 'Makanan', selected == 'Makanan'),
                      const SizedBox(width: 8),
                      _chip(context, 'Minuman', selected == 'Minuman'),
                      const SizedBox(width: 8),
                      _chip(context, 'Cemilan', selected == 'Cemilan'),
                    ],
                  ),
                ),

                // big label
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Text(selected, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                ),

                // tappable area (passive)
                // Positioned.fill(
                //   child: Material(color: Colors.transparent),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _chip(BuildContext context, String label, bool active) {
    return GestureDetector(
      onTap: () {
        context.read<CategoryCubit>().select(label);
        onCategorySelected(label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8)] : [],
        ),
        child: Text(label, style: TextStyle(color: active ? Colors.blueGrey.shade900 : Colors.grey.shade800, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
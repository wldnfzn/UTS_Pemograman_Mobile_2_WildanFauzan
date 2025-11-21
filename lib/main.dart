import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/order_cubit.dart';
import 'pages/order_home_page.dart';

void main() {
  runApp(const UtsWildanApp());
}

class UtsWildanApp extends StatelessWidget {
  const UtsWildanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UTS - Kasir Warung',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          appBarTheme: const AppBarTheme(centerTitle: true),
          scaffoldBackgroundColor: Colors.grey.shade50,
        ),
        home: const OrderHomePage(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cubit/cart/load/load_cart_cubit.dart';
import 'cubit/order/order_cubit.dart';
import 'repository/cart_repository.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final cartBox = await Hive.openBox('cart_box');
  final ordersBox = await Hive.openBox('orders_box');

  runApp(MyApp(cartBox: cartBox, ordersBox: ordersBox));
}

class MyApp extends StatelessWidget {
  final Box cartBox;
  final Box ordersBox;

  const MyApp({super.key, required this.cartBox, required this.ordersBox});

  @override
  Widget build(BuildContext context) {
    final cartRepository = CartRepository(cartBox);

    return MultiBlocProvider(
      providers: [
        BlocProvider<CartLoadCubit>(
          create: (context) => CartLoadCubit(cartRepository)..loadCart(),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(ordersBox)..loadOrders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        themeMode: ThemeMode.dark,

        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,

          scaffoldBackgroundColor: const Color(0xFF0F172A),

          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.dark,
            surface: const Color(0xFF1E293B),
            primary: const Color(0xFF818CF8),
            secondary: const Color(0xFF34D399),
            tertiary: const Color(0xFFFBBF24),
          ),

          textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),

          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF0F172A),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Colors.transparent,
          ),
        ),

        home: const HomeScreen(),
      ),
    );
  }
}
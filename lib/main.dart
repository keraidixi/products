import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'cubit/auth/auth_cubit.dart';
import 'cubit/cart/cart_cubit.dart';
import 'cubit/auth/auth_state.dart';

import 'models/auth_model.dart';
import 'notification.dart';
import 'repository/cart_repository.dart';
import 'repository/auth_repository.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService.getDeviceToken();
  await NotificationService.initialize();

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  final userBox = await Hive.openBox<UserModel>('user_box');

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

  runApp(MyApp(cartBox: cartBox, ordersBox: ordersBox, userBox: userBox));
}

class MyApp extends StatelessWidget {
  final Box cartBox;
  final Box ordersBox;
  final Box<UserModel> userBox;

  const MyApp({
    super.key,
    required this.cartBox,
    required this.ordersBox,
    required this.userBox,
  });

  @override
  Widget build(BuildContext context) {
    final cartRepository = CartRepository(cartBox);
    final authRepository = AuthRepository(userBox);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CartRepository>(create: (_) => cartRepository),
        RepositoryProvider<AuthRepository>(create: (_) => authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CartCubit>(
            create: (context) => CartCubit(cartRepository),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepository, cartRepository),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
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

          home: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                context.read<CartCubit>().refreshCart();
              }
            },
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthSuccess) {
                  return const HomeScreen();
                }
                if (state is AuthInProgress) {
                  return const Scaffold(
                    backgroundColor: Color(0xFF0F172A),
                    body: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xFF818CF8)),
                      ),
                    ),
                  );
                }
                return LoginScreen();
              },
            ),
          ),
        ),
      ),
    );
  }
}

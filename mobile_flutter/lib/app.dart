import 'package:flutter/material.dart';

import 'core/routes/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarShopApp extends StatelessWidget {
  const CalendarShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Calendar Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      routerConfig: appRouter,
    );
  }
}

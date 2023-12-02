import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:poke_dex/models/pokemon.dart';
import 'package:poke_dex/screens/pkm_detail_page.dart';

import 'screens/homepage.dart';

void main() {
  runApp(
    MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        '/pkm_detail': (context) {
          final pkm = ModalRoute.of(context)!.settings.arguments as Pokemon;
          return PokemonDetailPage(pokemon: pkm);
        }
      },
    ),
  );
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

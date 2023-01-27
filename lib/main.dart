import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screens/map_screen.dart';

import 'bloc/bird_post_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit()..getLocation(),
        ),
        BlocProvider<BirdPostCubit>(create: (context) => BirdPostCubit()..loadPosts()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // app bar color
          primaryColor: Color(0xff0081B4),
          colorScheme: ColorScheme.light().copyWith(
              // textfield color
              primary: Color(0xFF00337C),
              // floating action button
              secondary: Color(0xFF6F1AB6)),
        ),
        home: MapScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'module/dashboard/view/dashboard_page.dart';
import 'module/dashboard/state/atendimento_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AtendimentoCubit()..carregarAtendimentos(),
      child: MaterialApp(
        title: 'Gerenciador de Atendimentos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const DashboardPage(),
      ),
    );
  }
}

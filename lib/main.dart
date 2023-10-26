import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

enum WorkmanagerServices {
  taskProductsUpdate(
    id: '72d17186-07c8-4799-9b7d-6613e787dc02',
    service: 'task-products-update',
    frequencyMinutes: 20,
  ),
  taskPricesUpdate(
    id: '927462e2-e8e1-4317-92ce-cbfdf69ec5b2',
    service: 'task-prices-update',
    frequencyMinutes: 17,
  ),
  taskStocksUpdate(
    id: 'a4e9e704-2226-4014-8760-96e11e237898',
    service: 'task-stocks-update',
    frequencyMinutes: 15,
  ),
  taskCustomersUpdate(
    id: 'd4487874-eb68-4b15-aed1-fa81ef880474',
    service: 'task-customers-update',
    frequencyMinutes: 16,
  );

  final String id;
  final String service;
  final int frequencyMinutes;

  const WorkmanagerServices(
      {required this.id,
      required this.service,
      required this.frequencyMinutes});

  static getService({required String value}) {
    for (var item in values) {
      if (item.service == value) {
        return item;
      }
    }

    return WorkmanagerServices.taskProductsUpdate;
  }
}

@pragma('vm:entry-point')
void callBackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final date = DateTime.now();

    final WorkmanagerServices services =
        WorkmanagerServices.getService(value: taskName);
    switch (services) {
      case WorkmanagerServices.taskProductsUpdate:
        await Future.delayed(const Duration(milliseconds: 13000));
        log('SERVIÇO DE ATUALIZAÇÃO DE PRODUTOS RODOU AS $date');
        break;
      case WorkmanagerServices.taskPricesUpdate:
        await Future.delayed(const Duration(milliseconds: 10000));
        log('SERVIÇO DE ATUALIZAÇÃO DE PREÇOS RODOU AS $date');
        break;
      case WorkmanagerServices.taskStocksUpdate:
        await Future.delayed(const Duration(milliseconds: 4000));
        log('SERVIÇO DE ATUALIZAÇÃO DE ESTOQUE RODOU AS $date');
        break;
      default:
        await Future.delayed(const Duration(milliseconds: 3000));
        log('SERVIÇO DE ATUALIZAÇÃO DE CLIENTES RODOU AS $date');
        break;
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().cancelAll();
  await Workmanager().initialize(callBackDispatcher);

  for (var service in WorkmanagerServices.values) {
    await Workmanager().registerPeriodicTask(
      service.id,
      service.service,
      frequency: Duration(minutes: service.frequencyMinutes),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresStorageNotLow: true,
        requiresDeviceIdle: false,
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

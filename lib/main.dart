import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workmanager_service_poc/core/db/data_base_helper.dart';
import 'package:workmanager_service_poc/core/entities/api.dart';
import 'package:workmanager_service_poc/core/repositories/product_repository.dart';
import 'package:workmanager_service_poc/data/db/data_base_helper_imp.dart';
import 'package:workmanager_service_poc/data/http/api_imp.dart';
import 'package:workmanager_service_poc/data/http/configure_dio.dart';
import 'package:workmanager_service_poc/data/repositories/product_repository_imp.dart';

final Api api = ApiImp(dio: ConfigureDio().dio);

final DataBaseHelper dataBase = DataBaseHelperImp();

final ProductRepository productRepository = ProductRepositoryImp(
  api: api,
  dataBase: dataBase,
);

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

  const WorkmanagerServices({
    required this.id,
    required this.service,
    required this.frequencyMinutes,
  });

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
        log('SERVIÇO DE ATUALIZAÇÃO DE PRODUTOS RODOU AS $date');
        final result = await productRepository.getAll(userId: 2504199);
        await productRepository.saveAll(produtcs: result);
        log('Produtos restornados pela api ${result.length}');
        break;
      case WorkmanagerServices.taskPricesUpdate:
        log('SERVIÇO DE ATUALIZAÇÃO DE PREÇOS RODOU AS $date');
        break;
      case WorkmanagerServices.taskStocksUpdate:
        log('SERVIÇO DE ATUALIZAÇÃO DE ESTOQUE RODOU AS $date');
        break;
      default:
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
    super.initState();
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

  void _init() async {
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
  }
}

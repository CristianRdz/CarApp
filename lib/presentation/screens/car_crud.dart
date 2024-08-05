import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/car_model.dart';
import '../../data/repository/car_repository.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';

class CarListView extends StatelessWidget {
  const CarListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarCubit(
        carRepository: RepositoryProvider.of<CarRepository>(context),
      ),
      child: BlocListener<CarCubit, CarState>(
        listener: (context, state) {
          if (state is CarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
          if (state is CarSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Success')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Car List'),
          ),
          body: const CarListScreen(),

        ),
      ),
    );
  }
}

class CarListScreen extends StatefulWidget {
  const CarListScreen({Key? key}) : super(key: key);

  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late CarCubit carCubit;

  @override
  void initState() {
    super.initState();
    carCubit = BlocProvider.of<CarCubit>(context);
    carCubit.fetchAllCars(); // Cargar la lista de autos automáticamente
  }

  @override
  void didUpdateWidget(covariant CarListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    carCubit = BlocProvider.of<CarCubit>(context);
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
         FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CarForm(carCubit: carCubit
              ),
            );
          },
          label: const Text('Create Car'),
          icon: const Icon(Icons.add),
        ),

        Expanded(
          child: BlocBuilder<CarCubit, CarState>(
            builder: (context, state) {
              if (state is CarLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CarSuccess) {
                final cars = state.cars;
                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index];
                    return ListTile(
                      title: Text('${car.mark} ${car.model}'),
                      subtitle: Text('Autonomy: ${car.autonomy}, Top Speed: ${car.topSpeed}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => CarForm(car: car, carCubit: carCubit),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Car'),
                                  content: Text(
                                      'Are you sure you want to delete this car?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        carCubit.deleteCar(car.id!);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is CarError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(
                  child: Text('Press the button to fetch cars'));
            },
          ),
        ),
      ],
    );
  }
}

class CarForm extends StatefulWidget {
  final CarModel? car;
  final CarCubit carCubit;


  CarForm({Key? key, this.car, required this.carCubit}) : super(key: key);

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _markController;
  late TextEditingController _modelController;
  late TextEditingController _autonomyController;
  late TextEditingController _topSpeedController;

  @override
  void initState() {
    super.initState();
    _markController = TextEditingController(text: widget.car?.mark);
    _modelController = TextEditingController(text: widget.car?.model);
    _autonomyController = TextEditingController(text: widget.car?.autonomy.toString());
    _topSpeedController = TextEditingController(text: widget.car?.topSpeed.toString());
  }

  @override
  Widget build(BuildContext context) {
    final carCubit = BlocProvider.of<CarCubit>(context);
    return AlertDialog(
      title: Text(widget.car == null ? 'Create Car' : 'Update Car'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _markController,
              decoration: InputDecoration(labelText: 'Mark'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a mark';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _modelController,
              decoration: InputDecoration(labelText: 'Model'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a model';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _autonomyController,
              decoration: InputDecoration(labelText: 'Autonomy'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a autonomy';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _topSpeedController,
              decoration: InputDecoration(labelText: 'Top Speed'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a top speed';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final car = CarModel(
                id: widget.car?.id,
                mark: _markController.text,
                model: _modelController.text,
                autonomy: double.parse(_autonomyController.text),
                topSpeed: double.parse(_topSpeedController.text),
              );
              if (widget.car == null) {
                carCubit.createCar(car);
                widget.carCubit.fetchAllCars();
              } else {
                carCubit.updateCar(car);
                widget.carCubit.fetchAllCars();
              }
              carCubit.fetchAllCars();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
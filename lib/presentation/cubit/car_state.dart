import 'package:equatable/equatable.dart';
import '../../data/models/car_model.dart';

abstract class CarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarSuccess extends CarState {
  final List<CarModel> cars;

  CarSuccess({required this.cars});

  @override
  List<Object?> get props => [cars];
}

class CarReload extends CarState {
  final List<CarModel> cars;

  CarReload({required this.cars});

  @override
  List<Object?> get props => [cars];
}

class CarError extends CarState {
  final String message;

  CarError({required this.message});

  @override
  List<Object?> get props => [message];
}
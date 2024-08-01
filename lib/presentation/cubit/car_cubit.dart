import 'package:bloc/bloc.dart';
import '../../data/models/car_model.dart';
import '../../data/repository/car_repository.dart';
import 'car_state.dart';

class CarCubit extends Cubit<CarState> {
  final CarRepository carRepository;

  CarCubit({required this.carRepository}) : super(CarInitial());

  Future<void> createCar(CarModel car) async {
    try {
      emit(CarLoading());
      await carRepository.createCar(car);
      final cars = await carRepository.getAllCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }


  Future<void> updateCar(CarModel car) async {
    try {
      emit(CarLoading());
      await carRepository.updateCar(car);
      final cars = await carRepository.getAllCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }

  Future<void> deleteCar(String id) async {
    try {
      emit(CarLoading());
      await carRepository.deleteCar(id);
      final cars = await carRepository.getAllCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }

  Future<void> fetchAllCars() async {
    try {
      emit(CarLoading());
      final cars = await carRepository.getAllCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }
}
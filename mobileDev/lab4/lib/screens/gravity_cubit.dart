import 'package:flutter_bloc/flutter_bloc.dart';

// Абстрактный класс состояния
abstract class GravityState {}

class GravityInitial extends GravityState {}

class GravityInput extends GravityState {
  final double? mass;
  final double? radius;
  final bool consent;
  final String? massError;
  final String? radiusError;

  GravityInput({
    this.mass,
    this.radius,
    this.consent = false,
    this.massError,
    this.radiusError,
  });
}

class GravityResult extends GravityState {
  final double acceleration;

  GravityResult(this.acceleration);
}

// Класс Cubit
class GravityCubit extends Cubit<GravityState> {
  GravityCubit() : super(GravityInitial());

  // Гравитационная постоянная
  static const double G = 6.67430e-11;

  void validateInput(String mass, String radius, bool consent) {
    final massValue = double.tryParse(mass.replaceAll(',', '.'));
    final radiusValue = double.tryParse(radius.replaceAll(',', '.'));
    String? massError;
    String? radiusError;

    if (massValue == null || massValue <= 0) {
      massError = 'Введите корректную массу';
    }
    if (radiusValue == null || radiusValue <= 0) {
      radiusError = 'Введите корректный радиус';
    }

    emit(
      GravityInput(
        mass: massValue,
        radius: radiusValue,
        consent: consent,
        massError: massError,
        radiusError: radiusError,
      ),
    );
  }

  void calculateGravity(double mass, double radius) {
    // g = G * M / R^2
    final acceleration = G * mass / (radius * radius);
    emit(GravityResult(acceleration));
  }

  void reset() {
    emit(GravityInitial());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'gravity_cubit.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final _massController = TextEditingController();
  final _radiusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Савин Дмитрий Николаевич',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<GravityCubit>().reset();
              _massController.clear();
              _radiusController.clear();
            },
          ),
        ],
      ),
      body: BlocBuilder<GravityCubit, GravityState>(
        builder: (context, state) {
          if (state is GravityInitial) {
            return _buildInput(context);
          } else if (state is GravityInput) {
            return _buildInput(context, state);
          } else if (state is GravityResult) {
            return _buildResult(context, state);
          }
          return const Center(child: Text('Неизвестное состояние'));
        },
      ),
    );
  }

  Widget _buildInput(BuildContext context, [GravityInput? inputState]) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Калькулятор ускорения свободного падения',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _massController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Масса небесного тела (кг)',
              errorText: inputState?.massError,
            ),
            onChanged: (value) => context.read<GravityCubit>().validateInput(
              value,
              _radiusController.text,
              inputState?.consent ?? false,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _radiusController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Радиус небесного тела (м)',
              errorText: inputState?.radiusError,
            ),
            onChanged: (value) => context.read<GravityCubit>().validateInput(
              _massController.text,
              value,
              inputState?.consent ?? false,
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            title: const Text('Согласен на обработку данных'),
            value: inputState?.consent ?? false,
            onChanged: (value) => context.read<GravityCubit>().validateInput(
              _massController.text,
              _radiusController.text,
              value ?? false,
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed:
                (inputState?.mass != null &&
                    inputState?.radius != null &&
                    inputState?.consent == true)
                ? () => context.read<GravityCubit>().calculateGravity(
                    inputState!.mass!,
                    inputState.radius!,
                  )
                : null,
            child: const Text('Рассчитать ускорение'),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context, GravityResult state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Результат расчета',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ускорение: ${state.acceleration.toStringAsFixed(6)} м/с²',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<GravityCubit>().reset();
              _massController.clear();
              _radiusController.clear();
            },
            child: const Text('Новый расчет'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/auto_repository.dart';
import '../cubit/auto_cubit.dart';
import '../cubit/auto_state.dart';
import '../../data/models/auto_model.dart';

class AutoListView extends StatelessWidget {
  const AutoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos tus autos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(227, 96, 77, 1),
        elevation: 4.0,
      ),
      body: BlocProvider(
        create: (context) => AutoCubit(
          autoRepository: RepositoryProvider.of<AutoRepository>(context),
        ),
        child: Container(
          color: Colors.white,
          child: const AutoListScreen(),
        ),
      ),
    );
  }
}

class AutoListScreen extends StatelessWidget {
  const AutoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final autoCubit = BlocProvider.of<AutoCubit>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  autoCubit.fetchAllAutos();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(123, 93, 94, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Recargar información',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<AutoCubit>(context),
                        child: const AutoFormScreen(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(123, 93, 94, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Añade un auto',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Recuerda que debes recargar la información para ver los cambios',
            style: TextStyle(
              fontSize: 11,
            ),
          ),
          Expanded(
            child: BlocBuilder<AutoCubit, AutoState>(
              builder: (context, state) {
                if (state is AutoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AutoSuccess) {
                  final autos = state.autos;
                  return ListView.builder(
                    itemCount: autos.length,
                    itemBuilder: (context, index) {
                      final auto = autos[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: const Color.fromRGBO(209, 200, 163, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                auto.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('ID: ${auto.id}'),
                              Text('Fabricante: ${auto.fabricante}'),
                              Text('Autonomía: ${auto.autonomia} km'),
                              Text(
                                  'Velocidad Máxima: ${auto.velocidadMaxima} km/h'),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider.value(
                                            value: BlocProvider.of<AutoCubit>(
                                                context),
                                            child: AutoFormScreen(auto: auto),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      context
                                          .read<AutoCubit>()
                                          .deleteAuto(auto.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is AutoError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(
                  child: Text('Presiona el botón para cargar los autos'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AutoFormScreen extends StatelessWidget {
  final AutoModel? auto;

  const AutoFormScreen({super.key, this.auto});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController(text: auto?.nombre);
    final fabricanteController = TextEditingController(text: auto?.fabricante);
    final autonomiaController = TextEditingController(text: auto?.autonomia);
    final velocidadMaximaController =
        TextEditingController(text: auto?.velocidadMaxima.toString() ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(auto == null ? 'Añadir Auto' : 'Actualizar Auto'),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: nombreController,
                label: 'Nombre',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: fabricanteController,
                label: 'Fabricante',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: autonomiaController,
                label: 'Autonomia',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: velocidadMaximaController,
                label: 'Velocidad Maxima',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final autoModel = AutoModel(
                        id: auto?.id ?? 0,
                        nombre: nombreController.text,
                        fabricante: fabricanteController.text,
                        autonomia: autonomiaController.text,
                        velocidadMaxima:
                            int.parse(velocidadMaximaController.text),
                      );

                      final autoCubit = BlocProvider.of<AutoCubit>(context);
                      if (auto == null) {
                        autoCubit.createAuto(autoModel);
                      } else {
                        autoCubit.updateAuto(autoModel);
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(123, 93, 94, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  label: Text(
                    auto == null ? 'Añadir Auto' : 'Actualizar Auto',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, completa este campo';
        }
        return null;
      },
    );
  }
}

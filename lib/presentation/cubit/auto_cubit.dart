import 'package:bloc/bloc.dart';
import '../../data/models/auto_model.dart';
import '../../data/repository/auto_repository.dart';
import 'auto_state.dart';

class AutoCubit extends Cubit<AutoState> {
  final AutoRepository autoRepository;

  AutoCubit({required this.autoRepository}) : super(AutoInitial()) {
    fetchAllAutos();
  }
  Future<void> createAuto(AutoModel auto) async {
    try {
      emit(AutoLoading());
      await autoRepository.createAuto(auto);
      emit(AutoSuccess(await autoRepository.getAllAutos()));
    } catch (e) {
      emit(AutoError(e.toString()));
    }
  }

  Future<void> updateAuto(AutoModel auto) async {
    try {
      emit(AutoLoading());
      await autoRepository.updateAuto(auto);
      emit(AutoSuccess(await autoRepository.getAllAutos()));
    } catch (e) {
      emit(AutoError(e.toString()));
    }
  }

  Future<void> deleteAuto(int id) async {
    try {
      emit(AutoLoading());
      await autoRepository.deleteAuto(id);
      emit(AutoSuccess(await autoRepository.getAllAutos()));
    } catch (e) {
      emit(AutoError(e.toString()));
    }
  }

  Future<void> fetchAllAutos() async {
    try {
      emit(AutoLoading());
      final autos = await autoRepository.getAllAutos();
      emit(AutoSuccess(autos));
    } catch (e) {
      emit(AutoError(e.toString()));
    }
  }
}

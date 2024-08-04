import 'package:equatable/equatable.dart';
import '../../data/models/auto_model.dart';

abstract class AutoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AutoInitial extends AutoState {}

class AutoLoading extends AutoState {}

class AutoSuccess extends AutoState {
  final List<AutoModel> autos;

  AutoSuccess(this.autos);
}

class AutoError extends AutoState {
  final String message;

  AutoError(this.message);
}

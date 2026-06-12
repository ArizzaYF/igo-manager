import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:igo_manager/data/models/iniciativa_model.dart';
import 'package:igo_manager/data/repositories/iniciativa_repository.dart';
import 'package:igo_manager/domain/usecases/iniciativas/actualizar_iniciativa_usecase.dart';
import 'package:igo_manager/domain/usecases/iniciativas/archivar_iniciativa_usecase.dart';
import 'package:igo_manager/domain/usecases/iniciativas/calificar_igo_usecase.dart';
import 'package:igo_manager/domain/usecases/iniciativas/crear_iniciativa_usecase.dart';
import 'package:igo_manager/domain/usecases/iniciativas/listar_iniciativas_usecase.dart';

final iniciativaRepositoryProvider = Provider<IniciativaRepository>((ref) {
  return IniciativaRepository();
});

final listarIniciativasUseCaseProvider = Provider<ListarIniciativasUseCase>(
    (ref) => ListarIniciativasUseCase(ref.read(iniciativaRepositoryProvider)));

final crearIniciativaUseCaseProvider = Provider<CrearIniciativaUseCase>(
    (ref) => CrearIniciativaUseCase(ref.read(iniciativaRepositoryProvider)));

final archivarIniciativaUseCaseProvider = Provider<ArchivarIniciativaUseCase>(
    (ref) =>
        ArchivarIniciativaUseCase(ref.read(iniciativaRepositoryProvider)));

final calificarIgoUseCaseProvider = Provider<CalificarIgoUseCase>(
    (ref) => CalificarIgoUseCase(ref.read(iniciativaRepositoryProvider)));

final actualizarIniciativaUseCaseProvider =
    Provider<ActualizarIniciativaUseCase>(
        (ref) =>
            ActualizarIniciativaUseCase(ref.read(iniciativaRepositoryProvider)));

class IniciativasNotifier
    extends StateNotifier<AsyncValue<List<IniciativaModel>>> {
  final ListarIniciativasUseCase _listarIniciativas;
  final CrearIniciativaUseCase _crearIniciativa;
  final ArchivarIniciativaUseCase _archivarIniciativa;
  final CalificarIgoUseCase _calificarIgo;
  final ActualizarIniciativaUseCase _actualizarIniciativa;

  IniciativasNotifier({
    required ListarIniciativasUseCase listarIniciativas,
    required CrearIniciativaUseCase crearIniciativa,
    required ArchivarIniciativaUseCase archivarIniciativa,
    required CalificarIgoUseCase calificarIgo,
    required ActualizarIniciativaUseCase actualizarIniciativa,
  })  : _listarIniciativas = listarIniciativas,
        _crearIniciativa = crearIniciativa,
        _archivarIniciativa = archivarIniciativa,
        _calificarIgo = calificarIgo,
        _actualizarIniciativa = actualizarIniciativa,
        super(const AsyncValue.data([]));

  Future<void> loadInitiatives(String userId) async {
    state = const AsyncValue.loading();
    final result = await _listarIniciativas(userId);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      AsyncValue.data,
    );
  }

  Future<void> createIniciativa(IniciativaModel iniciativa) async {
    final result = await _crearIniciativa(iniciativa);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (nueva) {
        state = state.whenData((list) => [...list, nueva]);
      },
    );
  }

  Future<void> updateIniciativa(IniciativaModel iniciativa) async {
    final result = await _actualizarIniciativa(iniciativa);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (updated) {
        state = state.whenData(
          (list) => list.map((i) => i.id == updated.id ? updated : i).toList(),
        );
      },
    );
  }

  Future<void> archiveIniciativa(String iniciativaId) async {
    final result = await _archivarIniciativa(iniciativaId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        state = state.whenData(
          (list) => list
              .map((i) => i.id == iniciativaId
                  ? i.copyWith(status: 'archivada')
                  : i)
              .toList(),
        );
      },
    );
  }

  Future<void> rateIniciativa({
    required String iniciativaId,
    required int importance,
    required int governability,
  }) async {
    final result = await _calificarIgo(
      iniciativaId: iniciativaId,
      importance: importance,
      governability: governability,
    );
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (updated) {
        state = state.whenData(
          (list) => list.map((i) => i.id == updated.id ? updated : i).toList(),
        );
      },
    );
  }
}

final iniciativasProvider = StateNotifierProvider<IniciativasNotifier,
    AsyncValue<List<IniciativaModel>>>((ref) {
  return IniciativasNotifier(
    listarIniciativas: ref.read(listarIniciativasUseCaseProvider),
    crearIniciativa: ref.read(crearIniciativaUseCaseProvider),
    archivarIniciativa: ref.read(archivarIniciativaUseCaseProvider),
    calificarIgo: ref.read(calificarIgoUseCaseProvider),
    actualizarIniciativa: ref.read(actualizarIniciativaUseCaseProvider),
  );
});

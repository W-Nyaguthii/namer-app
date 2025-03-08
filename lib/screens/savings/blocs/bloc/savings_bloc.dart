import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'savings_event.dart';
part 'savings_state.dart';

// Savings model class
class Savings {
  final String id;
  final String name;
  final double targetAmount;
  final String category;
  final double currentAmount;
  final DateTime targetDate;

  Savings({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.category,
    this.currentAmount = 0.0,
    required this.targetDate,
  });
}

class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  SavingsBloc() : super(SavingsInitial()) {
    on<CreateSavingsEvent>(_onCreateSavings);
    on<LoadSavingsEvent>(_onLoadSavings);
    on<UpdateSavingsAmountEvent>(_onUpdateSavingsAmount);
    on<DeleteSavingsEvent>(_onDeleteSavings);
  }

  Future<void> _onCreateSavings(
      CreateSavingsEvent event, Emitter<SavingsState> emit) async {
    try {
      emit(SavingsLoadingState());

      final uuid = Uuid();
      final newSavings = {
        "id": uuid.v4(),
        "name": event.name,
        "targetAmount": event.targetAmount,
        "category": event.category,
        "currentAmount": 0.0,
        "targetDate": event.targetDate.millisecondsSinceEpoch,
      };

      // Save to Firebase
      await FirebaseFirestore.instance.collection('savings').add(newSavings);

      emit(SavingsCreatedState());

      // Reload savings after creation
      add(LoadSavingsEvent());
    } catch (e) {
      emit(SavingsErrorState(
          message: 'Failed to create savings goal: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSavings(
      LoadSavingsEvent event, Emitter<SavingsState> emit) async {
    try {
      emit(SavingsLoadingState());

      // Fetch savings from Firebase
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('savings').get();

      List<Savings> savingsList = snapshot.docs.map((doc) {
        return Savings(
          id: doc.id,
          name: doc['name'],
          targetAmount: (doc['targetAmount'] as num).toDouble(),
          category: doc['category'],
          currentAmount: (doc['currentAmount'] as num).toDouble(),
          targetDate: DateTime.fromMillisecondsSinceEpoch(doc['targetDate']),
        );
      }).toList();

      emit(SavingsLoadedState(savingsList: savingsList));
    } catch (e) {
      emit(SavingsErrorState(
          message: 'Failed to load savings goals: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSavingsAmount(
      UpdateSavingsAmountEvent event, Emitter<SavingsState> emit) async {
    try {
      emit(SavingsLoadingState());

      // Get the document reference
      DocumentReference savingsDoc =
          FirebaseFirestore.instance.collection('savings').doc(event.savingsId);

      // Update the currentAmount field
      await savingsDoc.update({
        'currentAmount': event.newAmount,
      });

      emit(SavingsUpdatedState());

      // Reload savings after update
      add(LoadSavingsEvent());
    } catch (e) {
      emit(SavingsErrorState(
          message: 'Failed to update savings amount: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteSavings(
      DeleteSavingsEvent event, Emitter<SavingsState> emit) async {
    try {
      emit(SavingsLoadingState());

      // Get the document reference and delete it
      await FirebaseFirestore.instance
          .collection('savings')
          .doc(event.savingsId)
          .delete();

      emit(SavingsDeletedState());

      // Reload savings after deletion
      add(LoadSavingsEvent());
    } catch (e) {
      emit(SavingsErrorState(
          message: 'Failed to delete savings goal: ${e.toString()}'));
    }
  }
}

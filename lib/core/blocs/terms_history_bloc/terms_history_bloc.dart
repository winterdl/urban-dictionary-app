import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:urban_dict_slang/core/services/db/database.dart';
import 'package:urban_dict_slang/core/services/repository/terms_repository.dart';
import './bloc.dart';

class TermsHistoryBloc extends Bloc<TermsHistoryEvent, TermsHistoryState> {
  final TermsRepository termsRepository;

  TermsHistoryBloc(this.termsRepository);

  @override
  TermsHistoryState get initialState => InitialTermsHistoryState();

  @override
  Stream<TermsHistoryState> mapEventToState(
    TermsHistoryEvent event,
  ) async* {
    if (event is LoadTermsHistory) {
      yield TermsHistoryLoading();
      List<Term> terms = await termsRepository.getAllTerms();
      if (terms.length == 0) {
        yield TermsHistoryEmpty(
            "You haven't searched for slangs yet, your search history will appear here");
      } else {
        Map<int, List<Term>> termsHistory =
            termsRepository.getTermsHistory(terms);
        yield TermsHistoryLoaded(termsHistory);
      }
    }
  }
}

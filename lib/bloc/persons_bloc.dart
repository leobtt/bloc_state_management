import 'package:bloc_state_management/bloc/bloc_actions.dart';
import 'package:bloc_state_management/bloc/person.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension IsEqualIgnoringOrdering<T> on Iterable<T> {
  bool isEqualIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      'FetchResult (isRetrievedFromCache = $isRetrievedFromCache, persons = $persons)';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualIgnoringOrdering(other.persons) &&
      isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hasCode => Object.hash(persons, isRetrievedFromCache);
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonsAction>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          // We have the value in the cache
          final cachedPersons = _cache[url]!;
          final result = FetchResult(
            persons: cachedPersons,
            isRetrievedFromCache: true,
          );

          emit(result);
        } else {
          final loader = event.loader;
          final persons = await loader(url);
          _cache[url] = persons;
          final result = FetchResult(
            persons: persons,
            isRetrievedFromCache: false,
          );
          emit(result);
        }
      },
    );
  }
}

import 'package:bloc_state_management/bloc/bloc_actions.dart';
import 'package:bloc_state_management/bloc/person.dart';
import 'package:bloc_state_management/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPersons1 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];
const mockedPersons2 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

Future<Iterable<Person>> mockGetPerson1(String url) =>
    Future.value(mockedPersons1);
Future<Iterable<Person>> mockGetPerson2(String url) =>
    Future.value(mockedPersons2);

void main() {
  group(
    'testing bloc',
    () {
      late PersonsBloc bloc;

      setUp(() {
        bloc = PersonsBloc();
      });

      blocTest<PersonsBloc, FetchResult?>(
        'Test initial state',
        build: () => bloc,
        verify: (bloc) => expect(bloc.state, null),
      );

      // fetch mock data (persons1) and compare it with FetchResult
      blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPerson1,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPerson1,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons1,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons1,
            isRetrievedFromCache: true,
          ),
        ],
      );

      // fetch mock data (persons2) and compare it with FetchResult
      blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from second iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_2',
              loader: mockGetPerson2,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_2',
              loader: mockGetPerson2,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons2,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons2,
            isRetrievedFromCache: true,
          ),
        ],
      );
    },
  );
}

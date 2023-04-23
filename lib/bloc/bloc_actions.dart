import 'package:bloc_state_management/bloc/person.dart';
import 'package:flutter/foundation.dart';

// enum PersonUrl {
//   pernons1,
//   pernons2,
// }

// extension UrlString on PersonUrl {
//   String get urlString {
//     switch (this) {
//       case PersonUrl.pernons1:
//         return 'http://10.0.2.2:5500/api/persons1.json';
//       case PersonUrl.pernons2:
//         return 'http://10.0.2.2:5500/api/persons2.json';
//     }
//   }
// }

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

const persons1Url = 'http://10.0.2.2:5500/api/persons1.json';
const persons2Url = 'http://10.0.2.2:5500/api/persons2.json';

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonsLoader loader;

  const LoadPersonsAction({
    required this.url,
    required this.loader,
  }) : super();
}

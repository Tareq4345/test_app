

import 'package:fpdart/fpdart.dart';
import 'package:test_app/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FailureVoid = FutureEither<void>;




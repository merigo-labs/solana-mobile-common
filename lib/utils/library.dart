/// Imports
/// ------------------------------------------------------------------------------------------------

import 'types.dart' show JsonRpcParser;


/// Library Utilities
/// ------------------------------------------------------------------------------------------------

/// The maximum value of a `64-bit signed integer`.
const int maxInt64 = 9223372036854775807;

/// Asserts that [condition] is `true`.
/// 
/// Throws an [AssertionError] with the provided [message] if [condition] is `false`.
void check(final bool condition, [final Object? message]) {
  if (!condition) {
    throw AssertionError(message);
  }
}

/// Asserts that [condition] is `true`.
/// 
/// Throws the return value of [callback] if [condition] is `false`.
void checkThrow(final bool condition, final Object Function() callback) {
  if (!condition) {
    throw callback();
  }
}

/// Asserts that [value] is equal to [limit].
/// 
/// Throws an [AssertionError] using [label] as a descriptive name for [value].
void checkEq(final int value, final int limit, [final Object? label]) {
  if (value != limit) {
    throw AssertionError('The ${label ?? 'value'} $value must be `equal to` $limit.');
  }
}

/// Asserts that [value] is greater than [limit].
/// 
/// Throws an [AssertionError] using [label] as a descriptive name for [value].
void checkGt(final int value, final int limit, [final Object? label]) {
  if (value <= limit) {
    throw AssertionError('The ${label ?? 'value'} $value must be `greater than` $limit.');
  }
}

/// Asserts that [value] is greater than or equal to [limit].
/// 
/// Throws an [AssertionError] using [label] as a descriptive name for [value].
void checkGte(final int value, final int limit, [final Object? label]) {
  if (value < limit) {
    throw AssertionError(
      'The ${label ?? 'value'} $value must be `greater than or equal to` $limit.',
    );
  }
}

/// Asserts that [value] is less than [limit].
/// 
/// Throws an [AssertionError] using [label] as a descriptive name for [value].
void checkLt(final int value, final int limit, [final Object? label]) {
  if (value >= limit) {
    throw AssertionError('The ${label ?? 'value'} $value must be `less than` $limit.');
  }
}

/// Asserts that [value] is less than or equal to [limit].
/// 
/// Throws an [AssertionError] using [label] as a descriptive name for [value].
void checkLte(final int value, final int limit, [final Object? label]) {
  if (value > limit) {
    throw AssertionError('The ${label ?? 'value'} $value must be `less than or equal to` $limit.');
  }
}

/// Creates a [Duration] of [milliseconds].
/// 
/// Returns `null` if [milliseconds] is omitted.
Duration? tryParseDuration({ required final int? milliseconds }) {
  return milliseconds != null ? Duration(milliseconds: milliseconds) : null;
}

/// Casts [input] as type T.
/// 
/// Throws an exception if [input] is not of type T.
T cast<T>(final Object input) => input as T;

/// Calls `parse(input)` and returns its result.
/// 
/// Returns `null` if [input] is omitted.
T? tryParse<T, U>(final dynamic input, final JsonRpcParser<T, U> parse) {
  return input != null ? parse(input) : null;
}

/// Calls a [callback] function and returns its value.
/// 
/// Returns `null` if execution fails.
T? tryCall<T>(T Function() callback) {
  try {
    return callback();
  } catch (_) {
    return null;
  }
}
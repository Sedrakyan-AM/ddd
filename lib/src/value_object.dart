import 'package:ddd/src/failure.dart';

/// A base class representing a value object with validation logic.
///
/// A value object is a core concept in Domain-Driven Design (DDD) that encapsulates a value
/// along with its associated validation rules. This class allows you to define value objects
/// with specific validation requirements, and it provides methods to check the validity of
/// the value and retrieve validation errors.
///
/// The [T] generic type represents the type of the value being encapsulated.
///
/// Example usage:
/// ```dart
/// class Email extends ValueObject<String> {
///   Email(String email) : super(email, validators: [validateEmail]);
///
///   static Failure? validateEmail(String email) {
///     // Validation logic for email
///     return email.contains('@') ? null : Failure('Invalid email address');
///   }
/// }
/// ```
/// In this example, `Email` extends `ValueObject<String>` and uses a custom validator function
/// to check if the email value is valid.
///
/// The class provides:
/// - `failures`: A list of [Failure] instances representing any validation errors.
/// - `isValid`: A boolean indicating if the value is valid (i.e., no validation errors).
/// - `isNotValid`: A boolean indicating if the value is not valid (i.e., there are validation errors).
/// - `firstFailureMessage`: A string containing the message of the first validation error, or null if there are no errors.
abstract class ValueObject<T> {
  final T value;

  final List<Failure? Function(T)> validators;
  List<Failure> get failures => validators
      .map((validator) => validator(value))
      .whereType<Failure>()
      .toList();
  bool get isValid => failures.isEmpty;
  bool get isNotValid => failures.isNotEmpty;

  String? get firstFailureMessage => failures.firstOrNull?.message;

  ValueObject(this.value, {this.validators = const []});
}

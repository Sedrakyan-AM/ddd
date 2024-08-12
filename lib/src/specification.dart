/// A base class for defining specifications that encapsulate business rules or criteria.
///
/// Specifications are used to evaluate whether an entity, aggregate, or value object meets certain
/// business rules or conditions. They provide a reusable way to define and combine rules, allowing
/// for flexible and dynamic validation logic.
///
/// Specifications can be applied to entities to check if they meet certain conditions, to aggregates
/// to enforce rules across multiple related entities, or to value objects to validate their state.
///
/// Example usage:
/// ```dart
/// class AgeSpecification extends Specification<User> {
///   final int minimumAge;
///
///   AgeSpecification(this.minimumAge);
///
///   @override
///   bool isSatisfiedBy(User user) {
///     // Check if the user’s age is greater than or equal to the minimum required age
///     return user.age >= minimumAge;
///   }
/// }
/// ```
abstract class Specification<T> {
  bool isSatisfiedBy(T candidate);
}

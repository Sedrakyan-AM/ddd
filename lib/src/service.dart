/// A base class representing a service in the domain model.
///
/// Services encapsulate domain logic that doesn't naturally fit within entities or aggregates.
/// They provide operations and functionalities that are required by the domain model but are not
/// specific to any single entity or aggregate.
///
/// Example usage:
/// ```dart
/// class UserService extends Service {
///   void registerUser(String username, String email) {
///     // Register a new user
///   }
/// }
/// ```
/// In this example, `UserService` provides a method to register a new user, encapsulating business
/// logic that is independent of any single entity or aggregate.
abstract class Service {}

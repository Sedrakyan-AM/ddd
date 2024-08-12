/// A base class representing an entity in the domain model.
///
/// Entities are domain objects that have a distinct identity and are defined primarily by their
/// identity rather than their attributes. They can change their attributes over time but remain
/// uniquely identifiable.
///
/// Example usage:
/// ```dart
/// class User extends Entity {
///   final String id;
///   final String name;
///
///   User(this.id, this.name);
/// }
/// ```
/// In this example, `User` is an entity with a unique identifier `id` and an attribute `name`.
abstract class Entity {}

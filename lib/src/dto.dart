/// A base class representing a Data Transfer Object (DTO).
///
/// DTOs are used to transfer data between different layers or systems. They are typically simple data
/// containers without any business logic or behavior.
///
/// Example usage:
/// ```dart
/// class UserDTO extends DTO {
///   final String username;
///   final String email;
///
///   UserDTO(this.username, this.email);
/// }
/// ```
/// In this example, `UserDTO` is used to transfer user data across different layers of the application.
abstract class DTO {}

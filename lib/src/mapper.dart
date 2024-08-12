/// A base class for mapping between domain models and data transfer objects (DTOs).
///
/// Mappers facilitate the transformation of data between domain models and DTOs or database models.
/// They provide a way to convert between different representations of data, ensuring that domain models
/// and DTOs are properly integrated.
///
/// Example usage:
/// ```dart
/// class UserMapper extends Mapper {
///   UserDTO toDTO(User user) {
///     // Convert a User domain model to a UserDTO
///     return UserDTO(user.id, user.name);
///   }
///
///   User fromDTO(UserDTO dto) {
///     // Convert a UserDTO back to a User domain model
///     return User(dto.id, dto.name);
///   }
/// }
/// ```
abstract class Mapper<EntityType, DTOType> {
  DTOType toDTO(EntityType entity);
  EntityType fromDTO(DTOType dto);
}

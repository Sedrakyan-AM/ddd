/// A base class representing a domain event.
///
/// Domain events are used to signify that something important has occurred in the domain. They are
/// typically used to trigger side effects, update other aggregates, or communicate with external systems.
///
/// Example usage:
/// ```dart
/// class OrderPlacedEvent extends DomainEvent {
///   final Order order;
///
///   OrderPlacedEvent(this.order);
/// }
/// ```
/// In this example, `OrderPlacedEvent` is a domain event that signifies an order has been placed.
abstract class DomainEvent {}

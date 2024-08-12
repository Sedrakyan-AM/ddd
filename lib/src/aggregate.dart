/// A base class representing an aggregate in the domain model.
///
/// Aggregates are clusters of domain entities and value objects that are treated as a single unit.
/// They enforce business rules and encapsulate domain logic. Aggregates ensure consistency within
/// their boundaries by managing transactions and state changes.
///
/// Example usage:
/// ```dart
/// class OrderAggregate extends Aggregate {
///   final Order order;
///   final List<OrderItem> items;
///
///   OrderAggregate(this.order, this.items);
///
///   void addItem(OrderItem item) {
///     // Add item logic
///   }
/// }
/// ```
/// In this example, `OrderAggregate` manages an `Order` and a list of `OrderItem`s as a single unit.
abstract class Aggregate {}

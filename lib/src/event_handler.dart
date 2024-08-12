import 'package:ddd/ddd.dart';

/// A base class for handling domain events.
///
/// Event handlers are responsible for processing domain events that are dispatched by the `EventDispatcher`.
/// They contain logic to respond to events, trigger side effects, or update other parts of the system in
/// response to changes in the domain. Event handlers are typically registered to listen for specific events
/// and perform necessary actions when those events occur.
///
/// Example usage:
/// ```dart
/// class OrderEventHandler extends EventHandler {
///   @override
///   void handle(OrderPlacedEvent event) {
///     // Process the OrderPlacedEvent and perform related business logic
///   }
/// }
/// ```
abstract class EventHandler {
  void handle(DomainEvent event);
}

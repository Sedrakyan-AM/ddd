import 'package:ddd/src/domain_event.dart';
import 'dart:async';

/// A class responsible for dispatching and broadcasting domain events.
///
/// The `EventDispatcher` manages the distribution of domain events to subscribers. It allows components
/// to listen for specific events and react accordingly. This is useful for implementing event-driven
/// architectures or for decoupling different parts of the system.
///
/// Example usage:
/// ```dart
/// eventDispatcher.dispatch(OrderPlacedEvent(order));
///
/// eventDispatcher.events.listen((event) {
///   if (event is OrderPlacedEvent) {
///     // Handle OrderPlacedEvent
///   }
/// });
/// ```
/// In this example, `eventDispatcher` is used to dispatch an `OrderPlacedEvent` and listen for events.
class EventDispatcher {
  final StreamController<DomainEvent> _eventStreamController =
      StreamController<DomainEvent>.broadcast();

  /// Stream of domain events that listeners can subscribe to.
  Stream<DomainEvent> get events => _eventStreamController.stream;

  /// Dispatches a domain event to all listeners.
  ///
  /// [event] is the domain event to be dispatched.
  void dispatch(DomainEvent event) {
    _eventStreamController.add(event);
  }

  /// Closes the event stream controller, releasing any resources.
  void dispose() {
    _eventStreamController.close();
  }
}

/// A singleton instance of [EventDispatcher] for global use.
///
/// This instance can be used to dispatch and listen for domain events across the application.
final EventDispatcher eventDispatcher = EventDispatcher();

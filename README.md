# `ddd` Package

## Overview

The `ddd` package provides a set of tools and abstractions for implementing Domain-Driven Design (DDD) principles in Dart applications. Domain-Driven Design is an approach to software development that emphasizes understanding and modeling the core domain of the application to create effective and maintainable software.

This package includes foundational components such as `ValueObject`, `Aggregate`, `DomainEvent`, `Specification`, and more. These components help structure your code to better reflect the domain and its rules, making your application easier to understand and maintain.

## Key Concepts

### Domain-Driven Design (DDD)

Domain-Driven Design is a methodology for developing software that focuses on the core domain and its logic. It aims to create a model that reflects the domain's complexities and helps to address business problems effectively. Key concepts in DDD include:

- **Entities**: Objects with a distinct identity that persists over time.
- **Aggregates**: Groups of related entities treated as a single unit of consistency.
- **Value Objects**: Immutable objects that describe aspects of the domain but have no identity.
- **Repositories**: Interfaces for accessing aggregates and entities from a data store.
- **Services**: Domain-specific operations that don't naturally belong to entities or aggregates.
- **Specifications**: Rules or criteria that determine if a domain object meets certain conditions.
- **Events**: Notifications that something has happened in the domain.

## Components

### `ValueObject`

Represents an immutable object defined by its attributes, with associated validation rules.

```dart
import 'package:ddd/ddd.dart';

class Login extends ValueObject<String> {
  Login(super.value)
      : super(validators: [
          EmptyValueFailure.validator,
          NotNumericFailure.validator,
          MaxLengthFailure.getValidator(13),
        ]);
}
```

### `Aggregate`

A base class for aggregates that act as a root for a group of related entities. Aggregates ensure consistency across the group.

```dart
class PostAggregate extends Aggregate {
  final User user;
  final List<Post> posts;

  PostAggregate(this.user, this.posts);

  void addPost(Post post) {
    posts.add(post);
  }

  int get postCount => posts.length;
}
```

### `DomainEvent`

A base class for events that represent something that has happened in the domain.

```dart
class PostCreatedEvent extends DomainEvent {
  final Post post;

  PostCreatedEvent(this.post);
}

```

### `Specification`

Encapsulates business rules or criteria that an entity, aggregate, or value object must meet.

```dart
class AgeSpecification extends Specification<User> {
  final int minimumAge;

  AgeSpecification(this.minimumAge);

  @override
  bool isSatisfiedBy(User user) {
    return user.age >= minimumAge;
  }
}
```

### `Failure`

Represents the outcome of a validation check, encapsulating why a validation failed.

```dart
class EmptyValueFailure extends Failure {
  EmptyValueFailure() : super('__value_should_be_filled__');

  static EmptyValueFailure? validator(String value) {
    return value.isEmpty ? EmptyValueFailure() : null;
  }
}


class MaxLengthFailure extends Failure {
  MaxLengthFailure() : super('__max_length_exceeded__');

  static MaxLengthFailure? Function(String value) getValidator(int maxLength) {
    return (String value) {
      return _validator(maxLength, value);
    };
  }

  static MaxLengthFailure? _validator(
    int maxLength,
    String value,
  ) {
    if (value.length > maxLength) {
      return MaxLengthFailure();
    }
    return null;
  }
}
```

### `EventDispatcher`

Manages the dispatching of domain events and provides a way to listen for and handle events.

### `Repository`

A base class for repositories that manage the persistence of aggregates and entities.

### `Service`

A base class for domain-specific services that encapsulate operations or logic not naturally belonging to entities or aggregates.

## Getting Started

To use the ddd package in your Dart project:

Add ddd to your pubspec.yaml dependencies:

```yaml
dependencies:
  ddd: ^1.0.0
```

Import the package in your Dart code:

```dart
import 'package:ddd/ddd.dart';
```

Use the provided classes and abstractions to implement your domain model.

## Example

Here's a simple example that demonstrates a basic Domain-Driven Design (DDD) implementation in a Flutter, featuring two domains: User and Post.

```dart
// Domain: User
// lib/domains/user/entity.dart
import 'package:ddd/ddd.dart';

class User extends Entity {
  final String id;
  final String name;
  final Email email;
  final int age;

  User(this.id, this.name, this.email, this.age);
}

// lib/domains/user/value_object.dart
class Email extends ValueObject<String> {
  Email(super.email) : super(validators: [validateEmail]);

  static Failure? validateEmail(String email) {
    return email.contains('@') ? null : Failure('Invalid email address');
  }
}

// lib/domains/user/repository.dart
abstract class UserRepository extends Repository {
  User? findById(String id);
  void save(User user);
}

// Domain: Post
// lib/domains/post/entity.dart
class Post extends Entity {
  final String id;
  final String content;
  final String authorId;

  Post(this.id, this.content, this.authorId);
}

// lib/domains/post/repository.dart
abstract class PostRepository extends Repository {
  List<Post>? findById(String userId);
  void save(Post post);
}

// lib/domains/post/specification.dart
class MaxPostsPerUserSpecification extends Specification<UserPostAggregate> {
  final int maxPosts;

  MaxPostsPerUserSpecification(this.maxPosts);

  @override
  bool isSatisfiedBy(UserPostAggregate candidate) {
    return candidate.postCount <= maxPosts;
  }
}

// lib/domains/post/event_handler.dart
class PostEventHandler extends EventHandler {
  @override
  void handle(DomainEvent event) {
    if (event is PostCreatedEvent) {
      print("Post created by ${event.post.authorId}: ${event.post.content}");
    }
  }
}

// Domain: UserPostAggregate
// lib/domains/post_aggregate/entity.dart
class UserPostAggregate extends Aggregate {
  final User user;
  final List<Post> posts;

  UserPostAggregate(this.user, this.posts);

  void addPost(Post post) {
    posts.add(post);
  }

  int get postCount => posts.length;
}

// Domain: UserPostAggregate
// lib/domains/post_aggregate/service.dart
class UserPostAggregateService extends Service {
  final UserRepository userRepository;
  final PostRepository postRepository;
  final int maxPostsPerUser;

  UserPostAggregateService(
    this.userRepository,
    this.postRepository,
    this.maxPostsPerUser,
  );

  void createPost(String postId, String content, String userId) {
    final user = userRepository.findById(userId);
    if (user != null) {
      final post = Post(postId, content, userId);
      final posts = postRepository.findById(userId) ?? [];
      final userPostAggregate = UserPostAggregate(user, posts);

      final maxPostsSpec = MaxPostsPerUserSpecification(maxPostsPerUser);
      if (maxPostsSpec.isSatisfiedBy(userPostAggregate) &&
          userPostAggregate.postCount < maxPostsPerUser) {
        userPostAggregate.addPost(post);
        postRepository.save(post);
        userRepository.save(user); // Assuming User entity needs updating
        eventDispatcher.dispatch(PostCreatedEvent(post));
      } else {
        print("User ${user.name} has reached the maximum number of posts.");
      }
    } else {
      print("User not found, unable to create post");
    }
  }
}

// Domain: UserPostAggregate
// lib/domains/post_aggregate/domain_event.dart
class PostCreatedEvent extends DomainEvent {
  final Post post;

  PostCreatedEvent(this.post);
}

// Infrastructure: User
// lib/infrastructure/user/repository.dart
class InMemoryUserRepository extends UserRepository {
  final Map<String, User> _store = {};

  @override
  User? findById(String id) => _store[id];

  @override
  void save(User user) {
    _store[user.id] = user;
  }
}

// Infrastructure: Post
// lib/infrastructure/post/repository.dart
class InMemoryPostRepository extends PostRepository {
  final Map<String, List<Post>> _store = {};

  @override
  List<Post>? findById(String userId) => _store[userId];

  @override
  void save(Post post) {
    if (!_store.containsKey(post.authorId)) {
      _store[post.authorId] = [];
    }
    _store[post.authorId]!.add(post);
  }
}

// Core: Service Locator

/// A service locator or dependency injection container.
///
/// Manages dependencies and provides instances of classes where needed.
/// Facilitates decoupling and testing by allowing dependencies to be injected.
///
// lib/core/service_locator.dart
class ServiceLocator {
  static final Map<Type, dynamic> _services = {};

  static void register<T>(T service) {
    _services[T] = service;
  }

  static T get<T>() {
    return _services[T] as T;
  }
}

class MyAppServiceLocator extends ServiceLocator {
  static void setup() {
    ServiceLocator.register<UserRepository>(InMemoryUserRepository());
    ServiceLocator.register<PostRepository>(InMemoryPostRepository());
    ServiceLocator.register<UserPostAggregateService>(UserPostAggregateService(
      ServiceLocator.get<UserRepository>(),
      ServiceLocator.get<PostRepository>(),
      5, // Max posts per user
    ));
  }
}

// Main Application
// lib/main.dart
void main() {
  MyAppServiceLocator.setup();

  // Event Handlers
  final postEventHandler = PostEventHandler();
  eventDispatcher.events.listen((event) {
    postEventHandler.handle(event);
  });

  final userRepository = ServiceLocator.get<UserRepository>();
  userRepository.save(User('1', 'John Doe', Email('example@example.com'), 21));

  // Example of using the services
  final postAggregateService = ServiceLocator.get<UserPostAggregateService>();
  postAggregateService.createPost('101', 'Hello World', '1');
  postAggregateService.createPost('102', 'Another Post', '1');
  postAggregateService.createPost('103', 'Yet Another Post', '1');
  postAggregateService.createPost('104', 'More Content', '1');
  postAggregateService.createPost('105', 'Last Post Allowed', '1');
  postAggregateService.createPost('106', 'This Should Fail',
      '1'); // This will fail due to the specification
}

```

### Key Components:

- Entities: User and Post represent domain entities, uniquely identified by their id. These entities hold domain attributes like name, age, and content.

- Value Objects: The Email class is a value object that encapsulates an email address with validation logic, ensuring that only valid email addresses are accepted.

- Specifications: MaxPostsPerUserSpecification is a business rule used to check.

- Repositories: UserRepository and PostRepository are providing methods to retrieve and store entities.

- Domain Events: These events enable decoupled communication between different parts of the system.

- Event Handlers: EventHandlers listen for domain events and perform actions in response.

- Services: UserService and PostService encapsulate domain logic that doesn’t naturally fit within entities or aggregates, such as registering a user or creating a post.

## Contributing

Contributions are welcome! Please follow the standard procedure for contributing to open source projects:

- Fork the repository.
- Create a new branch for your feature or bug fix.
- Submit a pull request with a description of your changes.

## License

This package is licensed under the MIT License. See the LICENSE file for details.

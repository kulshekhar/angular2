import 'package:meta/meta.dart';

/// A marker that represents a lack-of-value for the `useValue` parameter.
@visibleForTesting
const Object noValueProvided = '__noValueProvided__';

/// Describes at compile-time how an Injector should be generated.
///
/// A [Provider] is a binding between a _token_ and an implementation that may
/// be _provided_ either by invoking a constructor, a function, or referring to
/// a literal value.
@optionalTypeArgs
abstract class Provider<T> implements RuntimeProvider<T> {
  const factory Provider(
    Object token, {
    Type useClass,
    Object useValue,
    Object useExisting,
    Function useFactory,
    List<Object> deps,
    bool multi,
  }) = SlowProvider<T>._;
}

/// Describes at compile-time implementing injecting [T1] by creating a [T2].
///
/// ```dart
/// const stringSink = ProviderUseClass<StringSink, StringBuffer>();
/// ```
///
/// **WARNING**: This API is experimental and not currently supported.
@experimental
class ProviderUseClass<T1, T2 extends T1> implements StaticProvider<T1> {
  @override
  final bool multi;

  /// Create a new configuration binding [T1] to creating a [T2] at runtime.
  ///
  /// __NOTE__: Once constructors support generic arguments, this will become
  /// `const factory Provider.useClass<T1, T2 extends T1>` instead, and this
  /// class will be deprecated.
  const ProviderUseClass({this.multi: false});

  @override
  Object get token => T1;

  @override
  Type get useClass => T2;

  @override
  Object get useValue => noValueProvided;

  @override
  Object get useExisting => null;

  @override
  Function get useFactory => null;

  @override
  List<Object> get dependencies => null;
}

/// An alias for `new Provider`; see [Provider].
Provider<dynamic> provide(
  Object token, {
  Type useClass,
  Object useValue: noValueProvided,
  Object useExisting,
  Function useFactory,
  List<Object> deps,
  bool multi: false,
}) =>
    new Provider<dynamic>(token,
        useClass: useClass,
        useValue: useValue,
        useExisting: useExisting,
        useFactory: useFactory,
        deps: deps,
        multi: multi);

/// A marker interface that says the provider can be inspected at compile-time.
@optionalTypeArgs
@visibleForTesting
abstract class StaticProvider<T> implements Provider<T> {}

/// A marker interface that says the provider can be inspected at runtime.
@optionalTypeArgs
@visibleForTesting
abstract class RuntimeProvider<T> {
  /// Either a [Type] or [OpaqueToken] that is an identifier for this provider.
  Object get token;

  /// If provided, creates an instance of this class to satisfy this dependency.
  Type get useClass;

  /// If provided, uses this constant value to satisfy this dependency.
  Object get useValue;

  /// If provided, returns the same instance as if this token was provided.
  Object get useExisting;

  /// If provided, invokes this method to satisfy this dependency.
  Function get useFactory;

  /// If provided, determines what dependencies are injected into [useFactory].
  List<Object> get dependencies;

  /// If `true`, providers are collected as a List instead of a single instance.
  bool get multi;
}

/// Legacy implementation of [Provider].
///
/// Contains configuration for every possibility of provider, requiring that
/// runtime injector implementations need to inspect the various properties and
/// determine how to configure themselves.
@optionalTypeArgs
@visibleForTesting
class SlowProvider<T> implements Provider<T> {
  @override
  final Object token;

  @override
  final Type useClass;

  @override
  final Object useValue;

  @override
  final Object useExisting;

  @override
  final Function useFactory;

  @override
  final List<Object> dependencies;

  @override
  final bool multi;

  const SlowProvider._(
    this.token, {
    this.useClass,
    this.useValue: noValueProvided,
    this.useExisting,
    this.useFactory,
    this.multi: false,
    List<Object> deps,
  })
      : dependencies = deps;
}

library treeuse;

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

/// A utility class for string operations.
class StringUtilities {
  /// Reverses the given [input] string.
  ///
  /// Example:
  /// ```dart
  /// final reversed = StringUtilities.reverse('hello');
  /// print(reversed); // Outputs: 'olleh'
  /// ```
  static String reverse(String input) {
    return input.split('').reversed.join();
  }
}
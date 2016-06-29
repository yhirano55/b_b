module BB
  # A general BB exception
  class Error < StandardError; end

  # Raised when using relation methods without calling required arguments.
  class ArgumentError < Error; end

  # Raised when behavior is not implemented, usually used in an abstract class.
  class NotImplementedError < Error; end

  # Raised when using evaluation methods
  class UnevaluableTypeError < Error; end
end

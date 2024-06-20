class Class {
  static var value: Int = { preconditionFailure() }()
}

Class.value = 1

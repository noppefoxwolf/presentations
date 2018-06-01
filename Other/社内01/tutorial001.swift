class Class {
  static lazy var value: Int = { preconditionFailure() }()
}

Class.value = 1

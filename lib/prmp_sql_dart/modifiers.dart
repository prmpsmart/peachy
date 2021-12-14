import 'constraints.dart' show Constraint;
import 'functions.dart' show Two_Value;

class Modifier extends Constraint {
  Modifier(value) : super(value);
}

class IDENTITY extends Two_Value {
  dynamic value;

  IDENTITY(this.value, first, second) : super(first, second);
  @override
  String get name => '$value ${super.name}';
}

class AUTOINCREMENT extends Modifier {
  AUTOINCREMENT(value) : super(value);
}

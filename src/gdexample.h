#ifndef GDEXAMPLE_H
#define GDEXAMPLE_H

#include <godot_cpp/classes/button.hpp>
#include <godot_cpp/variant/variant.hpp>
#include <libqalculate/Calculator.h>

#include <libqalculate/Unit.h>
#include <libqalculate/includes.h>
#include <string>

namespace godot {

class GDExample : public Button {
  GDCLASS(GDExample, Button);

public:
  GDExample();
  String _calculate_and_print(String input_str);
  String _unit_abbreviation(String input_str);
  int _get_function_max_args(String input_str);
  int _get_function_arg_type(String input_str, int arg_index);
  String _get_function_arg_name(String input_str, int arg_index);
  String _get_function_arg_def_val(String input_str, int arg_index);
  int _get_function_min_args(String input_str);
  void _change_precision(int precision);
  void _change_interval(bool interval);
  void _change_fraction(int fraction_type);
  void _change_angle_unit(int angle_unit);
  bool _reload_exchange_rates();

protected:
  static void _bind_methods();

private:
  EvaluationOptions eo;
  PrintOptions po;
  Calculator *calc;
};

} // namespace godot

#endif

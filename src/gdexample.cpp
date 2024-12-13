#include "gdexample.h"
#include "libqalculate/includes.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/variant/variant.hpp>

#include <libqalculate/Function.h>
#include <libqalculate/MathStructure.h>
#include <string>

using namespace godot;

/*Function to output to godot console*/
/*UtilityFunctions::print();*/

GDExample::GDExample() {
  eo = default_user_evaluation_options;
  po = default_print_options;
  po.interval_display = INTERVAL_DISPLAY_SIGNIFICANT_DIGITS;
  po.use_unicode_signs = true;
  po.number_fraction_format = FRACTION_DECIMAL_EXACT;
  calc = new Calculator();
  calc->loadExchangeRates();
  calc->loadGlobalCurrencies();
  calc->loadGlobalDefinitions();
  calc->loadLocalDefinitions();
}

String GDExample::_calculate_and_print(String input_str) {
  std::string result_str =
      calc->calculateAndPrint(input_str.utf8().get_data(), 0, eo, po, NULL);
  return godot::String::utf8(result_str.c_str());
}

String GDExample::_unit_abbreviation(String input_str) {
  std::string result_str;
  Unit *unit = calc->getUnit(input_str.utf8().get_data());
  if (unit) {
    result_str = unit->print(false, true);
  } else {
    po.is_approximate = NULL;
    Unit *unit = CALCULATOR->getCompositeUnit(input_str.utf8().get_data());
    result_str = ((CompositeUnit *)unit)->print(po, false, TAG_TYPE_HTML, true);
  }

  return godot::String::utf8(result_str.c_str());
}

int GDExample::_get_function_max_args(String input_str) {
  return CALCULATOR->getFunction(input_str.utf8().get_data())->maxargs();
}

int GDExample::_get_function_arg_type(String input_str, int arg_index) {
  int arg_type;
  if (CALCULATOR->getFunction(input_str.utf8().get_data())
          ->getArgumentDefinition(arg_index)) {
    arg_type = CALCULATOR->getFunction(input_str.utf8().get_data())
                   ->getArgumentDefinition(arg_index)
                   ->type();
  } else {
    arg_type = 0;
  }

  switch (arg_type) {
  case ARGUMENT_TYPE_BOOLEAN:
    return 1;
  case ARGUMENT_TYPE_INTEGER:
    return 2;
  case ARGUMENT_TYPE_DATA_PROPERTY:
    return 3;
  default:
    return 0;
  }
}

String GDExample::_get_function_arg_name(String input_str, int arg_index) {
  std::string text;
  if (CALCULATOR->getFunction(input_str.utf8().get_data())
          ->getArgumentDefinition(arg_index)) {
    text = CALCULATOR->getFunction(input_str.utf8().get_data())
               ->getArgumentDefinition(arg_index)
               ->name();
    if (text.empty()) {
      text = "Value ";
      text += std::to_string(arg_index);
    }
  } else {
    text = "Argument ";
    text += std::to_string(arg_index);
  }
  return godot::String::utf8(text.c_str());
}

String GDExample::_get_function_arg_def_val(String input_str, int arg_index) {
  return godot::String::utf8(
      CALCULATOR->getFunction(input_str.utf8().get_data())
          ->getDefaultValue(arg_index)
          .c_str());
}

int GDExample::_get_function_min_args(String input_str) {
  return CALCULATOR->getFunction(input_str.utf8().get_data())->minargs();
}

void GDExample::_change_precision(int precision) {
  switch (precision) {
  case 0:
    eo.approximation = APPROXIMATION_EXACT;
    break;
  case 1:
    eo.approximation = APPROXIMATION_TRY_EXACT;
    break;
  case 2:
    eo.approximation = APPROXIMATION_APPROXIMATE;
    break;
  default:
    eo.approximation = APPROXIMATION_TRY_EXACT;
    break;
  }
  return;
}

void GDExample::_change_interval(bool interval) {
  if (interval) {
    eo.interval_calculation = INTERVAL_CALCULATION_SIMPLE_INTERVAL_ARITHMETIC;
  } else {
    eo.interval_calculation = INTERVAL_CALCULATION_NONE;
  }
  return;
}

void GDExample::_change_fraction(int fraction_type) {
  switch (fraction_type) {
  case 0:
    po.number_fraction_format = FRACTION_DECIMAL;
    break;
  case 1:
    po.number_fraction_format = FRACTION_DECIMAL_EXACT;
    break;
  case 2:
    po.number_fraction_format = FRACTION_FRACTIONAL;
    break;
  case 3:
    po.number_fraction_format = FRACTION_COMBINED;
    break;
  default:
    po.number_fraction_format = FRACTION_DECIMAL_EXACT;
    break;
  }

  return;
}

void GDExample::_change_angle_unit(int angle_unit) {
  switch (angle_unit) {
  case 0:
    eo.parse_options.angle_unit = ANGLE_UNIT_DEGREES;
    break;
  case 1:
    eo.parse_options.angle_unit = ANGLE_UNIT_RADIANS;
    break;
  case 2:
    eo.parse_options.angle_unit = ANGLE_UNIT_GRADIANS;
    break;
  default:
    eo.parse_options.angle_unit = ANGLE_UNIT_NONE;
    break;
  }
}

bool GDExample::_fetch_exchange_rates() { return calc->fetchExchangeRates(); }

void GDExample::_bind_methods() {
  ClassDB::bind_method(D_METHOD("_calculate_and_print"),
                       &GDExample::_calculate_and_print);
  ClassDB::bind_method(D_METHOD("_unit_abbreviation"),
                       &GDExample::_unit_abbreviation);
  ClassDB::bind_method(D_METHOD("_get_function_max_args"),
                       &GDExample::_get_function_max_args);
  ClassDB::bind_method(D_METHOD("_get_function_arg_type"),
                       &GDExample::_get_function_arg_type);
  ClassDB::bind_method(D_METHOD("_get_function_arg_name"),
                       &GDExample::_get_function_arg_name);
  ClassDB::bind_method(D_METHOD("_get_function_arg_def_val"),
                       &GDExample::_get_function_arg_def_val);
  ClassDB::bind_method(D_METHOD("_get_function_min_args"),
                       &GDExample::_get_function_min_args);
  ClassDB::bind_method(D_METHOD("_change_precision"),
                       &GDExample::_change_precision);
  ClassDB::bind_method(D_METHOD("_change_interval"),
                       &GDExample::_change_interval);
  ClassDB::bind_method(D_METHOD("_change_fraction"),
                       &GDExample::_change_fraction);
  ClassDB::bind_method(D_METHOD("_change_angle_unit"),
                       &GDExample::_change_angle_unit);
  ClassDB::bind_method(D_METHOD("_fetch_exchange_rates"),
                       &GDExample::_fetch_exchange_rates);
  /*ADD_SIGNAL(MethodInfo("signal1"))*/
}

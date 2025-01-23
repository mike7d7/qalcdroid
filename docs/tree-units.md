# Units Tree

The unit list is generated using the `units.gd` script. It parses the `units.xml` file to get the names and the categories,
then using the `_unit_abbreviation()` function from the cpp code, it gets the name/symbol that qalculate understands when using it as input,
it's stored in the TreeItem of the unit as metadata in column 0. The `_unit_abbreviation()` function is called through the enter button,
since instancing the GDExtension class again causes issues like [#1](https://gitlab.com/mike7d7/calculator/-/issues/1#).

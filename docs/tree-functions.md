# Functions Tree

Functions are retrieved from the `functions.xml` bundled with Qalculate, then added to the Tree as TreeItems.
When a TreeItem is activated it calls the `_on_functions_item_activated` function from the `input` node where
it retrieves the pressed function and gets information of the function from libqalculate using the `enter` node's.
Based on the information retrieved, it generates a simple popup with different types of inputs so that entering the
arguments for the function is easier in a small screen.

The function `_on_functions_item_activated_grid` in the `input` node is pretty much the same, but it is only used
when a button (not a TreeItem) is activated outside the main function list (ex. Summation button in numbers2).

# Variables Tree

Variables are retrieved from the `variables.xml` bundled with Qalculate, then added to the Tree as TreeItems.
When a TreeItem is activated it calls the `_on_variables_item_activated` function from the `input` node where
it gets the variable name used in libqalculate and appends it as text in the `input` node.

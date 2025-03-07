# Popups

Popups are instanced in the editor with visibility set to hidden by default.
We use `popup_name.show()` to show them and `popup_name.hide()` to hide them.

## Show popup

We use `popup_name.show()` to show the popup.
When we show them we also have to set the `Globals.popup_number` property.

## Hide popup

We use `popup_name.hide()` to hide the popup.
When hiding the popup should emit the `popup_hide()` signal, which should
be connected to a function that sets `Globals.popup_number` to 0, to
indicate that no popup is currently open.

## Globals.popup_number

It's an int that shows which popup is currently open. The number is based on
the popups order in the editor in the main scene.

It's also used in `globals.gd` to close the popup using the back button on
Android.

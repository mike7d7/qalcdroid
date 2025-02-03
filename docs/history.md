# History

History is saved as a PackedStringArray in UserPreferences. Each entry is taken from the text written in the input node at
the moment of pressing the enter button.

The enter button calls the add_entry_to_history() function, which creates a button node inside the history_popup from the
last entry on the PackedStringArray.

When the app loads each entry on the PackedStringArray is added as a separate button inside the history_popup. 

When showing the history_popup we need to use a workaround to prevent each button from using more vertical space than
it should.

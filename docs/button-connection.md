# Button Connection

Most buttons write something to the input using a gdscript with the same name as the button node.
When pressing the enter button (the node is called GDExample), the text in the input node is sent to libqalculate.

Not all buttons have a gdscript with the same name, this is because we can reutilize a lot of scripts for multiple buttons.

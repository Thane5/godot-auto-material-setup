# Godot Auto Material Setup

Created with Godot 3.4.beta4

This Godot Tool automatically created materials based on textures. It can take multiple texture sets at once, figure out which belong together, and apply them to the correct channels based on their suffixes. You can even input suffixes for textures that carry multiple maps in their RGB channels, and apply them to AO, roughness and the metallic channel   
![image](https://i.imgur.com/RklfcHL.png)
![image](https://i.imgur.com/YdIjn9U.png)

For example, you have two files named ``robot_color.png`` and ``robot_orm.png``. Lets say you used the ``_orm`` suffix to mark textures that contain the 

**O**cclusion map in their Red channel, 

**R**oughness in ther Green channel,

**M**etallic in their Blue channel. 

The tool will automatically detect that ``robot_color.png`` is an albedo texture. For the second texture, you will have to enter ``_orm`` as the override suffix and specify the color channel.


You can also set a template material, that will be duplicated and be the base for all new materials. Great if you dont want to change tons of parameters later.


If you disable "Auto-assign maps" it will ignore the suffixes, and simply create one material per texture, using the texture as albedo.

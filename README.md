# Custom Screen Buffers

This is a Godot 4.x project showcasing how to pass custom screen buffers around using viewports. These screen buffers might include things such as colors, depth values, normals... whatever you need for your project! These buffers can then be used in post-processing shaders.

## Motivation

As of the creation of this project, Godot does not have a good system for creating and using custom buffers. You can access the color, depth, and normal-roughness buffers in screen-reading shaders (see [this doc](https://docs.godotengine.org/en/stable/tutorials/shaders/screen-reading_shaders.html)). However, these buffers are captured before the transparent geometry pass, so they can never contain any data about transparent objects. In addition, there is no way to pass custom data—only color, depth, and normal can be used. This project shows how to use viewports to overcome both of these limitations.

> **Note:** Currently Godot has a [Rendering Compositor](https://github.com/godotengine/godot-proposals/issues/7916) in the works. One of the plans for the compositor is the ability to capture and pass custom buffers from several points in the rendering pipeline, including after the transparent pass. As of Godot 4.3, there is already a new `CompositorEffect` object which partially implements this design. You can read more about how to use the `CompositorEffect` in [this doc](https://docs.godotengine.org/en/stable/tutorials/rendering/compositor.html).

## How To Use

This project can be used either as is (if all you need is the color, depth, and normal buffers), or it can be used as a point of reference as you set up your own project.

### Use As Is

To use this project without any modifications, simply add the **main_camera.tscn** scene wherever you would normally put a camera. Then, modify **screen_shader.gdshader** in order to define your post-processing shader. You will have access to the color, depth, and normal buffers in this shader. Finally, change the materials on all of your 3D objects. If the object is purely opaque, use the shader **opaque_shader.gdshader**. Otherwise, use **transparent_shader.gdshader**. Also make sure that these objects are rendering on visual layers 1 through 4.

> **Note:** There may be some limitations to how you can use **main_camera.tscn**. For example, I don't believe it will work properly to have two of them loaded at once in your project.

### Set Up From Scratch

If you want to set this up from scratch in your own project, the general steps to take are as follows:
1. You'll need multiple cameras—one for each buffer that you want to capture. You'll want all of the cameras to have the same properties *except* that they should be on different visual layers. You'll also need to make it so that their 3D transforms match.
2. Add a `SubViewport` for each of the cameras. The viewports will need to be connected to their corresponding cameras. You can do this by writing a little script, which can be put on the cameras or on the viewports. You'll make use of the method `RenderingServer.viewport_attach_camera()` to attach the cameras to the viewports (see [here](https://docs.godotengine.org/en/stable/classes/class_renderingserver.html#class-renderingserver-method-viewport-attach-camera)).
3. Pass the resulting textures from these viewports as `sampler2D` uniforms to your post-processing shader. See [this doc](https://docs.godotengine.org/en/stable/tutorials/shaders/using_viewport_as_texture.html) for an example of how to do this.
4. Finally, you'll need to write a custom shader for *all* the objects that you want to be correctly visible in these buffers that you just created. In this object shader, you'll need to output different data based on the layer that is currently being rendered. The current layer(s) are available in the shader built-in `CAMERA_VISIBLE_LAYERS`. (I believe `CAMERA_VISIBLE_LAYERS` is only available in the `vertex()` and `fragment()` functions by default, but you can also pass it as a `varying` to the `light()` function.) In addition, make sure that your objects are rendering on all the correct visual layers.

#### Notes On Passing Pure Data

For any buffer where you plan to pass pure data (unaffected by lights or other visual effects), there are a few things you have to set up to ensure the data is passed unaltered:
* For the camera, add an `Environment` resource with default settings. This ensures that the camera uses linear tonemapping.
* For the viewport, make sure to enable the `use_hdr_2d` property. (The `Environment` resource could also be added to the viewport instead of the camera.)
* For the object shader, pass the data through the `EMISSION` output in the `fragment()` function. Then, in the `light()` function, make sure that both `DIFFUSE_LIGHT` and `SPECULAR_LIGHT` are zeroed.

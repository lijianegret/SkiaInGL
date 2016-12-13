attribute vec4 a_position;
attribute vec4 a_color;
attribute vec2 a_uv;

varying vec4 v_color;
varying vec2 v_uv;

uniform mat4 u_projection;
uniform mat4 u_modelView;

void main(void) {
    v_color = a_color;
    v_uv = a_uv;
    
    gl_Position = u_projection * u_modelView * a_position;
}

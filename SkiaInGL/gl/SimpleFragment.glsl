varying lowp vec4 v_color;
varying lowp vec2 v_uv;

uniform sampler2D u_samplerTexture;

void main(void) {
    gl_FragColor = v_color + texture2D(u_samplerTexture, v_uv);
}

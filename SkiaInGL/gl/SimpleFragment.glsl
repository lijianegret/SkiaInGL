varying lowp vec4 v_color;
varying lowp vec2 v_uv;

uniform sampler2D u_samplerTexture;

void main(void) {
    lowp vec4 tex = texture2D(u_samplerTexture, v_uv);
    if (tex.a > 0.0) {
        gl_FragColor = tex;
    }
    else {
        gl_FragColor = v_color;
    }
}

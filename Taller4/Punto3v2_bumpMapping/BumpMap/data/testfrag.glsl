#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 texOffset;
uniform float kernel[9];

varying vec4 vertColor;
varying vec4 vertTexCoord;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

void main() {
  //create matrix positions
  vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
  vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
  vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
  vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
  vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
  vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
  vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
  vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);

  float col1 = texture2D(texture, tc1).r;
  float col3 = texture2D(texture, tc3).r;
  float col4 = texture2D(texture, tc4).r;
  float col5 = texture2D(texture, tc5).r;
  float col7 = texture2D(texture, tc7).r;
  
  vec2 size = vec2(2.0,0.0);
  vec3 va = normalize(vec3(size.xy, col7-col1));
  vec3 vb = normalize(vec3(size.yx, col5-col3));
  vec4 bump = vec4(cross(va,vb), col4);

  gl_FragColor = bump;
}
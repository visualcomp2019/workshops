#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec3 cameraDirection;
varying vec3 lightDirectionReflected;
varying vec3 ecNormal;

varying vec3 lightDir;
varying float att;

void main() {
   
  //Diffuse
  vec3 directionD = normalize(lightDir);
  //vec3 normal = normalize(ecNormal);
  vec3 normal = texture2D(texture, vertTexCoord.st).rgb;
  normal = normalize(2.0*normal-1.0);
  float intensityD = max(0.0, dot(directionD, normal));

  //Specular
  vec3 direction = normalize(lightDirectionReflected);
  vec3 camera = normalize(cameraDirection);
  float intensityS = max(0.0, dot(direction, camera));

  float ambientStrength = 0.5;
  float intensity = ambientStrength + intensityD + intensityS;

  vec4 tintcolor = vec4(intensity, intensity, intensity, 1) * vertColor;
  // gl_FragColor = texture2D(texture, vertTexCoord.st) * tintcolor;
  gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4(normal,1.0);
}
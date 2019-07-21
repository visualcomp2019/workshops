#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 texOffset;
//uniform vec2 mouse;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;
varying vec4 vertTexCoord;
varying vec4 vertTangent;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

void main() {
  vec3 direction = normalize(-lightDir);
  //vec3 normal = normalize(ecNormal);
  vec3 normal = texture2D(texture, vertTexCoord.st).rgb;
  normal = normalize(2.0*normal-1.0);
  
  float intensity = max(0.0, dot(direction, normal));
  vec4 tintColor = vec4(intensity, intensity, intensity, 1) * vertColor;

  gl_Position = transform * position;
  vec3 ecPosition = vec3(modelview * position);
  vec3 ecNormal = normalize(normalMatrix * normal);
  
  //Difuse
  vec3 direction = normalize(lightDir);
  float att1 = 1.0/distance(posl1, ecPosition);
  float intensity1 = max(0.0, dot(direction, ecNormal));  
  vec3 colorDiffuse = colorl1*intensity1*att1;
  
  //Specular  
  vec3 cameraDirection = normalize(0 - ecPosition);
  vec3 lightDirectionReflected = reflect(-direction, ecNormal);
  float att2 = 1.0/distance(posl2, ecPosition);
  float intensity2 = max(0.0, dot(lightDirectionReflected, cameraDirection));
  vec3 colorSpecular = colorl2*intensity2*att2;
  
  // vertColor = vec4(intensity, intensity, intensity, 1) * color;
  vertColor = (lightColor*1.0 + vec4(colorDiffuse,1)+vec4(colorSpecular,1)+color)/4;
  
  gl_FragColor = texture2D(texture, vertTexCoord.st) * tintColor;
}
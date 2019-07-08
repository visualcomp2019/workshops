uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform vec4 lightPosition;
uniform vec4 lightColor;
uniform vec3 posl1;
uniform vec3 posl2;
uniform vec3 colorl1;
uniform vec3 colorl2;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_Position = transform * position;
  vec3 ecPosition = vec3(modelview * position);
  vec3 ecNormal = normalize(normalMatrix * normal);
  
  //Difuse
  vec3 lightDirection1 = normalize(posl1 - ecPosition);
  float att1 = 1.0/distance(posl1, ecPosition);
  float intensity1 = max(0.0, dot(lightDirection1, ecNormal));  
  vec3 colorDiffuse = colorl1*intensity1*att1;
  
  //Specular  
  vec3 lightDirection2 = normalize(posl2 - ecPosition);
  vec3 cameraDirection = normalize(0 - ecPosition);
  vec3 lightDirectionReflected = reflect(-lightDirection2, ecNormal);
  float att2 = 1.0/distance(posl2, ecPosition);
  float intensity2 = max(0.0, dot(lightDirectionReflected, cameraDirection));
  vec3 colorSpecular = colorl2*intensity2*att2;
  
  // vertColor = vec4(intensity, intensity, intensity, 1) * color;
  vertColor = (lightColor*1.0 + vec4(colorDiffuse,1)+vec4(colorSpecular,1)+color)/4;
  // vertColor = (lightColor+color)/2;
  
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}
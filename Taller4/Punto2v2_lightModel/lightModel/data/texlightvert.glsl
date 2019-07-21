uniform mat4 modelviewMatrix;
uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform vec4 lightPosition[8];
uniform vec3 lightAmbient[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8];
uniform int lightCount;
uniform vec4 lightColor;
uniform vec3 posl1;
uniform vec3 posl2;
uniform vec3 colorl1;
uniform vec3 colorl2;

attribute vec4 position;
attribute vec4 color;
attribute vec4 ambient;
attribute vec4 specular;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_Position = transform * position;
  vec3 ecPosition = vec3(modelview * position);
  vec3 ecNormal = normalize(normalMatrix * normal);
  // Vertex in eye coordinates
  vec3 ecVertex = vec3(modelviewMatrix * position);

  //Ambient 
  float ambientStrength = 1.0;
  vec3 ambientColor = ambientStrength * ambient.xyz;  
  
  //Difuse
  vec3 posDL =  vec3(posl1.x,posl1.y, posl1.z);
  vec3 lightDirection1 = normalize(posDL - ecVertex);
  float att1 = 1.0/distance(posDL, ecVertex);
  float intensity1 = max(0.0, dot(lightDirection1, ecNormal));  
  vec3 colorDiffuse = colorl1*intensity1*att1;
  
  //Specular 
  vec3 posSL =  vec3(posl2.x,posl2.y, posl2.z); 
  vec3 lightDirection2 = normalize(posSL - ecVertex);
  vec3 cameraDirection = normalize(0 - ecVertex);
  vec3 lightDirectionReflected = reflect(-lightDirection2, ecNormal);
  float att2 = 1.0/distance(posSL, ecVertex);
  float intensity2 = max(0.0, dot(lightDirectionReflected, cameraDirection));
  vec3 colorSpecular = colorl2*intensity2*att2;
  

  vertColor = vec4(ambientColor,1.0) + vec4(colorDiffuse,1.0) + vec4(colorSpecular,1.0);
  
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}
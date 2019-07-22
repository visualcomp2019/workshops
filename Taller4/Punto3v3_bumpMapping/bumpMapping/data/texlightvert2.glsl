uniform mat4 modelviewMatrix;
uniform mat4 transformMatrix;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform sampler2D texture;
uniform sampler2D normalMap;

uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];
uniform vec3 lightAmbient[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8];      
uniform vec3 lightFalloff[8];
uniform vec2 lightSpot[8];
uniform vec3 posl1;
uniform vec3 posl2;
uniform vec3 colorl1;
uniform vec3 colorl2;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

attribute vec4 ambient;
attribute vec4 specular;
attribute vec4 emissive;
attribute float shininess;

varying vec4 vertColor;
varying vec4 backVertColor;
varying vec4 vertTexCoord;

const float zero_float = 0.0;
const float one_float = 1.0;
const vec3 zero_vec3 = vec3(0);


float lambertFactor(vec3 lightDir, vec3 vecNormal) {
  return max(zero_float, dot(lightDir, vecNormal));
}

float blinnPhongFactor(vec3 lightDir, vec3 vertPos, vec3 vecNormal, float shine) {
  vec3 np = normalize(vertPos);
  vec3 ldp = normalize(lightDir - np);
  return pow(max(zero_float, dot(ldp, vecNormal)), shine);
}

void main() {
  // Vertex in clip coordinates
  gl_Position = transformMatrix * position;
    
  // Vertex in eye coordinates
  vec3 ecVertex = vec3(modelviewMatrix * position);
  
  // Normal vector in eye coordinates
  // vec3 ecNormal = normalize(normalMatrix * normal);
  // vec3 ecNormalInv = ecNormal * -one_float;
  vec3 ecNormal = texture2D(normalMap, vertTexCoord.st).rgb;
  ecNormal = normalize(2.0*ecNormal-1.0);
  vec3 ecNormalInv = ecNormal * -one_float;
  
  // Light calculations
  vec3 totalAmbient = vec3(0, 0, 0);
  
  vec3 totalFrontDiffuse = vec3(0, 0, 0);
  vec3 totalFrontSpecular = vec3(0, 0, 0);
  
  vec3 totalBackDiffuse = vec3(0, 0, 0);
  vec3 totalBackSpecular = vec3(0, 0, 0);

  //Difuse
  vec3 lightDirl1 = normalize(posl1 - ecVertex);
  float att1 = 1.0/distance(posl1, ecVertex);
  
  float intensityl1 = max(0.0, dot(lightDirl1, ecNormal));  
  
  //Specular 
  vec3 lightDir2 = normalize(posl2 - ecVertex);
  vec3 cameraDirection = normalize(0 - ecVertex);
  vec3 lightDirectionReflected = reflect(-lightDir2, ecNormal);
  float att2 = 1.0/distance(posl2, ecVertex);
  float intensityl2 = max(0.0, dot(lightDirectionReflected, cameraDirection));

  
  for (int i = 0; i < 8; i++) {
    if (lightCount == i) break;  

    float falloff;    
      
    if (any(greaterThan(lightAmbient[i], zero_vec3))) {
      totalAmbient       += lightAmbient[i] * one_float;
    }
    
    if (any(greaterThan(colorl1, zero_vec3))) {      
      totalFrontDiffuse  += colorl1 * att1 * intensityl1 *  lambertFactor(lightDirl1, ecNormal);
      totalBackDiffuse   += colorl1 * att1 * intensityl1 * lambertFactor(lightDirl1, ecNormalInv);
    }
    
    if (any(greaterThan(colorl2, zero_vec3))) {
      totalFrontSpecular += colorl2 * att2 * intensityl2 * 
                            blinnPhongFactor(lightDir2, ecVertex, ecNormal, shininess);
      totalBackSpecular  += colorl2 * att2 * intensityl2 * 
                            blinnPhongFactor(lightDir2, ecVertex, ecNormalInv, shininess);
    }     
  }    
  
  // Calculating final color as result of all lights (plus emissive term).
  // Transparency is determined exclusively by the diffuse component.
  vertColor =     vec4(totalAmbient, 0) * ambient + 
                  vec4(totalFrontDiffuse, 1) * color + 
                  vec4(totalFrontSpecular, 0) * specular;
              
  backVertColor = vec4(totalAmbient, 0) * ambient + 
                  vec4(totalBackDiffuse, 1) * color + 
                  vec4(totalBackSpecular, 0) * specular;
                  
  // Calculating texture coordinates, with r and q set both to one
  // vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0); 
  vertTexCoord = texture2D(texture, vertTexCoord.st) * vec4(texCoord, 1.0, 1.0);     
  
}
precision mediump float;

uniform vec3 uLightDirection;
uniform vec3 uCameraPosition;
uniform sampler2D uTexture;

varying vec2 vTexcoords;
varying vec3 vWorldNormal;
varying vec3 vWorldPosition;

void main(void) {
    // todo - diffuse contribution
    // 1. normalize the light direction and store in a separate variable
	vec3 lightNormal = normalize(vec3(uLightDirection));
    // 2. normalize the world normal and store in a separate variable
	vec3 worldNormal = normalize(vec3(vWorldNormal));
    // 3. calculate the lambert term
	vec3 lambert = vec3(max(dot(lightNormal, worldNormal), 0.0));

    // todo - specular contribution
    // 1. in world space, calculate the direction from the surface point to the eye (normalized)
	vec3 eyeNormal = normalize(vec3(uCameraPosition - vWorldPosition));
    // 2. in world space, calculate the reflection vector (normalized)
	vec3 reflectionNormal = normalize(vec3(2.0*dot(lightNormal, worldNormal)*worldNormal-lightNormal));
    // 3. calculate the phong term
	vec3 phong = vec3(pow(max(dot(reflectionNormal, eyeNormal), 0.0), 64.0));

    vec3 albedo = texture2D(uTexture, vTexcoords).rgb;

    // todo - combine
    // 1. apply light and material interaction for diffuse value by using the texture color as the material
	vec3 diffuseColor = albedo * vec3(1, 1, 1) * lambert;
    // 2. apply light and material interaction for phong, assume phong material color is (0.3, 0.3, 0.3)
	vec3 specularColor = albedo * vec3(0.3, 0.3, 0.3) * phong;
	
    vec3 ambient = albedo * 0.1;
	
    vec3 finalColor = ambient + diffuseColor + specularColor;
	
    gl_FragColor = vec4(finalColor, 1.0);
}

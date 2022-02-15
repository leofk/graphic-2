uniform vec3 lightPosition;
uniform vec3 orbPosition;
uniform bool hit;
out vec3 colour;

void main() {
    vec4 worldPos = modelMatrix * vec4(position, 1.0);

    vec3 vertexNormal = normalize(normalMatrix*normal);

//  vec3 lightDirection = normalize(vec3(viewMatrix*(vec4(lightPosition - worldPos.xyz, 0.0))));
    vec3 lightDirection = normalize(vec3(viewMatrix*(vec4(orbPosition - worldPos.xyz, 0.0))));

    float vertexColour = dot(lightDirection, vertexNormal);
    colour = vec3(vertexColour);
//    if (hit) colour.r+=5.0;

    gl_Position = projectionMatrix * viewMatrix * worldPos;   
}
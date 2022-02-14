uniform float time;
uniform vec3 orbPosition;
const float PI = 3.14159265;
const float tht = 1.57;

out vec3 interpolatedNormal;
out vec3 colour;

void main() {

    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vec3 vertexNormal = normalize(normalMatrix*normal);
    vec3 lightDirection = normalize(vec3(viewMatrix*(vec4(orbPosition - worldPos.xyz, 0.0))));

    float vertexColour = dot(lightDirection, vertexNormal);
    colour = vec3(vertexColour, 0.0, 0.0);

    interpolatedNormal = normal;

    // TODO Q4 transform the vertex position to create deformations
    // Make sure to change the size of the orb sinusoidally with time.
    // The deformation must be a function on the vertice's position on the sphere.

    mat4 scale = mat4(
    2, 0, 0, 0,
    0, 2, 0, 0,
    0, 0, 2, 0,
    0, 0, 0, 1 );

    mat4 small = mat4(
    1/2, 0, 0, 0,
    0, 1/2, 0, 0,
    0, 0, 1/2, 0,
    0, 0, 0, 1    );

    mat4 rot1 = mat4(
    1, 0, 0, 0,
    0, cos(time), -sin(time), 0,
    0, sin(time), cos(time), 0,
    0, 0, 0, 1 );

    mat4 rot2 = mat4(
    cos(time), 0, -sin(time), 0,
    0, 1, 0, 0,
    sin(time), 0, cos(time), 0,
    0, 0, 0, 1 );

    mat4 rot3 = mat4(
    cos(time), -sin(time), 0, 0,
    sin(time), cos(time), 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1 );

    mat4 lame = mat4(
    1, 1, 0, 0,
    1, 2, 1, 0,
    0, 1, 1, 0,
    0, 0, 0, 1 );

    mat4 ref = mat4(
    cos(tht), -sin(tht), 0, 0,
    sin(tht), cos(tht), 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1 );

    mat4 ref2 = mat4(
    cos(tht), 0, -sin(tht), 0,
    0, 1, 0, 0,
    sin(tht), 0, cos(tht), 0,
    0, 0, 0, 1 );

    mat4 ref3 = mat4(
    1, 0, 0, 0,
    0, cos(tht), -sin(tht), 0,
    0, sin(tht), cos(tht), 0,
    0, 0, 0, 1 );

    // reference: https://machinesdontcare.wordpress.com/2008/10/08/parametric-heart/
    float u = position.x * PI;
    float v = position.y * 2.0 * PI;

    vec4 heart;
    heart.x = (cos(u) * sin(v)) - pow(abs(sin(u) * sin(v)), 1.0) * 0.7;
    heart.y = cos(v) * 0.4;
    heart.z = sin(u) * sin(v);
    heart.w = 1.0;


    mat4 heartMat = rot2 * ref * ref3 * scale;
    vec4 heart1 = heartMat * heart * max(abs(sin(time)), 0.7);

    vec4 heart2 = ref * ref3 * scale * heart * abs(sin(time));

    mat4 boringMat = scale * rot1 * rot2 * lame;
    vec4 boring = boringMat * vec4(position, 1.0) * sin(time);

    vec4 standard = vec4(position, 1.0) * cos(time);

//    vec3 modifiedPos = heart1.xyz;                  // Option 1: throbbing heart
      vec3 modifiedPos = standard.xyz + heart2.xyz; // Option 2: sphere -> heart
//    vec3 modifiedPos = standard.xyz + boring.xyz; // Option 3: sphere -> ellipsoid


    // Multiply each vertex by the model matrix to get the world position of each vertex, 
    // then the view matrix to get the position in the camera coordinate system, 
    // and finally the projection matrix to get final vertex position.
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(modifiedPos, 1.0);
}

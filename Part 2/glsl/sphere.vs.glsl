uniform float time;
uniform float hitTime;
uniform vec3 orbPosition;
uniform bool hit;

const float PI = 3.14159265;
const float tht = 1.57;

out vec3 colour;

void main() {

    vec4 worldPos = modelMatrix * vec4(position, 1.0);
    vec3 vertexNormal = normalize(normalMatrix*normal);
    vec3 lightDirection = normalize(vec3(viewMatrix*(vec4(orbPosition - worldPos.xyz, 0.0))));

    float vertexColour = dot(lightDirection, vertexNormal);
    colour = vec3(vertexColour, 0.0, 0.0);
    if (hit) colour = vec3(0.0, vertexColour, vertexColour);

    mat4 scale = mat4(
    2, 0, 0, 0,
    0, 2, 0, 0,
    0, 0, 2, 0,
    0, 0, 0, 1 );

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
    vec3 modifiedPos = heart1.xyz;

    if (hit) {
        scale *= hitTime;
        mat4 hitMat = rot2 * ref * ref3 * scale;
        vec4 hitHeart = hitMat * heart;
        modifiedPos = hitHeart.xyz;
    }

    // Multiply each vertex by the model matrix to get the world position of each vertex, 
    // then the view matrix to get the position in the camera coordinate system, 
    // and finally the projection matrix to get final vertex position.
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(modifiedPos, 1.0);
}

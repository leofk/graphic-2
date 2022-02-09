uniform float time;

out vec3 interpolatedNormal;

void main() {

    interpolatedNormal = normal;

    // TODO Q4 transform the vertex position to create deformations
    // Make sure to change the size of the orb sinusoidally with time.
    // The deformation must be a function on the vertice's position on the sphere.
    vec3 modifiedPos = position * sin(time);

    // Multiply each vertex by the model matrix to get the world position of each vertex, 
    // then the view matrix to get the position in the camera coordinate system, 
    // and finally the projection matrix to get final vertex position.
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(modifiedPos, 1.0);
}

in vec3 interpolatedNormal;

void main() {
  	gl_FragColor = vec4(interpolatedNormal, 1.0);
}

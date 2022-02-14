in vec3 interpolatedNormal;
in vec3 colour;

void main() {
//  	gl_FragColor = vec4(colour, 1.0);
	gl_FragColor = vec4(interpolatedNormal, 1.0);
}

/*
 * UBC CPSC 314, 2021WT1
 * Assignment 2 Template
 */

// Setup and return the scene and related objects.
// You should look into js/setup.js to see what exactly is done here.
const {
  renderer,
  scene,
  camera,
  worldFrame,
} = setup();

/////////////////////////////////
//   YOUR WORK STARTS BELOW    //
/////////////////////////////////

// Initialize uniforms

const lightOffset = { type: 'v3', value: new THREE.Vector3(0.0, 5.0, 5.0) };

const time = {type: 'float', value: 0}

const orbPosition = { type: 'v3', value: new THREE.Vector3(0.0, 10.0, 0.0) };

// Materials: specifying uniforms and shaders

const armadilloMaterial = new THREE.ShaderMaterial({
  uniforms: {
    lightOffset: lightOffset,
    orbPosition: orbPosition,
  }
});

const sphereMaterial = new THREE.ShaderMaterial({
  uniforms: {
    // HINT pass uniforms to sphere shader here
    time: time,
    orbPosition: orbPosition,
  }
});

const eyeMaterial = new THREE.ShaderMaterial({
  uniforms: {
    orbPosition: orbPosition,
  }
});

const armadilloFrame = new THREE.Object3D();
armadilloFrame.position.set(0, 0, -8);

scene.add(armadilloFrame);

const transformationMatrixR = {type: 'mat4', value: new THREE.Matrix4()};
const transformationMatrixL = {type: 'mat4', value: new THREE.Matrix4()};

// Load shaders.
const shaderFiles = [
  'glsl/armadillo.vs.glsl',
  'glsl/armadillo.fs.glsl',
  'glsl/sphere.vs.glsl',
  'glsl/sphere.fs.glsl',
  'glsl/eye.vs.glsl',
  'glsl/eye.fs.glsl'
];

new THREE.SourceLoader().load(shaderFiles, function (shaders) {
  armadilloMaterial.vertexShader = shaders['glsl/armadillo.vs.glsl'];
  armadilloMaterial.fragmentShader = shaders['glsl/armadillo.fs.glsl'];

  sphereMaterial.vertexShader = shaders['glsl/sphere.vs.glsl'];
  sphereMaterial.fragmentShader = shaders['glsl/sphere.fs.glsl'];

  eyeMaterial.vertexShader = shaders['glsl/eye.vs.glsl'];
  eyeMaterial.fragmentShader = shaders['glsl/eye.fs.glsl'];
});

// Load and place the Armadillo geometry.
loadAndPlaceOBJ('obj/armadillo.obj', armadilloMaterial, armadilloFrame, function (armadillo) {
  armadillo.rotation.y = Math.PI;
  armadillo.position.y = 5.3
  armadillo.scale.set(0.1, 0.1, 0.1);
});

// https://threejs.org/docs/#api/en/geometries/SphereGeometry
const sphereGeometry = new THREE.SphereGeometry(1.0, 32.0, 32.0);
const sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
scene.add(sphere);

const sphereLight = new THREE.PointLight(0xffffff, 1, 100);
scene.add(sphereLight);
sphereLight.position.set(0, 10, 0);

sphere.position.set(0, 10, 5);


// Eyes (Q1a and Q1b)
// Create the eye ball geometry
const eyeGeometry = new THREE.SphereGeometry(1.0, 32, 32);

// HINT Q1a: Add the eyes on the armadillo here.
const rightEye = new THREE.Mesh(eyeGeometry, eyeMaterial);
rightEye.scale.set(0.5, 0.5, 0.5);
rightEye.position.set(0.8,12,3);
armadilloFrame.add(rightEye);

const leftEye = new THREE.Mesh(eyeGeometry, eyeMaterial);
leftEye.scale.set(0.5, 0.5, 0.5);
leftEye.position.set(-0.8,12,3);
armadilloFrame.add(leftEye);

// Laser Beams (Q1b Q1c)

// Distance threshold beyond which the armadillo should shoot lasers at the sphere (needed for Q1c).
const LaserDistance = 10.0;

const laserGeometry = new THREE.CylinderGeometry(0.25, 0.25, 1.0);
const laserMaterial = new THREE.MeshPhongMaterial({ color: 0xff0000, wireframe: false });

// HINT Q1b: create the two lasers and apply the appropriate transformations.
//           you can use a Quaternion object for the rotation and a generic Object3D for scaling.
// HINT: Create meshes for the lasers with the above geometry and material
// HINT: What should we use as the parent objects for the laser meshes?

const quaternion = new THREE.Quaternion();
quaternion.setFromAxisAngle( new THREE.Vector3( 1, 0, 0 ), Math.PI / 2 );

const laserLeft = new THREE.Mesh(laserGeometry, laserMaterial);
// laserLeft.rotation.set(Math.PI/2, 0, 0);
laserLeft.applyQuaternion(quaternion);
leftEye.add(laserLeft);

const laserRight = new THREE.Mesh(laserGeometry, laserMaterial);
// laserRight.rotation.set(Math.PI/2, 0, 0);
laserRight.applyQuaternion(quaternion);
rightEye.add(laserRight);

// Listen to keyboard events.
const keyboard = new THREEx.KeyboardState();
function checkKeyboard() {

  //HINT: Use keyboard.pressed to check for keyboard input. 
  //Example: keyboard.pressed("A") to check if the A key is pressed.

  // The following tells three.js that some uniforms might have changed.
  armadilloMaterial.needsUpdate = true;
  sphereMaterial.needsUpdate = true;
  eyeMaterial.needsUpdate = true;

  // Distance to orb
  // HINT Q1b and Q1c: set/update the position (for static and tracking lasers) and scale (laser length) needed for tracking here.
  // HINT: three.js Positions have a distanceTo function which gives you the distance between two points.
  // HINT: three.js Meshes have a visible property which you can use to hide or show the lasers.

  let leftEyePos = new THREE.Vector3();
  leftEyePos.setFromMatrixPosition(leftEye.matrixWorld);

  let rightEyePos = new THREE.Vector3();
  rightEyePos.setFromMatrixPosition(rightEye.matrixWorld);

  let orbPos = new THREE.Vector3();
  orbPos.setFromMatrixPosition(sphere.matrixWorld);

  if ((leftEyePos.distanceTo(orbPos) && rightEyePos.distanceTo(orbPos)) <= LaserDistance) {
    laserLeft.visible = true;
    laserRight.visible = true;

    laserLeft.scale.y = leftEyePos.distanceTo(orbPos) * 2;
    laserLeft.position.z = leftEyePos.distanceTo(orbPos);
    laserRight.scale.y = rightEyePos.distanceTo(orbPos) * 2;
    laserRight.position.z = rightEyePos.distanceTo(orbPos);

  } else {
    laserLeft.visible = false;
    laserRight.visible = false;
  }

  if (keyboard.pressed("s")) // backwards
    sphere.position.z += 0.2

  if (keyboard.pressed("d")) // right
    sphere.position.x += 0.2

  if (keyboard.pressed("w")) // forwards
    sphere.position.z -= 0.2

  if (keyboard.pressed("a")) // left
    sphere.position.x -= 0.2

  if (keyboard.pressed("q")) // up
    sphere.position.y += 0.2

  if (keyboard.pressed("e")) // down
    sphere.position.y -= 0.2

  // sphereLight.position = orbPosition;
}



// Setup update callback
function update() {
  checkKeyboard();

  time.value += 1/60;//Assumes 60 frames per second

  // HINT: Use one of the lookAt functions available in three.js to make the eyes look at the orb.
  leftEye.lookAt(sphere.position);
  rightEye.lookAt(sphere.position);

  // Requests the next update call, this creates a loop
  requestAnimationFrame(update);
  renderer.render(scene, camera);
}

// Start the animation loop.
update();

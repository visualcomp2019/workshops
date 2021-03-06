/*
 * Eagle.
 * by Sebastian Chaparro Cuevas.
 * 
 * This example shows how to use ik module in order to interact with an .obj model. 
 * First we define a Skeleton and relate it with a .obj (via Skinning class)  
 * Then we register a solver on the Scene and add a Target that the Wings must follow. 
 * We use an Interpolator per Wing in order to define a motion.
 * 
 * Press 's' to enable/disable skeleton visualization.
 * Press 'c' to change between GPU/CPU mode.
 * Press 'i' to show/hide info. 
 * Press 'a' to visualize which joints influence the most a region of the mesh. 
 * Press 'd' to disable Paint mode. 
 */

import nub.core.*;
import nub.core.constraint.*;
import nub.primitives.*;
import nub.processing.*;
import nub.ik.solver.*;
import nub.ik.skinning.*;
import nub.ik.visual.Joint; //Joint provides default way to visualize the skeleton
import java.util.List;

import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice device; // my SpaceNavigator
ControlSlider snXPos; // Positions
ControlSlider snYPos;
ControlSlider snZPos;
ControlSlider snXRot; // Rotations
ControlSlider snYRot;
ControlSlider snZRot;
ControlButton button1; // Buttons
ControlButton button2;

boolean snPicking;

boolean showSkeleton = true;
boolean showInfo = true;
boolean constraintSkeleton = true;
Scene scene;
Node reference;

List<Node> skeleton;
Skinning skinning;

Interpolator[] targetInterpolator = new Interpolator[2];

String shapePath = "EAGLE_2.OBJ";
String texturePath = "EAGLE2.jpg";

//Flag used to visualize which joint influences the most a region of the mesh
int activeRegion = 0;  
boolean gpu = true;

void settings() {
    size(700, 700, P3D);
}

void setup() {
    
    openSpaceNavigator();
    
    //1. Create and set the scene
    scene = new Scene(this);
    scene.setType(Graph.Type.ORTHOGRAPHIC);
    scene.setRightHanded();
    scene.fit(1);
    //2. Define the Skeleton
    //2.1 Define a reference node to the skeleton and the mesh
    reference = new Node(scene);
    reference.enableTracking(false); //disable interaction
    //2.2 Use SimpleBuilder example (or a Modelling Sw if desired) and locate each Joint accordingly to mesh
    //2.3 Create the Joints based on 2.2.
    skeleton = loadSkeleton(reference);
    
    //2.4 define constraints (if any)
    //Find axis of rotation via cross product
    if(constraintSkeleton) setConstraints();
    
    //3. Relate the shape with a skinning method (CPU or GPU)
    resetSkinning(gpu);
    //4. Adding IK behavior
    //4.1 Identify root and end effector(s)
    Node root = skeleton.get(0); //root is the fist joint of the structure
    List<Node> endEffectors = new ArrayList<Node>(); //End Effectors are leaf nodes (with no children)
    for(Node node : skeleton) {
        if (node.children().size() == 0) {
            endEffectors.add(node);
        }
    }

    //4.2 relate a skeleton with an IK Solver
    Solver solver = scene.registerTreeSolver(root);
    //Update params
    solver.setMaxError(1f);
    solver.setMaxIterations(15);

    for(Node endEffector : endEffectors){
        //4.3 Create target(s) to relate with End Effector(s)
        PShape redBall = createShape(SPHERE, scene.radius() * 0.02f);
        redBall.setStroke(false);
        redBall.setFill(color(255,0,0, 220));
        Node target = new Node(scene, redBall);
        target.setPickingThreshold(0);
        target.setReference(reference); //Target also depends on reference
        target.setPosition(endEffector.position().get());
        //4.4 Relate target(s) with end effector(s)
        scene.addIKTarget(endEffector, target);
        //disable enf effector tracking
        endEffector.enableTracking(false);

        //If desired generates a default Path that target must follow
        if(endEffector == skeleton.get(14)){
          targetInterpolator[0] = setupTargetInterpolator(target, new Vector[]{new Vector(-48,0,0), new Vector(-40,-13,0), new Vector(-32,0,0) , new Vector(-40,20,0), new Vector(-48,0,0)});
        }

        if(endEffector == skeleton.get(18)){
          targetInterpolator[1] = setupTargetInterpolator(target, new Vector[]{new Vector(44,0,0), new Vector(38,-16,0), new Vector(28.5,0,0) , new Vector(38,19,0), new Vector(44,0,0)});
        } 
        
    }
    //use this method to visualize which node influences the most on a region of the mesh.
    if(skinning instanceof GPULinearBlendSkinning)
        ((GPULinearBlendSkinning) skinning).paintAllJoints();

}

void draw(){
    // println(button1.getValue() +" "+ button2.getValue());
    background(0);
    lights();
    scene.drawAxes();
    //Render mesh with respect to the node
    skinning.render(reference);
    if(showSkeleton){
      scene.render();
      pushStyle();
      fill(255);
      stroke(255);
      scene.drawPath(targetInterpolator[0],1);
      scene.drawPath(targetInterpolator[1],1);
      popStyle();
    }
    //Optionally print some info:
    scene.beginHUD();
    text("Mode: " + (gpu ? "GPU " : "CPU") + " Frame rate: " + nf(frameRate, 0, 1), width/2, 50);    
    if(showInfo){
      for(int i = 0; i < skinning.skeleton().size(); i++){
          if(skinning.skeleton().get(i).translation().magnitude() == 0){
              continue;
          }
          fill(255);
          Vector p = scene.screenLocation(skinning.skeleton().get(i).position());
          text("" + i, p.x(), p.y());
          Vector pos = skinning.skeleton().get(i).position();
      }

      for(Interpolator interpolator : targetInterpolator){
        for(Node node : interpolator.keyFrames()){
          pushStyle();
          Vector p = scene.screenLocation(node.position());
          text(round(node.translation().x()) + "," + round(node.translation().y()) + "," + round(node.translation().z()), p.x() - 5, p.y());
          popStyle();
        }
      }

      String msg = activeRegion == 0 ? "Painting all Joints" : activeRegion == -1 ? "" : "Painting Joint : " + activeRegion;
      text(msg,width/2, height - 50);
    }
    scene.endHUD();
    
  if (snPicking)
    spaceNavigatorPicking();
  else
    spaceNavigatorInteraction();
    
}

void resetSkinning(boolean gpu){
  //move sekeleton to rest position (in this case is when nodes are all aligned)
  for(Node node : skeleton){
    node.setRotation(new Quaternion());
  }
  
  if(gpu){
    skinning = new GPULinearBlendSkinning(skeleton, this.g, shapePath, texturePath, scene.radius(), false);    
  } else{
    skinning = new CPULinearBlendSkinning(skeleton, this.g, shapePath, texturePath, scene.radius(), false);    
  }
}

void mouseMoved() {
    scene.cast();
}

void mouseDragged() {
    if (mouseButton == LEFT){
        scene.spin();
    } else if (mouseButton == RIGHT) {
        scene.translate();
    } else {
        scene.scale(mouseX - pmouseX);
    }
}

void mouseWheel(MouseEvent event) {
    scene.scale(event.getCount() * 20);
}

void mouseClicked(MouseEvent event) {
    if (event.getCount() == 2)
        if (event.getButton() == LEFT)
            scene.focus();
        else
            scene.align();
}

void keyPressed() {
    if(key == 'S' || key == 's'){
        showSkeleton = !showSkeleton;
    }
    if(key == 'C' || key == 'c'){
        gpu = !gpu;
        resetSkinning(gpu);
    }

    if(key == 'A' || key == 'a') {
        activeRegion = (activeRegion + 1) % skinning.skeleton().size();
        if(skinning instanceof GPULinearBlendSkinning)
          ((GPULinearBlendSkinning) skinning).paintJoint(activeRegion);
    }

    if(key == 'd' || key == 'D'){
        if(skinning instanceof GPULinearBlendSkinning)
          ((GPULinearBlendSkinning) skinning).disablePaintMode();
    }
        
    if(key == 'i' || key == 'I'){
        showInfo = !showInfo;
    }
    
    if (key == ' ')
      snPicking = !snPicking;
    
}

//Skeleton is generated by interacting with SimpleBuilder
/* No Local coordinate has rotation (all are aligned with respect to reference system coordinates)
    J1 |-> Node translation: [ -1.7894811E-7, -1.2377515, -1.5709928 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
        J2 |-> Node translation: [ 6.425498E-7, 1.2980552, 5.463369 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
            J3 |-> Node translation: [ 6.5103023E-7, 0.23802762, 5.4746757 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
        J4 |-> Node translation: [ -4.70038E-7, -2.0343544, -4.0577974 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
            J5 |-> Node translation: [ -4.5386977E-7, -4.236917, -4.046496 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
        J6 |-> Node translation: [ -6.223473E-7, 1.202842, -5.1527314 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
            J7 |-> Node translation: [ -7.298398E-7, -0.33323926, -6.1411514 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
                J8 |-> Node translation: [ -6.5542355E-7, -0.4284538, -5.5222764 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
        J9 |-> Node translation: [ -5.269003, 3.248286, -1.3883741 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
            J10 |-> Node translation: [ -12.133301, 5.3501167, 0.6687609 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
                J11 |-> Node translation: [ -19.107552, 5.445654, 2.483986 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
        J12 |-> Node translation: [ 8.201833, 3.9170508, -1.8660631 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
            J13 |-> Node translation: [ 11.942226, 5.541193, 1.8152181 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
                J14 |-> Node translation: [ 13.184211, 3.8215134, 2.3884451 ]rotation axis: [ 0.0, 0.0, 0.0 ]rotation angle : 0.0
*/
List<Node> loadSkeleton(Node reference){
  JSONArray skeleton_data = loadJSONArray("skeleton.json");
  HashMap<String, Joint> dict = new HashMap<String, Joint>();
  List<Node> skeleton = new ArrayList<Node>();
  for(int i = 0; i < skeleton_data.size(); i++){
    JSONObject joint_data = skeleton_data.getJSONObject(i);
    Joint joint = new Joint(scene, joint_data.getFloat("radius"));
    joint.setPickingThreshold(joint_data.getFloat("picking"));
    if(i == 0){
      joint.setRoot(true);
      joint.setReference(reference);
    }else{
      joint.setReference(dict.get(joint_data.getString("reference")));
    }
    joint.setTranslation(joint_data.getFloat("x"), joint_data.getFloat("y"), joint_data.getFloat("z"));
    joint.setRotation(joint_data.getFloat("q_x"), joint_data.getFloat("q_y"), joint_data.getFloat("q_z"), joint_data.getFloat("q_w"));
    skeleton.add(joint);
    dict.put(joint_data.getString("name"), joint);
  }  
  return skeleton;
}


void setConstraints(){
    Node j11 = skeleton.get(11);
    Vector up11 = j11.children().get(0).translation();//Same as child translation 
    Vector twist11 = Vector.cross(up11, new Vector(0,1,0), null);//Same as child translation 
    Hinge h11 = new Hinge(radians(40), radians(40), j11.rotation(), up11, twist11);
    j11.setConstraint(h11);
    
    
    Node j12 = skeleton.get(12);
    Vector up12 = j12.children().get(0).translation();//Same as child translation 
    Vector twist12 = Vector.cross(up12, new Vector(0,1,0), null);//Same as child translation 
    Hinge h12 = new Hinge(radians(40), radians(40), j12.rotation(), up12, twist12);
    j12.setConstraint(h12);
    
    Node j13 = skeleton.get(13);
    Vector up13 = j13.children().get(0).translation();//Same as child translation 
    Vector twist13 = Vector.cross(up13, new Vector(0,1,0), null);//Same as child translation 
    Hinge h13 = new Hinge(radians(45), radians(5), skeleton.get(13).rotation(), up13, twist13);
    j13.setConstraint(h13);

    
    Node j15 = skeleton.get(15);
    Vector up15 = j15.children().get(0).translation();//Same as child translation 
    Vector twist15 = Vector.cross(up15, new Vector(0,1,0), null);//Same as child translation 
    Hinge h15 = new Hinge(radians(40), radians(40), j15.rotation(), up15, twist15);
    j15.setConstraint(h15);
    
    
    Node j16 = skeleton.get(16);
    Vector up16 = j16.children().get(0).translation();//Same as child translation 
    Vector twist16 = Vector.cross(up16, new Vector(0,1,0), null);//Same as child translation 
    Hinge h16 = new Hinge(radians(40), radians(40), j16.rotation(), up16, twist16);
    j16.setConstraint(h16);
    
    Node j17 = skeleton.get(17);
    Vector up17 = j17.children().get(0).translation();//Same as child translation 
    Vector twist17 = Vector.cross(up17, new Vector(0,1,0), null);//Same as child translation 
    Hinge h17 = new Hinge(radians(45), radians(5), skeleton.get(17).rotation(), up17, twist17);
    j17.setConstraint(h17);
}

Interpolator setupTargetInterpolator(Node target, Vector[] positions) {
    Interpolator targetInterpolator = new Interpolator(target);
    targetInterpolator.setLoop();
    targetInterpolator.setSpeed(1f);
    // Create a path
    for(int i = 0; i < positions.length; i++){
        Node iFrame = new Node(scene);
        iFrame.setPickingThreshold(5);
        iFrame.setReference(target.reference());
        iFrame.setTranslation(positions[i]);
        targetInterpolator.addKeyFrame(iFrame);
    }
    targetInterpolator.start();
    return targetInterpolator;
}

void spaceNavigatorPicking() {
  float x = map(snXPos.getValue(), -.8f, .8f, 0, width);
  float y = map(snYPos.getValue(), -.8f, .8f, 0, height);
  // update the space navigator tracked node:
  scene.cast("SPCNAV", x, y);
  // draw picking visual hint
  pushStyle();
  strokeWeight(3);
  stroke(0, 255, 0);
  scene.drawCross(x, y, 30);
  popStyle();
}

void spaceNavigatorInteraction() {
  scene.translate("SPCNAV", 10 * snXPos.getValue(), 10 * snYPos.getValue(), 10 * snZPos.getValue());
  scene.rotate("SPCNAV", -snXRot.getValue() * 20 * PI / width, snYRot.getValue() * 20 * PI / width, snZRot.getValue() * 20 * PI / width);
}

void openSpaceNavigator() {
  println(System.getProperty("os.name"));
  control = ControlIO.getInstance(this);
  String os = System.getProperty("os.name").toLowerCase();
  if (os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0)
    device = control.getDevice("3Dconnexion SpaceNavigator");// magic name for linux
  else
    device = control.getDevice("SpaceNavigator");//magic name, for windows
  if (device == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  //device.setTolerance(5.00f);
  snXPos = device.getSlider(0);
  snYPos = device.getSlider(1);
  snZPos = device.getSlider(2);
  snXRot = device.getSlider(3);
  snYRot = device.getSlider(4);
  snZRot = device.getSlider(5);
  button1 = device.getButton(0); // possible values: 0.0 or 8.0
  button2 = device.getButton(1); // possible values: 0.0 or 8.0
}

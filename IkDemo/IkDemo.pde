/**
 * IkDemo - CGI Tools
 * by Peter Dodds (peterdodds.co.uk)
 * NCCA MSc Computer Animation and Visual Effects 2009-10
 */

import processing.opengl.*;
import toxi.geom.Matrix4x4;
import toxi.geom.Vec3D;
import toxi.geom.Vec2D;
import toxi.geom.Quaternion;


// Graphics buffer used for mouse picking
PGraphics buffer;
// Font used for text output
PFont font;

// The main camera
CCamera camera1;

// The scene root.
// All CGraphNode and CNodes to be drawn must be a child of this node.
CGraphNode root;
// The IK goal node.
// Stored gobally within the application to allow display() to update it.
CGraphNode goal1;

// Key function flags set and cleared by keyPressed() and keyReleased()
// Camera spin direction. Set by space (+1) and SHIFT-space (-1)
int spin = 0;
// Is shift key pressed.
boolean shift = false;
// Move goal in the x-axis. Set by up (+1) and down (-1) arrows
int moveX = 0;
// Move goal in the y-axis. Set by page up (+1) and page down (-1)
int moveY = 0;
// Move goal in the z-axis. Set by left (+1) and right (-1) arrows
int moveZ = 0;


//------------------------------------------------------------------------------

// Scene setup.
// All application initialisation occurs here: creating the viewport, camera, scene hierarchy, and creating the IK chain.
void setup() { //{{{
    // initialise opengl and create second display buffer.
    size(720, 576, OPENGL);
    hint(ENABLE_OPENGL_4X_SMOOTH);
    buffer = createGraphics(width, height, P3D);
    frameRate(30);

    // load the font.
    font = loadFont("FreeSans-16.vlw");
    textFont (font, 16);

    // position the camera
    camera1 = new CCamera (this, 0.1, 1000);
    camera1.jump(100,200,400);
    camera1.aim(0,0,0);
    camera1.roll(PI);

    // Build the bone chain
    CBone bone1 = new CBone(1);
    CBone bone2 = new CBone(2);
    CBone bone3 = new CBone(3);
    CBone bone4 = new CBone(4);
    bone1.addChild(bone2,100);
    bone2.addChild(bone3,75);
    bone3.addChild(bone4,50);

    // default position
    bone1.yaw(PI/4);
    bone2.pitch(PI/4);
    bone3.roll(PI/4);

    
    // create the scene root and add the bone network to the scene.
    root = new CGraphNode();
    root.addChild(bone1);

    // create the IK chain and set the goal position
    CIkChain ik1 = new CIkChain(bone1,bone4);
    goal1 = new CGraphNode(100,20,30,999);
    root.addChild(goal1);

    ik1.setGoal(goal1,false);
} //}}}

//------------------------------------------------------------------------------

// Draw function called on every frame.
void draw() { //{{{
    // Reset the display
    background(30);
    lights();

    // update the camera
    camera1.circle(0.03*spin);
    // update the IK goal
    goal1.position.x += moveX * 1;
    goal1.position.y += moveY * 1;
    goal1.position.z += moveZ * 1;

    // apply the camera to the main output buffer 'g'
    camera1.feed(this.g);

    // Draw the scene hierarchy
    noStroke();
    root.display(this.g);

    // Draw a grid
    stroke(0x44999999);
    int gridsize = 200;
    for(int x = -200 ; x < 210 ; x += 10)
        line(x, 0, 200, x, 0,-200);
    for(int z = -200 ; z < 210 ; z += 10)
        line(200, 0, z,-200, 0, z);
    
    // set to orthographic mod...
    ortho(0,width,-height,0,-1,1);
    camera(0,0,-0.5, 0,0,0.5, 0,1,0);
    resetMatrix();
    
    // write text information to the screen
    fill(0xffffffff);
    text(round(frameRate), 15, 30);
}//}}}

//------------------------------------------------------------------------------

// Keyboard key press.
void keyPressed() {
    if (key == ' ') {
        if (shift)
            spin = -1;
        else
            spin = 1;
    }
    else if (key == CODED){
        switch (keyCode) {
            case UP:
                moveX = 1;
                break;
            case DOWN:
                moveX = -1;
                break;
            case LEFT:
                moveZ = 1;
                break;
            case RIGHT:
                moveZ = -1;
                break;
            case KeyEvent.VK_PAGE_UP:
                moveY = 1;
                break;
            case KeyEvent.VK_PAGE_DOWN:
                moveY = -1;
                break;
            case SHIFT:
                shift = true;
                break;
        }
    }
}

// Keyboard key release.
void keyReleased() {
    if(key == ' ')
        spin = 0;
    else if (key == CODED){
        switch (keyCode) {
            case UP:
            case DOWN:
                moveX = 0;
                break;
            case LEFT:
            case RIGHT:
                moveZ = 0;
                break;
            case KeyEvent.VK_PAGE_UP:
            case KeyEvent.VK_PAGE_DOWN:
                moveY = 0;
                break;
            case SHIFT:
                shift = false;
                break;
        }
    }
}


// Mouse click event.
// Tests the picking buffer which was added but not used...
void mouseClicked() {
    // picking code taken from http://processinghacks.com/hacks:picking
    // @author nicolas clavaud

    // draw the picking buffer
    buffer.beginDraw();
    buffer.background(0);
    buffer.noStroke();
    camera1.feed(buffer);
    root.idDisplay(buffer);
    buffer.endDraw();

    // Get the colour under the mouse, strip the alpha 
    // and convert it to an integer to get the node's id.
    color pickColor = buffer.get(mouseX, mouseY);
    int pick = pickColor - 0xFF000000;

    // just print the id of the clicked node ...
    if( pick != 0 )
        println( pick );
}


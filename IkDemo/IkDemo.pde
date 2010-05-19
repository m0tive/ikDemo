/**
 * IkDemo - CGI Techniques
 * by Peter Dodds (peterdodds.co.uk)
 * NCCA MSc Computer Animation and Visual Effects 2009-10
 *
 * [Instructions]
 *
 * [Description]
 */

import processing.opengl.*;
import toxi.geom.Matrix4x4;
import toxi.geom.Vec3D;
import toxi.geom.Vec2D;
import toxi.geom.Quaternion;


PGraphics buffer;
PFont font;

CCamera camera1;

CGraphNode root;
CGraphNode goal1;

int spin = 0;
boolean shift = false;
int moveX = 0;
int moveY = 0;
int moveZ = 0;

void setup() { //{{{
    size(720, 576, OPENGL);
    hint(ENABLE_OPENGL_4X_SMOOTH);
    buffer = createGraphics(width, height, P3D);

    frameRate(30);

    font = loadFont("FreeSans-16.vlw");
    textFont (font, 16);

    camera1 = new CCamera (this, 0.1, 1000);
    camera1.jump(100,200,400);
    camera1.aim(0,0,0);
    camera1.roll(PI);

    noStroke();
    CBone bone1 = new CBone(1);
    CBone bone2 = new CBone(2);
    CBone bone3 = new CBone(3);
    CBone bone4 = new CBone(4);
    bone1.addChild(bone2,100);
    bone2.addChild(bone3,75);
    bone3.addChild(bone4,50);

    bone1.yaw(PI/4);
    bone2.pitch(PI/4);
    bone3.roll(PI/4);

    root = new CGraphNode();
    root.addChild(bone1);

    println(bone1.getMatrix());
    println();
    println(bone2.getMatrix());

    CIkChain ik1 = new CIkChain(bone1,bone4);
    goal1 = new CGraphNode(100,20,30,999);
    root.addChild(goal1);

    ik1.setGoal(goal1,false);

} //}}}

void draw() { //{{{
    background(30);

    lights();

    camera1.circle(0.03*spin);

    goal1.position.x += moveX * 1;
    goal1.position.y += moveY * 1;
    goal1.position.z += moveZ * 1;

    camera1.feed(this.g);

    noStroke();
    root.display(this.g);

    stroke(0x44999999);
    int gridsize = 200;
    for(int x = -200 ; x < 210 ; x += 10)
        line(x, 0, 200, x, 0,-200);
    for(int z = -200 ; z < 210 ; z += 10)
        line(200, 0, z,-200, 0, z);
    
    ortho(0,width,-height,0,-1,1);
    camera(0,0,-0.5, 0,0,0.5, 0,1,0);

    resetMatrix();

    fill(0xffffffff);
    text(round(frameRate), 15, 30);
}//}}}

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

void mouseClicked() {
    // picking code taken from http://processinghacks.com/hacks:picking
    // @author nicolas clavaud

    buffer.beginDraw();
    buffer.background(0);
    buffer.noStroke();
    camera1.feed(buffer);
    root.idDisplay(buffer);
    buffer.endDraw();

    color pickColor = buffer.get(mouseX, mouseY);
    int pick = pickColor - 0xFF000000;

    if( pick != 0 )
        println( pick );
}


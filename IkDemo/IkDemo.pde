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
import matrixMath.*;

PGraphics buffer;
PFont font;

CCamera camera1;

CGraphNode root;

int spin = 0;

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

    bone1.m_yaw = PI/4;
    bone2.m_pitch = PI/4;
    bone2.m_roll = PI/4;
    bone3.m_roll = PI/4;

    CIkChain ik1 = new CIkChain(bone1,bone4);

    root = new CGraphNode();
    root.addChild(bone1);
} //}}}

void draw() { //{{{
    background(30);

    lights();

    camera1.circle(0.03*spin);

    camera1.feed(this.g);

    noStroke();
    root.display(this.g);

    stroke(0x44999999);
    int gridsize = 200;
    for(int x = -200 ; x < 210 ; x += 10)
        line(x, 0, 200, x, 0,-200);
    for(int z = -200 ; z < 210 ; z += 10)
        line(200, 0, z,-200, 0, z);

}//}}}

void keyPressed() {
    if(key == ' ')
        spin = 1;
}

void keyReleased() {
    if(key == ' ')
        spin = 0;
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


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

PFont font;

CCamera camera1;

void setup() { //{{{
    size(720, 576, OPENGL);
    frameRate(30);

    font = loadFont("FreeSans-16.vlw");
    textFont (font, 16);

    camera1 = new CCamera (this, 0.1, 1000);
    camera1.jump(10,200,400);
    camera1.aim(0,0,0);
} //}}}

void draw() { //{{{
    background(40);

    camera1.feed(this.g);

    box(100);

}//}}}

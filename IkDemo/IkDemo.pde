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

Node root;
Node selected;

boolean building = true;

PFont font;

void setup() {
    size(720, 576);

    font = loadFont("FreeSans-16.vlw");
    textFont (font, 16);
}

void draw() {
    background(190);

    smooth();

    if (root != null)
        root.display();

    fill(0x66ffffff);
    noStroke();
    rect(0,0,720,50);
    fill(0xff000000);
    if (building)
        text("Building mode: Click to insert new nodes. Press SPACE to go to animation mode", 15, 30);
    else
        text("Animation mode: Select and drag a joint. Press SPACE to go to building mode...",15,30);
}

void mousePressed() {
    println("mousePressed : "  + mouseX + " " + mouseY );
    if (building)
        addJoint(mouseX, mouseY);
}

void keyPressed() {
    if (key == ' ')
        toggleBuildmode();
}

boolean toggleBuildmode() {
    building = ! building;
    if (building){
        selected = (Node) root.getTips().get(0);
    } else {
        selected.highlight = false;
        selected = null;
    }
    return building;
}

void addJoint(int x, int y) {
    println("addJoint " + x + " " + y );
    if ( root == null ) {
        selected = root = new Node ( x, y, null );
    } else {
        if ( selected != null )
            selected.highlight = false;
        selected = selected.add( x, y );
        selected.highlight = true;
    }
}

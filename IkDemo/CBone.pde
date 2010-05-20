// A bone used in a 3D skeleton.
// This extends CGraphNode by adding display functions and custom addChild
// function for adding bones at an offset.
class CBone extends CGraphNode {

    // Constructors to call parent constructors
    CBone (int _id) { super(_id); }
    CBone (float _x, float _y, float _z) { super(_x,_y,_z); }
    CBone (float _x, float _y, float _z, int _id) { super(_x,_y,_z,_id); }

    //--------------------------------------------------------------------------

    // Drawing Functions {{{

    // Draw the node to a graphics buffer.
    // The bone is drawn as three disks aligned to each of the axis, and a
    // 2 pixel line to the parent bone.
    // param: gout - the output PGraphics display buffer
    protected void geom (PGraphics gout) {
        // Draw the disks
        pushStyle();
        pushMatrix();
        gout.noFill();
        gout.stroke(0xff0000ff);
        gout.ellipse(0,0,m_size,m_size);
        gout.rotateY(PI*0.5);
        gout.stroke(0xffff0000);
        gout.ellipse(0,0,m_size,m_size);
        gout.rotateX(PI*0.5);
        gout.stroke(0xff00ff00);
        gout.ellipse(0,0,m_size,m_size);
        popMatrix();
        popStyle();

        // Draw the line to the parent
        gout.pushStyle();
        gout.pushMatrix();
        gout.stroke(0xffffffff);
        gout.strokeWeight(2);
        Vec3D line = getVectorTo(getParent());
        gout.line(0,0,0,line.x,line.y,line.z);
        gout.popMatrix();
        gout.popStyle();
    }

    // id geometry. A sphere of the same size as the display disks
    protected void idGeom (PGraphics gout) {
        gout.sphere(m_size);
    }

    //}}}

    //--------------------------------------------------------------------------

    // Childing Functions {{{

    // Overridden CGraphNode method to divert the call to the new addChild
    // class. The default offset is set to 100.
    // param: _child - the CNode to add as a child. If it is a bone it will
    //      added at an offset of 100 in the y-axis.
    void addChild (CNode _child) {
        addChild(_child, 100);
    }

    // New addChild function to add the node and, in the case of adding
    // other CBones, adding them at an offset.
    // param: _child - the CNode to add as a child.
    // param: _offset - the offset to add the node at when _child is a CBone
    void addChild (CNode _child, float _offset) {
        if (_child instanceof CBone) {
            _child.position.x = _child.position.z = 0;
            _child.position.y = _offset;
        }
        super.addChild(_child);
    }

    //}}}
}

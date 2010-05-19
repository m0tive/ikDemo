class CBone extends CGraphNode {

    CBone (int _id) { super(_id); }
    CBone (float _x, float _y, float _z) { super(_x,_y,_z); }
    CBone (float _x, float _y, float _z, int _id) { super(_x,_y,_z,_id); }

    private int ring = 20;

    protected void geom (PGraphics gout) {
        pushStyle();
        pushMatrix();
        gout.noFill();
        gout.stroke(0xff0000ff);
        gout.ellipse(0,0,ring,ring);
        gout.rotateY(PI*0.5);
        gout.stroke(0xffff0000);
        gout.ellipse(0,0,ring,ring);
        gout.rotateX(PI*0.5);
        gout.stroke(0xff00ff00);
        gout.ellipse(0,0,ring,ring);
        popMatrix();
        popStyle();

        gout.pushStyle();
        gout.pushMatrix();

        gout.stroke(0xffffffff);
        gout.strokeWeight(2);

        Vec3D line = getVectorTo(getParent());
        gout.line(0,0,0,line.x,line.y,line.z);

        gout.popMatrix();
        gout.popStyle();
    }

    protected void idGeom (PGraphics gout) {
        gout.sphere(ring);
    }

    protected void displayChildren (PGraphics gout) {
        int size = m_children.size();
        for ( int i = 0 ; i < size ; ++i ){
            CNode child = (CNode) m_children.get(i);
//            float[] cpos = child.getPosition();
//
//            gout.pushStyle();
//
//            gout.stroke(0xffffffff);
//            gout.strokeWeight(2);
//            gout.line(0,0,0,cpos[0],cpos[1],cpos[2]);
//
//            gout.popStyle();

            child.display(gout);
        }
    }

    void addChild (CNode _child) {
        addChild(_child, 100);
    }

    void addChild (CNode _child, float _offset) {
        if (_child instanceof CBone) {
            _child.position.x = _child.position.z = 0;
            _child.position.y = _offset;
        }
        super.addChild(_child);
    }
}

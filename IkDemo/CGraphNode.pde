class CGraphNode extends CNode {

    ArrayList m_children = new ArrayList();

    CGraphNode () { super(); }
    CGraphNode (int _id) { super(_id); }
    CGraphNode (float _x, float _y, float _z) { super(_x,_y,_z); }
    CGraphNode (float _x, float _y, float _z, int _id) { super(_x,_y,_z,_id); }

    void addChild (CNode _child) {
        if (_child.getParent() == null) {
            m_children.add(_child);
            _child.setParent(this);
        }
    }

    boolean hasChild (CNode _child) {
        int size = m_children.size();
        for ( int i = 0 ; i < size ; ++i ){
            if ( _child == (CNode) m_children.get(i) )
                return true;
        }
        return false;
    }

    void display (PGraphics gout) {
        gout.pushMatrix();

        this.applyMatrix(gout);

//        gout.translate(m_x,m_y,m_z);
        gout.rotateX(m_pitch);
        gout.rotateY(m_yaw);
        gout.rotateZ(m_roll);

        this.geom(gout);

        displayChildren(gout);

        gout.popMatrix();
    }

    protected void displayChildren (PGraphics gout) {
        int size = m_children.size();
        for ( int i = 0 ; i < size ; ++i ){
             ((CNode) m_children.get(i)).display(gout);
        }
    }


    void idDisplay (PGraphics gout) {
        gout.pushMatrix();

        gout.translate(m_x,m_y,m_z);
        gout.rotateX(m_pitch);
        gout.rotateY(m_yaw);
        gout.rotateZ(m_roll);

        super.idDisplay(gout);
        idDisplayChildren(gout);

        gout.popMatrix();
    }

    protected void idDisplayChildren (PGraphics gout) {
        int size = m_children.size();
        for ( int i = 0 ; i < size ; ++i ){
             ((CNode) m_children.get(i)).idDisplay(gout);
        }
    }
}

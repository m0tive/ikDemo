class CIkChain extends CNode {

    private CBone[] m_chain;
    private CGraphNode m_goal;
    private PVector m_goalPos;

    CIkChain (CBone _begin, CBone _end) { this(_begin,_end,0); }
    CIkChain (CBone _begin, CBone _end, int _id) {
        super(_id);

        m_size = 50;

        buildChain(_begin,_end);
        _begin.addChild(this);

//        PMatrix3D bmat = par.getWorldMatrix();
//        PMatrix3D emat = _end.getWorldMatrix();
//
//        PVector eVect = new PVector();
//        emat.mult(new PVector(),eVect);
//        PVector bVect = new PVector();
//        bmat.mult(new PVector(),bVect);

//        m_x = eVect.x - bVect.x;
//        m_y = eVect.y - bVect.y;
//        m_z = eVect.z - bVect.z;



//        m_beginBone.addChild(this);
//        float[] bpos = m_beginBone.getWorldPosition();
//        float[] epos = m_endBone.getWorldPosition();
//        m_x = epos[0] - bpos[0];
//        m_y = epos[1] - bpos[1];
//        m_z = epos[2] - bpos[2];
    }

    void setGoal (CGraphNode _goal, boolean _snap) {
        if (_goal.getParent() == null)
            root.addChild(_goal);

        m_goal = _goal;

        // if snapping, move the goal node to the position of the end bone
        if (_snap) {
        }
    }

    void display (PGraphics gout) {
        this.update();
        super.display(gout);
    }

    protected void geom (PGraphics gout) {
        pushStyle();
        gout.noFill();
        gout.stroke(0xffff00ff);
        float halfsize = m_size*0.5;
        gout.line(-halfsize,0,0,halfsize,0,0);
        gout.line(0,-halfsize,0,0,halfsize,0);
        gout.line(0,0,-halfsize,0,0,halfsize);

        if (m_goal != null) {
            gout.line(0,0,0,m_goalPos.x,m_goalPos.y,m_goalPos.z);
        }

        popStyle();
    }

    protected void idGeom (PGraphics gout) {}

    void update () {
        if (m_goal != null) {
            PVector ngPos = m_goal.getWorldMatrix().mult(new PVector(), null);
            PVector chPos = this.getWorldMatrix().mult(new PVector(), null);

            PMatrix3D wMat = this.getWorldMatrix();
            wMat.invert();
            ngPos = wMat.mult(ngPos,null);

            m_goalPos = ngPos;

//            PMatrix3D rotator = new PMatrix3D ();
//            rotator.rotateX(m_pitch);
//            rotator.rotateY(m_yaw);
//            rotator.rotateZ(m_roll);
//            m_goalPos = rotator.mult(m_goalPos, null);
        }
    }

    // Build the array of bones. {{{
    // This is done backwards, stepping through the CNodes' parents from the
    // the end to the beginning.
    // False is returned if no link is found, or if the nodes are not CBones
    protected boolean buildChain (CBone _begin, CBone _end) {
        if (_begin == null || _end == null)
            return false;
        CGraphNode curr = _end;
        int i;
        for (i = 0; curr != _begin; ++i) {
            if (curr == null || !(curr instanceof CBone))
                return false;

            curr = curr.getParent();
        }

        // build array...
        m_chain = new CBone [i+1];

        curr = _end;
        for (int j = i-1; j != -1; --j) {
            m_chain[j] = (CBone) curr;
            curr = curr.getParent();
        }

        return true;
    } //}}}
}

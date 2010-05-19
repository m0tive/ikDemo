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
    }

    void setGoal (CGraphNode _goal, boolean _snap) {
        if (_goal.getParent() == null)
            root.addChild(_goal);

        m_goal = _goal;

        // if snapping, move the goal node to the position of the end bone
        if (_snap) {

            PVector move = m_goal.getVectorTo(m_chain[m_chain.length-1]);
            float[] pos = m_goal.getPosition();
            m_goal.setX(pos[0] + move.x);
            m_goal.setY(pos[1] + move.y);
            m_goal.setZ(pos[2] + move.z);
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
            m_goalPos = getVectorTo(m_goal);

            float dist = m_chain[m_chain.length-1].getVectorTo(m_goal).mag();
            if (dist < 0.001) dist = 0;
//            println("dist " + dist);

            PVector vect, vect2dA, vect2dB;
            PVector dir = new PVector(0,1,0);
            float cosAngle, angle, xrot, zrot;
            for (int i = m_chain.length - 2; i != -1; --i) {
                vect = m_chain[i].getVectorTo(m_goal);
                cosAngle = vect.dot(dir)/vect.mag();
//                println(m_chain[i].getId() + " " + cosAngle );

                if (cosAngle < 0.9) {
//                    angle = cos(cosAngle);
                    vect2dA = new PVector(vect.x,vect.y);
                    vect2dB = new PVector(dir.x,dir.y);
                    vect2dA.normalize();
                    vect2dB.normalize();
                    zrot = vect2dA.dot(vect2dB);
                    println("zrot " + zrot);
                    if (zrot < 0.9)
                        m_chain[i].m_roll += cos(zrot)*0.1;


                    vect2dA = new PVector(vect.y,vect.z);
                    vect2dB = new PVector(dir.y,dir.z);
                    vect2dA.normalize();
                    vect2dB.normalize();
                    xrot = vect2dA.dot(vect2dB);
                    println("xrot " + xrot);
                    if (xrot < 0.9)
                        m_chain[i].m_pitch += cos(xrot)*0.1;
                }
            }
            println("-");
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
        // loop backwards, adding bones.
        // This goes one beyond the first loop, adding _begin
        for (int j = i; j != -1; --j) {
            m_chain[j] = (CBone) curr;
            println(j);
            curr = curr.getParent();
        }

        return true;
    } //}}}
}

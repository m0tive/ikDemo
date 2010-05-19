class CIkChain extends CNode {

    private CBone[] m_chain;
    private CGraphNode m_goal;
    private Vec3D m_goalPos;

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
            Vec3D move = m_goal.getVectorTo(m_chain[m_chain.length-1]);
            m_goal.position.addSelf(move);
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

        if (m_goal != null && m_goalPos != null ) {
            gout.line(0,0,0,m_goalPos.x,m_goalPos.y,m_goalPos.z);
        }

        popStyle();
    }

    protected void idGeom (PGraphics gout) {}

    CBone getTip () {
        return m_chain[m_chain.length - 1];
    }

    void update () {
        if (m_goal != null) {
            m_goalPos = getVectorTo(m_goal);

            Vec3D goalVec, tipVec, rotAxis, upVec = new Vec3D(0,1,0);
            Quaternion currQuat = new Quaternion();
            float angle;
            int close = 0;

            float distance = 1;
            int k = 0;
            while(close != m_chain.length-1 && distance > 0.1 && k < 100) {
                for (int i = m_chain.length - 2; i != -1; --i) {
                    goalVec = m_chain[i].getVectorTo(m_goal);
                    tipVec = m_chain[i].getVectorTo(getTip());
                    angle = goalVec.angleBetween(tipVec,true);

                    if (angle > 0.00001) {
                        // get the rotation axis...
                        rotAxis = goalVec.cross(tipVec).normalize();

                        Quaternion goalQuat =
                            Quaternion.createFromAxisAngle(rotAxis,-angle);

                        // SLERP it...
                        Quaternion slerpQuat = 
                            currQuat.interpolateTo(goalQuat,0.5);

                        m_chain[i].rotation = m_chain[i].rotation.multiply(slerpQuat);
    //                    break;
                    } else {
                        ++close;
                    }

                }
                tipVec = m_goal.getVectorTo(getTip());
                distance = tipVec.magnitude();
                ++k;
            }

            // {{{
//            float dist = m_chain[m_chain.length-1].getVectorTo(m_goal).magnitude();
//            if (dist < 0.001) dist = 0;
// //            println("dist " + dist);
//
//            Vec3D vect;
//            Vec2D vect2dA, vect2dB;
//            Vec3D dir = new Vec3D(0,1,0);
//            float cosAngle, angle, xrot, zrot;
//            for (int i = m_chain.length - 2; i != -1; --i) {
//                vect = m_chain[i].getVectorTo(m_goal);
//                cosAngle = vect.dot(dir)/vect.magnitude();
// //                println(m_chain[i].getId() + " " + cosAngle );
//
//                if (cosAngle < 0.9) {
// //                    angle = cos(cosAngle);
//                    vect2dA = new Vec2D(vect.x,vect.y);
//                    vect2dB = new Vec2D(dir.x,dir.y);
//                    vect2dA.normalize();
//                    vect2dB.normalize();
//                    zrot = vect2dA.dot(vect2dB);
//                    println("zrot " + zrot);
//                    if (zrot < 0.9)
//                        m_chain[i].m_roll += cos(zrot)*0.1;
//
//
//                    vect2dA = new Vec2D(vect.y,vect.z);
//                    vect2dB = new Vec2D(dir.y,dir.z);
//                    vect2dA.normalize();
//                    vect2dB.normalize();
//                    xrot = vect2dA.dot(vect2dB);
//                    println("xrot " + xrot);
//                    if (xrot < 0.9)
//                        m_chain[i].m_pitch += cos(xrot)*0.1;
//                }
//            }
//            println("-"); //}}}
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

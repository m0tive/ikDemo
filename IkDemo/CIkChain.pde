class CIkChain extends CNode {

    private CBone m_beginBone, m_endBone;

    CIkChain (CBone _begin, CBone _end) { this(_begin,_end,0); }
    CIkChain (CBone _begin, CBone _end, int _id) {
        super(_id);
        m_beginBone = _begin;
        m_endBone = _end;

//        m_beginBone.addChild(this);
//        float[] bpos = m_beginBone.getWorldPosition();
//        float[] epos = m_endBone.getWorldPosition();
//        m_x = epos[0] - bpos[0];
//        m_y = epos[1] - bpos[1];
//        m_z = epos[2] - bpos[2];
    }

    private int ring = 100;

    protected void geom (PGraphics gout) {
        pushStyle();
        pushMatrix();
        gout.noFill();
        gout.stroke(0xffff00ff);
        
        gout.translate(m_x,m_y,m_z);
        gout.ellipse(0,0,ring,ring);
        gout.rotateY(PI*0.5);
        gout.ellipse(0,0,ring,ring);
        gout.rotateX(PI*0.5);
        gout.ellipse(0,0,ring,ring);
        popMatrix();

        gout.line(0,0,0,m_x,m_y,m_z);
        popStyle();
    }

    protected void idGeom (PGraphics gout) {
        gout.sphere(ring);
    }

    protected boolean buildChain (CBone _begin, CBone _end) {
        if (_begin == null || _end == null)
            return false;

        
    }
}

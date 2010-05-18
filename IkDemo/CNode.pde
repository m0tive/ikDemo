import java.lang.Integer;

class CNode{

    protected float m_x, m_y, m_z;
    float m_pitch, m_roll, m_yaw;
    protected int m_id;

    private CGraphNode m_parent;

    CNode() {
        this(0,0,0,0);
    }

    CNode(int _id) {
        this(0,0,0,_id);
    }

    CNode(float _x, float _y, float _z) {
        this(_x,_y,_z,0);
    }

    CNode(float _x, float _y, float _z, int _id) {
        m_x = _x;
        m_y = _y;
        m_z = _z;
        this.setId(_id);
    }

    void setX (float _x) {
        m_x = _x;
    }

    void setY (float _y) {
        m_y = _y;
    }

    void setZ (float _z) {
        m_z = _z;
    }

    float[] getPosition () {
        float[] out = {m_x,m_y,m_z};
        return out;
    }

    float[] getWorldPosition () {
        float[] out = {m_x,m_y,m_z};
        if ( m_parent != null )
        {
            float[] ppos = m_parent.getWorldPosition();
            out[0] += ppos[0];
            out[1] += ppos[1];
            out[2] += ppos[2];
        }
        return out;
    }

    int getId () {
        return m_id;
    }

    private void setId (int _id) {
        m_id = _id;
    }

    void setParent (CGraphNode _parent) {
        if (_parent == null) {
            if (m_parent != null && !m_parent.hasChild(this) ) {
                m_parent = null;
            }
        } else if (_parent.hasChild(this)) {
            if (m_parent == null || !m_parent.hasChild(this) ) {
                m_parent = _parent;
            }
        }
    }

    CGraphNode getParent () {
        return m_parent;
    }

    void display (PGraphics gout) {
        this.geom(gout);
    }

    void idDisplay (PGraphics gout) {
        pushStyle();

        gout.fill(0xFF000000 + m_id);

        this.idGeom(gout);

        popStyle();
    }

    protected void geom (PGraphics gout) {
    }

    protected void idGeom (PGraphics gout) {
        this.geom(gout);
    }

}

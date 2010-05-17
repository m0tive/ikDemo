import damkjer.ocd.*;

class CCamera extends Camera {

    protected float m_aspect, m_nearClip, m_farClip;

    CCamera(PApplet aParent, float aNearClip, float aFarClip)
    {
        super(aParent, aNearClip, aFarClip);
        m_aspect = (float)(1f * aParent.width / aParent.height);
        m_nearClip = aNearClip;
        m_farClip = aFarClip;
    }

    void feed(PGraphics g) {
        float[] p = super.position();
        float[] t = super.target();
        float[] u = super.up();

        g.perspective(super.fov(), m_aspect, m_nearClip, m_farClip);
        g.camera(p[0],p[1],p[2],
                 t[0],t[1],t[2],
                 u[0],u[1],u[2]);
    }
}

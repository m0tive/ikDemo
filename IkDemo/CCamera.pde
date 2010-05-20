import damkjer.ocd.*;

// Extend the Obsessive Camera Direction class to allow the user to use feed 
// on a alternative PGraphics.
class CCamera extends Camera {

    // Private info in Camera that we want to be protected
    protected float m_aspect, m_nearClip, m_farClip;

    // Constructor to capture some of the private info we need in feed.
    // param: aParent - parent applet
    // param: aNearClip - near clipping plane
    // param: aFarClip - far clipping plane
    CCamera(PApplet aParent, float aNearClip, float aFarClip)
    {
        super(aParent, aNearClip, aFarClip);
        // copied from damkjer OCD camera class source
        m_aspect = (float)(1f * aParent.width / aParent.height);
        m_nearClip = aNearClip;
        m_farClip = aFarClip;
    }

    // Alternative feed function.
    // param: g - The PGraphics buffer to apply camera setup to.
    void feed(PGraphics g) {
        // copied from damkjer OCD camera class source
        float[] p = super.position();
        float[] t = super.target();
        float[] u = super.up();

        g.perspective(super.fov(), m_aspect, m_nearClip, m_farClip);
        g.camera(p[0],p[1],p[2],
                 t[0],t[1],t[2],
                 u[0],u[1],u[2]);
    }
}

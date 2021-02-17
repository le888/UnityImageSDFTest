using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SDFObj : MonoBehaviour
{
    public static List<SDFObj> sDFObjs = new List<SDFObj>();
    public Vector3 opos = Vector3.zero;
    private void OnEnable() {
        sDFObjs.Add(this);
        SDFDraw.isDirt = true;

    }

    private void OnDisable() {
        sDFObjs.Remove(this);
        SDFDraw.isDirt = true;
    }
    
    // Update is called once per frame
    void Update()
    {
        if(!opos.Equals(transform.position))
        {
            SDFDraw.isDirt = true;
        }
    }
}

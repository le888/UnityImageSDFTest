using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class SDFDraw : MonoBehaviour
{
    public Mesh mesh;
    public Material material;
    // public Texture rt;
    public Mesh showMesh;
    public Material showMaterial;

    private CommandBuffer cmd;
    private int sdfId;

    public static bool isDirt = true;
    // Start is called before the first frame update
    private void Start()
    {
        var camera = Camera.main;
        cmd = new CommandBuffer();
        sdfId = Shader.PropertyToID("SDFTexture");
       
        Camera.main.AddCommandBuffer(CameraEvent.AfterSkybox, cmd);
    }
    public void ReDraw()
    {


        cmd.Clear();

        cmd.GetTemporaryRT(sdfId, -2, -2, 0, FilterMode.Bilinear);
        cmd.SetRenderTarget(sdfId);
        cmd.ClearRenderTarget(false, true, new Color(0, 0, 0, 0));
        Matrix4x4[] mtri = new Matrix4x4[SDFObj.sDFObjs.Count];
        for (int i = 0; i < mtri.Length; i++)
        {
            mtri[i] = SDFObj.sDFObjs[i].transform.localToWorldMatrix;
            cmd.DrawMesh(mesh, mtri[i], material, 0, 0);
        }
        cmd.Blit(sdfId, BuiltinRenderTextureType.CameraTarget, showMaterial);
        
    }

    // Update is called once per frame
    void Update()
    {
        if (isDirt)
        {
            isDirt = false;
            ReDraw();
        }
    }
}
